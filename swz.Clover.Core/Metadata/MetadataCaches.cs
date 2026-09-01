using Microsoft.Extensions.Logging;
using swz.Clover.Core.Model;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Threading;

namespace swz.Clover.Core.Metadata
{
    // These caches were originally in MetadataToModelConverter
    // and have been moved to their own class here now
    // so we can manage them better going forward.
    public class MetadataCaches
    {
        private readonly ConcurrentDictionary<string, EntityModel> ModelCache = new ConcurrentDictionary<string, EntityModel>();

        private readonly ConcurrentDictionary<string, FormDataMapping> MappingCache = new ConcurrentDictionary<string, FormDataMapping>();

        private readonly Lock boLock = new Lock();
        private string BusinessObjectsCache
        {
            get { lock (boLock) { return field; } }
            set { lock (boLock) { field = value; } }
        }

        //2026-07-08 - FormCache is supposed to use OrdinalIgnoreCase but I have reverted it to Ordinal for now. This means each
        //             casing requested would get its own cached form (e.g. QNN_SAMPLE vs qnn_sample ), but the forms aren't identical.
        //             It seems the clientside for data-mapping expects the name in the returned one to match the case it requested!
        //             And it seems the casing of the name in the cached form will match the casing requested when it was constructed!
        //             When they don't match, the data mapping UI in the admins panel will enter an infinite loop of requesting the form.
        private readonly ConcurrentDictionary<string, Form> FormCache 
            = new ConcurrentDictionary<string, Form>(StringComparer.Ordinal);

        private readonly Lock afcLock = new Lock();

        //TODO - check what callers are doing with this. e.g. Are any doing things like iterating this list to get one form? Should we make that list a case-insensitive dictionary? Does its order matter?
        /// <summary>
        /// Property holding the allforms cache with concurrency locking. (Private because used internally by the get and set method)
        /// The locking protects the reference to the list, too bad the list itself is mutable as are the form objects within it.
        /// So this lock is a bit like a gate in a fence where there isn't actually a fence...
        /// Hopefully we can refactor that at some point too, or at least make list object immutable (form would be much harder)
        /// </summary>
        private List<Form> AllFormsCache
        {
            get { lock (afcLock) { return field; } }
            set { lock (afcLock) { field = value; } }
        }

        //TODO - check what callers are doing with this. e.g. Are any doing things like iterating this list to get one form? Should we make that list a case-insensitive dictionary? Does its order matter?
        private readonly ConcurrentDictionary<Guid, List<Form>> SurveyFormsCache 
            = new ConcurrentDictionary<Guid, List<Form>>();

        private readonly ILogger<MetadataCaches> logger;

        private readonly Lock lfLock = new Lock();

        public DateTime LastFlushed
        {
            get { lock (lfLock) { return field; } }
            private set { lock (lfLock) { field = value; } }
        } = DateTime.Now; //using local rather than utc for consistency with other code accessing those columns

        public MetadataCaches(ILogger<MetadataCaches> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public void Flush()
        {
            DateTime now = DateTime.Now;
            if (logger.IsEnabled(LogLevel.Debug))
            {
                logger.LogDebug(nameof(Flush) + " - flushing caches at {0}, LastFlushed={1}", now, LastFlushed);
            }

            ModelCache.Clear();
            MappingCache.Clear();
            BusinessObjectsCache = null;
            FormCache.Clear();
            AllFormsCache = null;
            SurveyFormsCache.Clear();
            LastFlushed = now;
        }

        //20260707 - called by MSSQLMetadataProvider.GetForm
        public void SetForm(string name, Form form)
        {
            if (logger.IsEnabled(LogLevel.Debug))
                logger.LogDebug(nameof(SetForm) + " - name={0}", name);

            FormCache[name] = form;
        }

        //20260707 - called by MSSQLMetadataProvider.GetForm
        /// <summary>
        /// Try to get the named (case-insensitive) form from the FormCache.
        /// This serves both survey and non-survey forms.
        /// </summary>
        /// <param name="name">Name of form, this is case-insensitive here</param>
        /// <param name="form">If present the form will be returned via this out arg</param>
        /// <returns>true if an entry for the named form was found in the cache</returns>
        public bool TryGetForm(string name, out Form form)
        {
            bool inCache = FormCache.TryGetValue(name, out form);

            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(TryGetForm) + " - name={0}, inCache={1}", name, inCache);

            return inCache;
        }

