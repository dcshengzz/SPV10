using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Logging;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;

namespace swz.SurveyPlus.ApiSupport
{
    public class MemoryMetadataSourceCache : IMetadataSourceCache
    {
        private const string nullRecord = "MMSC-886d6080-c3f9-4be0-95b7-d627e7819eaa::NULL"; //unique value we'll use to record 'null' results
        private const string keyPrefix = "MMSC-46688ce3-99fc-4720-8398-2df275a859a0::"; //unique prefix to avoid clashing with other MC users
        
        private readonly IMemoryCache memoryCache;
        private readonly ILogger<MemoryMetadataSourceCache> logger;
        private readonly ConcurrentDictionary<string, bool> keysForClearCache = new ConcurrentDictionary<string, bool>();
        private readonly UnifiedAtAppSetting unifiedAtAppSetting;

        public MemoryMetadataSourceCache(
            IMemoryCache memoryCache, 
            ILogger<MemoryMetadataSourceCache> logger,
            UnifiedAtAppSetting unifiedAtAppSetting)
        {
            this.memoryCache = memoryCache ?? throw new ArgumentNullException(nameof(memoryCache));
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.unifiedAtAppSetting = unifiedAtAppSetting ?? throw new ArgumentNullException(nameof(unifiedAtAppSetting));

            //Should use NullMetadataSourceCache instead of this if not caching
            if (unifiedAtAppSetting.MetadataSourceCacheSeconds <= 0)
                throw new ArgumentException(
                    nameof(unifiedAtAppSetting), 
                    $"{nameof(MemoryMetadataSourceCache)} requires {nameof(UnifiedAtAppSetting.MetadataSourceCacheSeconds)} to be greater than zero");
        }

        /// <summary>
        /// Remove any entries for keys known at the time this is called. 
        /// </summary>
        public void ClearCache()
        {
            bool traceLoggingEnabled = logger.IsEnabled(LogLevel.Trace);
            
            //We need to use keysForClearCache to keep track of what to remove because IMemoryCache doesn't provide
            //a way to enumerate the entries. We're now using a ConcurrentDictionary rather than a ConcurrentBag
            //because IMemoryCache also doesn't see fit to inform us when it removes expired entries, so using a bag
            //there is nothing to constrain the bag growth, we could end up with something.json repeated a million times...

            //Unfortunately Netcore doesn't provide a ConcurentHashSet - which is what we really want.
            //For some discussion on why see: https://github.com/dotnet/runtime/issues/39919

            //copy current key list so we can remove while iterating
            List<string> keys = new List<string>(keysForClearCache.Keys);

            if (traceLoggingEnabled) logger.LogTrace(nameof(ClearCache) + " - called, {0} items to be removed", keys.Count);

            //nb: for this use case we aren't really worried about whether other threads replace
            //    or update the entries we are iterating over for the removal, but we don't use Clear()
            //    on keysForClearCache because of the chance of something being added between copying the
            //    the keys and clearing the dictionary, which would lead to entries in the cache that can't
            //    be cleared (until they are expired or replaced)
            foreach (string key in keys)
            {
                if (traceLoggingEnabled) 
                    logger.LogTrace(nameof(ClearCache) + " - removing item {0}", key.Replace(keyPrefix,""));
                memoryCache.Remove(key);
                keysForClearCache.TryRemove(key, out var _);
            }                
        }

        /// <summary>
        /// Updates the value for the metadata source string in the memory cache.
        /// This is a naive implementation, it just overwrites any existing value for it 
        /// and sets this value with the configured expiration period. 
        /// </summary>
        public void SetSource(string file, string folder, string source) 
        {
            if (source == null) throw new ArgumentNullException(nameof(source)); //nb: it CAN be empty (eg, common for .js files)
            AddCacheEntry(file, folder, source);
        }

        public void SetNullSource(string file, string folder)
        {
            AddCacheEntry(file, folder, nullRecord);
        }

        public bool TryGetSource(string file, string folder, out string source)
        {
            string key = Key(file, folder);
            string value = memoryCache.Get<string>(key);
            bool found = (value != null);
            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(TryGetSource) + " - found={0}, item={1}", found, key.Replace(keyPrefix, ""));
            source = nullRecord.Equals(value) ? null : value;
            return found; //nb: it CAN be empty (eg, common for .js files)
        }

        private void AddCacheEntry(string file, string folder, string source)
        {
            if (source == null) throw new ArgumentNullException(nameof(source)); //nb: it CAN be empty (eg, common for .js files)
            string key = Key(file, folder);

            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(SetSource) + " - item={0}", key.Replace(keyPrefix, ""));

            keysForClearCache.TryAdd(key, true);
            memoryCache.Set<string>(key, source, CacheOptions());            
        }

        private string Key(string file, string folder)
        {
            if (string.IsNullOrEmpty(file)) throw new ArgumentException(nameof(file));
            if (string.IsNullOrEmpty(folder)) throw new ArgumentException(nameof(folder));
            return keyPrefix + folder + "/" + file;
        }

        private MemoryCacheEntryOptions CacheOptions()
        {
            MemoryCacheEntryOptions options = new MemoryCacheEntryOptions();
            options.SetAbsoluteExpiration(TimeSpan.FromSeconds(unifiedAtAppSetting.MetadataSourceCacheSeconds));
            options.RegisterPostEvictionCallback(LogEviction);
            return options;
        }

        private void LogEviction(object keyObject, object value, EvictionReason reason, object state)
        {
            string key = (string)keyObject;
            //nb: for expired items they are removed 'lazily' so don't expect to see this callback immediately
            //    after the expiry time (but you will notice the expired items aren't found on requests for them
            //    after their expiry time). For this reason we *don't* remove expired names from the list of
            //    keys to clear, because they might get added back before we get this callback, and removal from 
            //    the name list would thus just make the new entry immune to ClearCache.    
            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(LogEviction) + " - reason={0}, item={1}", reason, key.Replace(keyPrefix, ""));
        }
    }
}
