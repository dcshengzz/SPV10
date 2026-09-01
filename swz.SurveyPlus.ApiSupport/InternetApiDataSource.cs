using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using swz.Clover.Core.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using swz.Clover.Core.View;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using Microsoft.Net.Http.Headers;
using static swz.SurveyPlus.ApiSupport.UAppUtils;
using swz.Clover.Core.IntegrationApi;

namespace swz.SurveyPlus.ApiSupport
{
    // note: DataSource and ApiDataSource used to be a bunch of static methods.
    // In commit [6ed61bb] we changed it to go through an interface so we can change which implementation
    // is used (eg: see InternetConfiguratorUApp) and commit [497d923] was the one that changed
    // to VSPListSampleInfoResp from VSPListSampleInfo (the new view has performance enhancements)
    // and 20230207 we are finally removing the use of swagger and optimising further to reduce the number of
    // requests it makes across the u@app api

    /// <summary>
    /// Minimal Implementation of the IDataSource interface for the internet application when using U@App.
    /// DO NOT EXPECT THIS CLASS TO WORK LIKE THE REGULAR DB DataSource. 
    /// </summary>

    public class InternetApiDataSource : IDataSource
    {
        private const string ApiNotSupported = "The IDataSource API is not supported here";

        private readonly ILogger<InternetApiDataSource> logger;
        private readonly IHttpClientFactory httpClientFactory;
        private readonly WebApiAdditionalHeaderOptions apiHeaderOptions;
        private readonly IInternetApiTokenManager internetApiTokenManager;
        