        public void SetBusinessObjects(string businessObjects)
        {
            if (logger.IsEnabled(LogLevel.Debug))
                logger.LogDebug(nameof(SetBusinessObjects) + " - businessObjects.Length={0} chars", businessObjects?.Length);
            BusinessObjectsCache = businessObjects;
        }

        public bool TryGetBusinessObjects(out string businessObjects)
        {
            businessObjects = BusinessObjectsCache;
            bool inCache = (businessObjects != null);

            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(TryGetBusinessObjects) + " - inCache={0}", inCache);

            return inCache;
        }

        public void SetModel(string key, EntityModel model)
        {
            if (logger.IsEnabled(LogLevel.Debug))
                logger.LogDebug(nameof(SetModel) + " - Model.Name={0}, key={1}", model?.Name, key);

            ModelCache[key] = model;
        }

        public bool TryGetModel(string key, out EntityModel model)
        {
            bool inCache = ModelCache.TryGetValue(key, out model);

            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(TryGetModel) + " - key={0}, inCache={1}", key, inCache);

            return inCache;
        }

        public void SetMapping(string key, FormDataMapping mapping)
        {
            if (logger.IsEnabled(LogLevel.Debug))
                logger.LogDebug(nameof(SetMapping) + " - key={0}", key);

            MappingCache[key] = mapping;
        }

        public bool TryGetMapping(string key, out FormDataMapping mapping)
        {
            bool inCache = MappingCache.TryGetValue(key, out mapping);

            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(TryGetMapping) + " - key={0}, inCache={1}", key, inCache);

            return inCache;
        }

        //I would vastly have preferred this return a read only list, but needs changing the signature
        /// <summary>
        /// Returns a direct reference to the all forms cache . DO NOT MODIFY THE RETURNED OBJECT.
        /// </summary>
        /// <param name="forms"></param>
        public List<Form> GetAllFormsCache()
        {
            List<Form> cachedForms = AllFormsCache;
            bool inCache = cachedForms != null;

            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(GetAllFormsCache) + " - inCache={0}, cachedForms.count={1}", inCache, cachedForms?.Count);

            return inCache 
                ? cachedForms 
                : new List<Form>(); //TODO - can we use a flyweight here?
        } 
        
        public void SetAllFormsCache(List<Form> forms)
        {
            if (logger.IsEnabled(LogLevel.Debug))
                logger.LogDebug(nameof(SetAllFormsCache) + " - forms.Count={0}", forms?.Count);

            AllFormsCache = forms;
        }

        /// <summary>
        /// Returns a direct reference to the survey forms cache. DO NOT MODIFY THE RETURNED OBJECT.
        /// </summary>
        /// <param name="structDivisionId"></param>
        public List<Form> GetSurveyFormsCache(Guid? structDivisionId)
        {
            //I would vastly have preferred this return a read only list, but needs changing the signature

            Guid lookupKey = structDivisionId ?? Guid.Empty; //previously used string key "AllForms" for null sdi

            bool inCache = SurveyFormsCache.TryGetValue(lookupKey, out List<Form> cachedForms);

            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(GetSurveyFormsCache) + " -  inCache={0}, cachedForms.Count={1}", inCache, cachedForms?.Count);

            return inCache
                ? cachedForms
                : new List<Form>(); //TODO - can we use a flyweight here?
        }

        public void SetSurveyFormsCache(Guid? structDivisionId, List<Form> forms)
        {
            Guid lookupKey = structDivisionId ?? Guid.Empty; //previously used string key "AllForms" for null sdi

            // 20260707 - Where in the application is this actually passed a null structDivisionId?
            // Currently only caller is CopySurveyFormsCache in MetadataToModelConverter. 
            // That is also passed the structDivisionId
            // One caller to that is LocalizationUpdateTemplate which passes currentUser?.StructDivisionId
            // Not sure that method even needs survey forms. If there's no user then it will pass null
            // This would be the case for a background batch job. But Im dubious survey forms will be used in this method.
            // The other place calling that is PartialMetadata which also passed currentUser?.StructDivisionId
            // So the batch job need would arise again. 
            // I think we leave this as is for now then in case batch jobs need it.

            if (logger.IsEnabled(LogLevel.Debug))
                logger.LogDebug(nameof(SetSurveyFormsCache) + " - key={0}, forms.Count={1}", lookupKey, forms?.Count);

            SurveyFormsCache[lookupKey] = forms;
        }
    }
}
