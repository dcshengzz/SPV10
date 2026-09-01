using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Threading.Tasks;
using System.IO;
using System.Text;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using swz.Clover.Core.Metadata;
using DataModel = swz.Clover.Core.Metadata.DataModel;
using Metadata = swz.Clover.Core.Metadata.Metadata;
using System.Net.Http;
using System.Web;
using swz.SurveyPlus.Application;
using static swz.SurveyPlus.ApiSupport.UAppUtils;

namespace swz.SurveyPlus.ApiSupport
{
    /// <summary>
    /// Alternate minimal implementation of IMetadataProvider for use on the internet side with U@App
    /// This only needs to support a subset of the functionality and should fail-fast for unsupported requests.
    /// </summary>
    public class InternetApiMetadataProvider : IMetadataProvider
    {
        private const string formPostfix = ".json";
        private const string formSettingsPostfix = "-settings.json";
        private const string formCodePostfix = "-code.js";
        private const string formCssCodePostfix = ".css";
        private const string localizationPostfix = ".json";
        private const string baselocalization = "base";
        private const string metadataFolderName = "metadata";
        private const string metadataFileName = "metadata.json";
        private const string metadataFormsFolderName = "metadata/forms";
        private const string metadataLocalizationFolderName =  "metadata/localization";

        private readonly ILogger logger;
        private readonly WebApiAdditionalHeaderOptions apiHeaderOptions;
        private IHttpClientFactory httpClientFactory;
        private readonly IMetadataSourceCache sourceCache;

        public bool BlockMetadataChanges { get; } = true; //its an error if internet application wants to update the metadata

        public InternetApiMetadataProvider(
            ILogger<InternetApiMetadataProvider> logger,
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            IHttpClientFactory httpClientFactory,
            IMetadataSourceCache sourceCache)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.apiHeaderOptions = apiHeaderOptions ?? throw new ArgumentNullException(nameof(apiHeaderOptions));
            this.httpClientFactory = httpClientFactory ?? throw new ArgumentNullException(nameof(httpClientFactory));
            this.sourceCache = sourceCache ?? throw new ArgumentNullException(nameof(sourceCache)); 
        }

        public string GetBusinessObjects()
        {
            throw new NotImplementedException($"{nameof(GetBusinessObjects)} is not implemented in {nameof(InternetApiMetadataProvider)}");
        }

        public async Task<object> ConfigAPI(NameValueCollection form, Stream filestream = null)
        {
            throw new NotImplementedException($"nameof(ConfigAPI) is not implemented in {nameof(InternetApiMetadataProvider)}");
        }

        public List<string> GetWorkflowByForm(string formName)
        {
            throw new NotImplementedException($"{nameof(GetWorkflowByForm)} is not implemented in {nameof(InternetApiMetadataProvider)}");
        }

        public List<Form> CopySurveyFormsCache(Guid? structDivisionId)
        {
            throw new NotImplementedException($"{nameof(CopySurveyFormsCache)} is not implemented in {nameof(InternetApiMetadataProvider)}");
        }

        /// <summary>
        /// Internet-side implementation of GetCollectionAsync that can return a subset of the metadata, basically the minimum
        /// required to support the internet application.
        /// </summary>
        public async Task<Metadata> PartialMetadata(List<MetadataSectionQuery> queries)
        {
            if (queries == null || !queries.Any()) 
                throw new ArgumentException(nameof(queries), "No queries were specified");

			Metadata coll;
            coll = new Metadata();

            foreach (MetadataSectionQuery query in queries)
            {
                switch (query.Section)
                {
                    case MetadataSections.Datamodel:
                        //MetadataToModelConverter needs this
                        //TODO - this gets something like 114 items of which most is only relevant to intranet :-(
                        Metadata loadedColl = await GetMetadata(); //Fetch and parse metadata.json (will use source cache)
                        coll.DataModel = loadedColl.DataModel ?? new List<DataModel>();
                        break;
                    
                    case MetadataSections.Codeactions:
                        coll.CodeActions = new List<CodeAction>(); //Internet side doesn't need these
                        break;

                    case MetadataSections.Form:
                    case MetadataSections.Businessflow:
                    case MetadataSections.AppSettings:                        
                    case MetadataSections.Users:
                    case MetadataSections.Roles:
                    case MetadataSections.Groups:
                    case MetadataSections.Permissions:
                    case MetadataSections.Workflow:
                    case MetadataSections.Localization:
                        throw new NotImplementedException($"{query.Section.ToString()} is not implemented here");

                    default:
                        throw new NotImplementedException($"Unknown section {query.Section.ToString()}");
                }
            }            
            return coll;
        }

        public async Task<Metadata> FullMetadata()
        {
            throw new NotImplementedException($"{nameof(PartialMetadata)} is not implemented in {nameof(InternetApiMetadataProvider)}");
        }

