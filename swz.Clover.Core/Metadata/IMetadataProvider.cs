using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

namespace swz.Clover.Core.Metadata 
{
    public interface IMetadataProvider
    {

        #region CommonOrCore
       
        /// <summary>
        /// Returns a collection of metadata with the requested sections (for supported types) populated 
        /// (Previously named GetCollectionAsync)
        /// </summary>
        Task<Metadata> PartialMetadata(List<MetadataSectionQuery> queries);

        /// <summary>
        /// Returns a collection of metadata with most (hence the name 'Full') sections populated.
        /// (Previously handled by GetCollectionAsync(null))
        /// </summary>
        Task<Metadata> FullMetadata();

        //TODO - what is the case-sensitivity of a formName?
        /// <summary>
        /// Get a form, including form settings, json, js, and css (where applicable). 
        /// Each of these is a seperate file in dwMetadata
        /// Implementations may use a cache here.
        /// </summary>
        Form GetForm(string formName);

        string GetFormSource(string name);

        JToken GetLocalizationForForm(string name, string lang);

        string GetLocalizationScript(string lang);

        #endregion CommonOrCore

        // ................................................................

        #region IntranetOnly

        bool BlockMetadataChanges { get; }  //Used by WorkfowController.DesignerAPI

        /// <summary>
        /// Returns the content for businessobjects.js
        /// </summary>
        string GetBusinessObjects(); //only called via this interface from intranet

        /// <summary>
        /// Not implemented by InternetApiMetadataProvider
        /// </summary>
        List<string> GetWorkflowByForm(string formname);

        /// <summary>
        /// Not implemented in the InternetApiMetadataProvider, this is implemented in MSSQLMetadataProvider and used on the
        /// intranet side to fetch and modify metadata by the admins console, user admin, and form designer apps.
        /// Callers should have already checked security concerns before calling this as it can manage most metadata.
        /// </summary>
        Task<object> ConfigAPI(NameValueCollection form, Stream filestream = null);

        /// <summary>
        /// Not implemented in InternetApiMetadataProvider this is a kludge used by some functionality in the intranet side.
        /// It returns a new, independent SHALLOW-copy of the SurveyFormsCache list for the current user's struct division from the MetadataToModelConverter.
        /// TODO - I would like this method to be removed from this interface if practical
        /// </summary>
        List<Form> CopySurveyFormsCache(Guid? structDivisionId); //outside the provider this only called by SurveyFormController

        Form GetFormsSettings(string formName); //InternetAPIMetadataProvider uses its impl internally, but internet doesn't call it via interface now

        #endregion IntranetOnly

        // ................................................................

        #region InternetOnly

        //The following methods provide some special support for the internet application and
        //aren't used by intranet

        /// <summary>
        /// Returns the javascript for a specific form's action handlers.
        /// nb: the implementation in MSSQLMetadataProvider will assemble businessobjects for all application forms if
        ///     passed null for name, while InternetApiMetadata will throw an ArgumentNullException for that case.
        /// </summary>
        string GetFormsBusinessCode(string name); //only called *via this interface* from internet

        #endregion InternetOnly
    }

    public class MetadataSectionQuery  
    {
        public string Section { get;}
        public int PageSize { get; }
        public int Start { get; }
        public bool UsePaging { get; }

        public MetadataSectionQuery(string section)
        {
            Section = section;
            UsePaging = false;
        }
        
        public MetadataSectionQuery(string section, int pageSize, int start)
        {
            Section = section;
            UsePaging = true;
            PageSize = pageSize;
            Start = start;
        }
    }
}