        public InternetApiDataSource(
            ILogger<InternetApiDataSource> logger,
            IHttpClientFactory httpClientFactory,            
            WebApiAdditionalHeaderOptions apiHeaderOptions,
            IInternetApiTokenManager internetApiTokenManager)
        {
            this.httpClientFactory = httpClientFactory ?? throw new ArgumentNullException(nameof(httpClientFactory));
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger)); ;
            this.apiHeaderOptions = apiHeaderOptions ?? throw new ArgumentNullException(nameof(apiHeaderOptions));
            this.internetApiTokenManager = internetApiTokenManager ?? throw new ArgumentNullException(nameof(internetApiTokenManager));
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace("Constructor called, httpClientFactory={0}, apiHeaderOptions.AddAdditionalHeader={1}",
                    httpClientFactory,
                    apiHeaderOptions.AddAdditionalHeader);
            }
        }

        /// <summary>
        /// Will call ChangeApiDataForUrlAsync with the request and the model named in the request.
        /// Only supports targets DataUrl relative to the u@app api base path.
        /// (Used to send responses to the intranet side under u@app)
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        public async Task<(FailResponse fail, ItemSuccessResponse<ChangeDataResponce> success)> ChangeData(ChangeDataRequest request)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(ChangeData) + " - Name={0}, RequestingControl={1}",
                    request?.Name, request?.RequestingControl);
            }

            EntityModel model 
                = await MetadataToModelConverter.GetEntityModelByFormAsync(
                    request.Name,
                    new BuildModelOptions(ignoreNameCase: true, requestingControl: request.RequestingControl, strategy: BuildModelStartegy.ForChange));

            if (!string.IsNullOrEmpty(model.DataUrl))
            {
                string respDataUrl
                        = Constants.UAppRoutes.ResponseData
                        .Replace("{form}", request.Name);
                return await ChangeApiDataForUrlAsync(request, respDataUrl);
            }
            else
            {
                //Currently ChangeData is only used for surveys via DataUrl, if need to use for other forms then maybe can 
                //add explicit coding checking their names above. If not going via data url will need explicit support as the
                //ORM isn't functional on the internet side due to lack of direct db connection under u@app.
                throw new NotImplementedException("Changing data for models without a DataUrl is not supported here");
            }

            //DynamicEntity data = new DynamicEntityDeserializer(model).DeserializeSingle(request.Data);
            //await model.UpdateSingleAsync(data);
            //return (null, new ItemSuccessResponse<ChangeDataResponce>(new ChangeDataResponce() { EntityId = data.GetPrimaryKey(), Entity = data.ToDictionary(true) }));
        }

        /// <summary>
        /// n.b we only support urls relative to the api base path here
        /// </summary>
        private async Task<(FailResponse fail, ItemSuccessResponse<ChangeDataResponce> success)> ChangeApiDataForUrlAsync(ChangeDataRequest request, string dataUrl)
        {
            if (request == null) throw new ArgumentNullException(nameof(request));
            if (string.IsNullOrEmpty(dataUrl)) throw new ArgumentException(nameof(dataUrl));
            if (UAppUtils.GetApiBasePath() == null)
            {
                //Fail-fast as we don't support non API target's here (for reference, compare with the regular DataSource impl which has an isLocal flag)
                throw new InvalidOperationException($"ApiBasePath is not set in the CloverRuntime/Metadata, dataUrl={dataUrl}");
            }
            Dictionary<string, string> headers = request.GetHeadersForLocalRequest(); //its not actually a local request but we use this anyway ... :-/
            if (headers == null) throw new InvalidOperationException("request.GetHeadersForLocalRequest returned null");

            string result = null;
            using (HttpClient client = httpClientFactory.CreateClient())
            {
                string targetUrl = $"{UAppUtils.GetApiBasePath()}{dataUrl.TrimStart(' ', '/')}";

                if (!headers.ContainsKey(IntegrationApiKeys.HeaderApiKey))
                {
                    //clover-apikey
                    client.DefaultRequestHeaders.Add(IntegrationApiKeys.HeaderApiKey, CloverRuntime.IntegrationApiKey);
                }

                //For API we need to include the accesstoken (sample specific jwt)
                if (!headers.ContainsKey(HeaderNames.Authorization))
                {
                    string accessToken = AccessToken();
                    //TODO - consider having a fail-fast here if the token is null
                    client.DefaultRequestHeaders.Add(HeaderNames.Authorization, $"Bearer {accessToken}");
                }

                //Include the additional header (this is customer environment dependent,
                //e.g. some customers want an extra header for a gateway key)
                if (apiHeaderOptions.AddAdditionalHeader)
                {
                    client.DefaultRequestHeaders.Add(apiHeaderOptions.Name, apiHeaderOptions.Value);
                }

                //Pass along request's headers to intranet side
                foreach (KeyValuePair<string, string> p in headers)
                {
                    client.DefaultRequestHeaders.Add(p.Key, p.Value);
                }
                    
                MultipartFormDataContent multiContent = new MultipartFormDataContent { { new StringContent(request.Data, Encoding.UTF8, "application/json"), "data" } };
                try
                {
                    if (logger.IsEnabled(LogLevel.Trace))
                    {
                        logger.LogTrace(nameof(ChangeApiDataForUrlAsync) + " - posting data for {0} to url={1}", 
                            request.Name, //0
                            targetUrl); //1
                    }

                    using (HttpResponseMessage res = await client.PostAsync(targetUrl, multiContent))
                    {
                        if (!res.IsSuccessStatusCode)
                        {
                            logger.LogError(nameof(ChangeApiDataForUrlAsync) + " - unsuccessful status {0} for {1} from url={2}",
                                res.StatusCode, //0
                                request.Name, //1
                                targetUrl); //2
                        }
                        //Even if unsuccessful, we will continue executing here to preserve the behaviour of the existing logic which
                        //doesn't check if its http call failed or not. I would like to change this but an unsure if anything else
                        //depends on this behaviour and time does not permit investigation now.
                        using (HttpContent content = res.Content)
                        {
                            result = await content.ReadAsStringAsync();
                            if (logger.IsEnabled(LogLevel.Trace))
                            {
                                string resultSizeUnquoted = (result == null ? "null string" : result.Length + " characters"); //safe for direct inclusion in log string
                                logger.LogTrace(nameof(ChangeApiDataForUrlAsync) + " - status {0} for {1} from url={2}, result size is " + resultSizeUnquoted,
                                    res.StatusCode, //0
                                    request.Name, //1
                                    targetUrl); //2
                            }

                            JToken token;
                            try
                            {
                                token = JToken.Parse(result);
                            }
                            catch (Exception parseFailure)
                            {
                                logger.LogError(parseFailure, nameof(ChangeApiDataForUrlAsync) + " - failed to parse JSON returned for model {0} from url={1}", request.Name, targetUrl);
                                throw; //will be caught in the catch block at end of method
                            }

                            bool success = token["success"].ToObject<bool>();
                            string message = token["message"]?.ToObject<string>();
                            string details = token["details"]?.ToObject<string>();
                            ChangeDataResponce item = token["item"]?.ToObject<ChangeDataResponce>();

                            if (success)
                            {
                                return (null, new ItemSuccessResponse<ChangeDataResponce>(item));
                            }
                            else
                            {
                                return (new FailResponse(message, details), null);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    if(logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(ex, nameof(ChangeApiDataForUrlAsync) + " - caught an exception and will return a FailResponse");
                    }
                    return (new FailResponse("An error occured"), null);
                }
            }
        }

        /// <summary>
        /// NOT IMPLEMENTED
        /// </summary>
        /// <param name="request"></param>
        /// <param name="model"></param>
        /// <returns></returns>
        public async Task<(bool Succeess, string Message)> DeleteDataForUrlAsync(ChangeDataRequest request, EntityModel model)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        /// <summary>
        /// Get data for form. Note that this implementation is custom coded for the internet side and cannot generically
        /// support any form. For new forms with data additional code will be required. For the forms this does support
        /// the data retrieval logic is mostly managed in the code. (In other words don't add a new form and expect it to
        /// work here like it would on the intranet side).
        /// </summary>
        public async Task<(DynamicEntity Entity, bool IsFromUrl)> GetDataForFormAsync(GetDataRequest getDataRequest)
        {
            if (getDataRequest == null) throw new ArgumentNullException(nameof(getDataRequest));
            string formName = getDataRequest.Name ?? throw new ArgumentNullException("getDataRequest.Name");
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace("GetDataForFormAsync Name={0}, RequestingControlName={1}", formName, getDataRequest?.RequestingControlName); //1
            }

            //Optimisation: we can avoid pulling the model for these forms
            //(which should be all of the non-survey forms, though new feature forms may yet to be added?)
            switch (formName.ToLowerInvariant())
            {
                case "respdashboard":
                    //Pull the dashboard grid data from a custom u@app endpoint
                    //(pretty much ignores what's in the form's model)
                    DynamicEntity dashboardData = await GetRespondentDashboardDataAsync();
                    return (Entity: dashboardData, IsFromUrl: false);

                case "respaccountchangepassword":
                case "inviteschangepassword":
                    //No data to load for these forms
                    return (Entity: new DynamicEntity(), IsFromUrl: false);

                default:
                    //It is assumed anything else is a survey form
                    //as an optimisation we will skip checking the model and go straight to intranet side
                    //to retrieve the data, but we will pass the name to that endpoint so it can fail if it isnt a survey
                    string respDataUrl
                        = Constants.UAppRoutes.ResponseData
                        .Replace("{form}", formName);
                    DynamicEntity surveyData = await GetApiDataForUrlAsync(getDataRequest, respDataUrl);
                    return (Entity: surveyData, IsFromUrl: true);
            }
        }

        /// <summary>
        /// NOT IMPLEMENTED
        /// </summary>
        /// <param name="getDictionaryRequest"></param>
        /// <returns></returns>
        public async Task<(Dictionary<object, string>, long)> GetDictionaryAsync(GetDictionaryRequest getDictionaryRequest)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        /// <summary>
        /// For the internet application this code is used to retrieve survey data for survey forms from the intranet side via the api.
        /// (Not called for the passord form or respondent dashboard)
        /// We don't support non-api calls in this implementation , so if such is specified (i.e. non-api url) it will throw an InvalidOperationException. 
        /// Calls will have the accesstoken and configured additional header applied.
        /// </summary>
        /// <param name="request"></param>
        /// <param name="model"></param>
        /// <returns></returns>
        private async Task<DynamicEntity> GetApiDataForUrlAsync(GetDataRequest request, string dataUrl)
        {
            if (request == null) throw new ArgumentNullException(nameof(request));
            if (string.IsNullOrEmpty(dataUrl)) throw new ArgumentException(dataUrl);

            if (GetApiBasePath() == null)
            {
                //Fail-fast as we don't support non API target's here (for reference, compare with the regular DataSource impl which has an isLocal flag)
                throw new InvalidOperationException($"ApiBasePath is not set in {nameof(UAppUtils)}, dataUrl={dataUrl}");
            }
            DynamicEntity result = null;
            using (HttpClient client = httpClientFactory.CreateClient())
            {
                string targetUrl = $"{GetApiBasePath()}{dataUrl.TrimStart(' ', '/')}";

                if (request.GetHeadersForLocalRequest != null)
                {
                    Dictionary<string, string> headers = request.GetHeadersForLocalRequest();
                    foreach (KeyValuePair<string, string> p in headers)
                        client.DefaultRequestHeaders.Add(p.Key, p.Value); 
                }

                //clover-apikey
                client.DefaultRequestHeaders.Add(IntegrationApiKeys.HeaderApiKey, CloverRuntime.IntegrationApiKey);

                string accessToken = AccessToken();
                if (accessToken != null)
                {
                    client.DefaultRequestHeaders.Add(HeaderNames.Authorization, $"Bearer {accessToken}");
                }

                //Include the additional header if needed (this one is customer environment dependent as
                //some may need to include a gateway key or other token here when calling u@app api)
                if (apiHeaderOptions.AddAdditionalHeader)
                {
                    client.DefaultRequestHeaders.Add(apiHeaderOptions.Name, apiHeaderOptions.Value);
                }

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(GetApiDataForUrlAsync) + " - getting data for {0} from url={1}", 
                        request.Name, //0 
                        targetUrl); //1
                }

                using (HttpResponseMessage res = await client.GetAsync(targetUrl))
                {
                    if (!res.IsSuccessStatusCode)
                    {
                        logger.LogError(nameof(GetApiDataForUrlAsync) + " - got unsuccessful status {0} for {1} from url={2}", 
                            res.StatusCode, //0
                            request.Name, //1
                            targetUrl); //2                       
                    }
                    //nb: Even if it was an unsuccessful status code we will continue executing here to preserve existing behaviour
                    //    I am not sure if anything depends on this old behaviour so don't want to change it yet
                    using (HttpContent content = res.Content)
                    {
                        string data = await content.ReadAsStringAsync();
                        if(UAppUtils.IsSessionInvalid(res, data))
                        {
                            //This will occur if their token is not valid - typically because it was invalidated by
                            //a second login (if single session is being enforced)
                            throw new SessionInvalidException();
                        }
                        if (logger.IsEnabled(LogLevel.Trace))
                        {
                            string dataSizeUnquoted = (data == null ? "null string" : data.Length + " characters"); //safe for direct inclusion in log string
                            logger.LogTrace(nameof(GetApiDataForUrlAsync) + " - got status {0} for {1} from url={2}, data size is " + dataSizeUnquoted,
                                res.StatusCode, //0
                                request.Name, //1
                                targetUrl); //2
                        }
                        if (data != null)
                        {
                            try
                            {
                                result = DynamicEntity.ParseJSON(data);
                            }
                            catch(Exception parseFailure)
                            {
                                //Probably the intranet side returned an html error page instead of a status code
                                logger.LogError(parseFailure, nameof(GetApiDataForUrlAsync) + " - failed to parse JSON returned for  {0} from url={1}", request.Name, targetUrl);
                                throw; //preserve the existing behaviour of allowing the exception to bubble up unwrapped
                            }
                        }
                    }//end using HttpContent                    
                }//end using HttpResponseMessage
            } //end using HttpClient
            return result;
        } //end of GetApiDataForUrlAsync

        private async Task<DynamicEntity> GetRespondentDashboardDataAsync()
        {
            try
            {
                string accessToken = AccessToken();
                if (string.IsNullOrEmpty(accessToken)) throw new PermissionException("No accessToken");
                const string partialUrl = Constants.UAppRoutes.RespondentDashboardData;
                TraceLogHttpClient(logger, "GetDashboardListSampleInfo", partialUrl);
                string json = await SendApiRequestAsync(
                    httpClientFactory,
                    apiHeaderOptions,
                    ApiRequest.Get(partialUrl, accessToken));
                List<DynamicEntity> data
                    = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(json)
                    .Select(dictionary => new DynamicEntity(dictionary))
                    .ToList();

                //Intranet side will return all the vSP_ListSampleInfoResp rows for the requesting sample
                //so now we split into current and previous for the respective grids on the form
                List<DynamicEntity> currentSurveys = new List<DynamicEntity>();
                List<DynamicEntity> previousSurveys = new List<DynamicEntity>();
                DateTime now = DateTime.Now;
                foreach (DynamicEntity row in data)
                {
                    DateTime dueDate = (DateTime)row[Constants.FieldName.DueDate];
                    if (dueDate >= now)
                        currentSurveys.Add(row);
                    else
                        previousSurveys.Add(row);
                }
                DynamicEntity result = new DynamicEntity();
                result["currentSurveyCard"] = currentSurveys;
                result["__grid_totalcount"] = currentSurveys.Count;
                result["previousSurveyCard"] = previousSurveys;
                result["__gridview_totalcount"] = previousSurveys.Count;
                result["currentSurveyGrid"] = currentSurveys;
                result["previousSurveyGrid"] = previousSurveys;
                return result;
            }
            catch(PermissionException)
            {
                throw;
            }
            catch(Exception e)
            {
                throw new Exception("Failed to retrieve data", e);
            }
        }

        private string AccessToken()
        {
            return internetApiTokenManager.AccessToken().Result; //TODO don't sync over async
        }
    } 
}