        public object GetLocalization(string local)
        {
            string source = null;
            if (TryGetMetadataSynchronously(local + localizationPostfix, metadataLocalizationFolderName, out string localSource))
            {
                source = localSource;
            }
            else if (local == baselocalization)
            {
                source = @"{
            ""common"": {

            },
            ""msg"":{

            }
        }";
            }
            else
            {
                var baseobj = GetLocalization(baselocalization);
                source = ((dynamic)baseobj).source;
            }

            return new
            {
                name = local,
                source
            };
        }

        public JToken GetLocalizationForForm(string name, string lang)
        {
            if (!TryGetMetadataSynchronously(lang + localizationPostfix, metadataLocalizationFolderName, out string localSource)
            ) return null;
            var json = JToken.Parse(localSource);
            var item = json?["forms"]?.FirstOrDefault(c => name.Equals((c as JProperty)?.Name, StringComparison.OrdinalIgnoreCase));
            return item?.First();
        }

        public Form GetFormsSettings(string formName)
        {
            Form form = null;
            if (TryGetMetadataSynchronously(formName + formSettingsPostfix, metadataFormsFolderName, out string source))
            {
                form = JsonConvert.DeserializeObject<Form>(source);
            }
            return form;
        }

        public string GetLocalizationScript(string lang)
        {
            dynamic locale = GetLocalization(lang);
            if (locale != null)
            {
                //TODO - why no terminating semicolon?
                return $"window.CloverLang = {locale.source}";
            }
            return string.Empty;
        }

        public string GetFormsBusinessCode(string name)
        {
            if (string.IsNullOrEmpty(name)) throw new ArgumentException(nameof(name));
            Form formSettings = GetFormsSettings(name);
            if (formSettings == null) throw new ArgumentException($"Form {name} does not exist", nameof(name));
            bool IsInternetSurvey = formSettings.IsSurvey;
            if (!IsInternetSurvey && name != "respdashboard" && name != "RespAccountChangePassword" && name != "spheader")
                return null;
            var jscode = GetFormCode(name);
            StringBuilder formcodesource = new StringBuilder();
            formcodesource.AppendFormat("var {0}UserActions = {1};", name.ToLower(), string.IsNullOrWhiteSpace(jscode) ? "{}" : jscode);
            return formcodesource.ToString();
        }

        //Moved from MetadataToModelConverter and merged with the GetForm here
        public Form GetForm(string formName)
        {
            //Internet metadata provider relies on the IMetadataSourceCache to cache form json and
            //doesn't use the MetadataCaches object to cache the final Form objects here. (The source
            //cache covers the main overhead of fetching the json from intranet side, and it has configurable
            //timeouts for how long it caches json. The MetadataCaches have no timeouts and since we have the
            //source cache already they would save us only the small overhead of deserialising -settings.json
            //and assembling an instance of Form)
            return GetFormAsync(formName).GetAwaiter().GetResult();  //this is sync-over-async
        }

        public string GetFormPath(string formName)
        {
            return Path.Combine(metadataFormsFolderName, formName);
        }

        public string GetFormSource(string name)
        {
            return TryGetMetadataSynchronously(name + formPostfix, metadataFormsFolderName, out string localSource) ? localSource : null;
        }

        public string GetFormCode(string name)
        {
            return TryGetMetadataSynchronously(name + formCodePostfix, metadataFormsFolderName, out string localSource) ? localSource : null;
        }

        public string GetCssCode(string name)
        {
            return TryGetMetadataSynchronously(name + formCssCodePostfix, metadataFormsFolderName, out string localSource) ? localSource : null;
        }

        private async Task<Form> GetFormAsync(string formName)
        {
            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(GetFormAsync) + " - formName={0}", formName);

            //TODO - push this marshalling work to the intranet side as a new endpoint so we can return the lot in ONE call
            //       alternately, Im considering using a memory cache (keyed by folder/filename) for the string content with expiration times
            //       though we would still want the initial call to be single 
            string settingsJson = await GetMetadataContentOrNullAsync(formName + formSettingsPostfix, metadataFormsFolderName);
            //if the settings aren't found, create a new empty Form object with that name and populate that 
            Form form = (settingsJson != null) ? JsonConvert.DeserializeObject<Form>(settingsJson) : new Form();
            form.Name = formName;
            form.Source = await GetMetadataContentOrNullAsync(formName + formPostfix, metadataFormsFolderName);
            form.JavaScriptCode = await GetMetadataContentOrNullAsync(formName + formCodePostfix, metadataFormsFolderName);
            form.CssCode = await GetMetadataContentOrNullAsync(formName + formCssCodePostfix, metadataFormsFolderName);
            return form;
        }

        /// <summary>
        /// Fetch Metadata from the intranet side (content in dwMetadata for metadata.json)
        /// </summary>
        private async Task<Metadata> GetMetadata()
        {
            try
            {
                string json = await GetMetadataContentAsync(fileName: metadataFileName, folderName: metadataFolderName);
                Metadata metadata = JsonConvert.DeserializeObject<Metadata>(json);
                return metadata;
            }
            catch(Exception e)
            {
                throw new Exception($"Failed to fetch {metadataFileName}", e);
            }
        }

        /// <summary>
        /// Check the cache or call the intranet side u@app api to retrieve the content of a single file in dwMetadata
        /// </summary>
        private async Task<string> GetMetadataContentAsync(string fileName, string folderName)
        {
            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(GetMetadataContentAsync) + " - folderName={0}, fileName={1}", folderName, fileName);

            if (fileName == null) throw new ArgumentNullException(nameof(fileName));
            if (folderName == null) throw new ArgumentNullException(nameof(folderName));
            try
            {
                if(!sourceCache.TryGetSource(file: fileName, folder: folderName, out string source))
                {
                    try
                    {
                        string partialUrl
                            = Constants.UAppRoutes.Metadata
                            + "?folderName=" + HttpUtility.UrlEncode(folderName)
                            + "&fileName=" + HttpUtility.UrlEncode(fileName);
                        TraceLogHttpClient(logger, "GetMetadata", partialUrl);
                        source = await SendApiRequestAsync(
                            httpClientFactory,
                            apiHeaderOptions,
                            ApiRequest.GetWithoutAccessToken(partialUrl),
                            applyResponseValidationHeuristics: false);

                        //nb: due to concurrent requests and the delay involved in requesting from intranet
                        //    it is very likely that the source will get set into the cache multiple times
                        //    as multiple requests eventually return their results here while the cache is
                        //    still cold (but this is not expected to cause us problems, the cache is just
                        //    an optimisation). 
                        sourceCache.SetSource(file: fileName, folder: folderName, source);
                    }
                    catch (ApiRequestException are)
                    {
                        if (System.Net.HttpStatusCode.NotFound == are.StatusCode)
                        {
                            //Record in the cache that we didn't find it so we don't keep requesting it from intranet everytime
                            //(looking at you .css files, but also common for some .js files)
                            sourceCache.SetNullSource(file: fileName, folder: folderName);

                            //We're using 404 for when its not found. For more discussion on which http code to use see
                            //https://stackoverflow.com/questions/5604816/whats-the-most-appropriate-http-status-code-for-an-item-not-found-error-page
                            //(... so if you get this for _all_ metadata then maybe the endpoint itself moved!)
                            throw new NotFoundException($"Metadata file {fileName} not found in folder {folderName}", are);
                        }                            
                        else
                        {
                            throw; //for other problems we'll let the outer block log and wrap it
                        }
                    }
                }
                else
                {
                    //Value was available in cache, so we can avoid a trip to the intranet
                    //If we explicitly recorded a null then treat that as not found (lest we keep hitting intranet for everything.css etc...)
                    if(source==null)
                        throw new NotFoundException($"Cache records that metadata file {fileName} was not found in folder {folderName}");
                }
                return source;                
            }
            catch(NotFoundException nfe)
            {
                if (logger.IsEnabled(LogLevel.Trace))
                    logger.LogTrace(nameof(GetMetadataContentAsync) + " - Not Found: {0}", nfe.Message);
                throw;
            }
            catch (Exception oopsyWoopsie)
            {
                logger.LogDebug(oopsyWoopsie, nameof(GetMetadataContentAsync) + " encountered an unexpected exception: {0}", oopsyWoopsie.Message);
                throw new Exception($"Failed to fetch metadata file {fileName} in folder {folderName}", oopsyWoopsie);
            }
        }

        /// <summary>
        /// Sync-over-Async kludge to try and get the metadata and return false if it is not found, otherwise return it in the out param 'source'
        /// </summary>
        private bool TryGetMetadataSynchronously(string fileName, string folderName, out string source)
        {
            //sync-over-async :-(
            //See also notes in my comments on SecurityProvider.CurrentUser about sync over async
            //TODO - this method is nasty, can we refactor? Its tricky because its calling code is mostly syncronous methods specified
            //       in IMetadataProvider and called from many places in core :-(
            source = GetMetadataContentOrNullAsync(fileName, folderName).GetAwaiter().GetResult();
            return (source != null);
        }

        /// <summary>
        /// Syntactic sugar that will catch the NotFoundException and return null when the metadata is not found
        /// instead of raising the exception
        /// </summary>
        private async Task<string> GetMetadataContentOrNullAsync(string fileName, string folderName)
        {
            try
            {
                return await GetMetadataContentAsync(fileName: fileName, folderName: folderName);
            }
            catch (NotFoundException)
            {
                return null;
            }
        }

        /// <summary>
        /// Returns the name without the postfix part (used to get form name from the full filename)
        /// </summary>
        private string GetSubName(string s, string postfix)
        {
            return s.Substring(0, s.Length - postfix.Length);
        }
    }
}