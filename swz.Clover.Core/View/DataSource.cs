using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.View
{
    public class GetDataRequest
    {
        public GetDataRequest(string name)
        {
            Name = name;
        }

        public string Name { get; }
        public string RequestingControlName { get; set; }
        public string FilterActionName { get; set; }
        public string IdValue { get; set; }
        public List<ClientFilterItem> Filter { get; set; }
        public List<ClienSortItem> Sort { get; set; }
        public ClientPaging Paging { get; set; }
        public Dictionary<string, object> OptionsDictionary { get; set; }
        public Func<object, object> LocalReditectFunc { get; set; }

        public string BaseUrl { get; set; }
        public Func<Dictionary<string, string>> GetHeadersForLocalRequest;
    }

    public class GetDictionaryRequest
    {
        public GetDictionaryRequest(string name)
        {
            Name = name;

        }
        public string Name { get; }
        public List<ClienSortItem> Sort { get; set; }
        public List<string> Columns { get; set; }
        public ClientPaging Paging { get; set; }
        public List<ClientFilterItem> Filter { get; set; }
    }

    public class ChangeDataRequest
    {
        public ChangeDataRequest(string name, string data, string requestingControl = null)
        {
            Name = name;
            Data = data;
            RequestingControl = requestingControl;

        }
        public string Name { get; }
        public string Data { get; }
        public string RequestingControl { get; }

        public string BaseUrl { get; set; }
        public Func<Dictionary<string, string>> GetHeadersForLocalRequest;
    }

    public class ChangeDataResponce
    {
        public  object EntityId { get; set; }
        public Dictionary<string,object> Entity { get; set; }
    }

    // // // // // // // // // // // // // // // // // // // // // // // // //

    //TODO - refactor this into a singleton class implementing IDataSource, get logger and factories (two of them) by injection
    //       which would probably need to use type client instead of named client 
    public static class DataSource
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(DataSource));

        //I don't like having this as a static, and its only a mutable reference so it can be initialised at startup
        //If you get errors about this being null at runtime make sure its initialised at startup (eg by IntranetConfigurator etc). 
        private static IHttpClientFactory HttpClientFactory = null;

        public static void InitialiseHttpClientFactory(IHttpClientFactory httpClientFactory)
        {
            //TODO - when we refactor this class to be non-static, the factory can be injected to constructor
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            DataSource.HttpClientFactory = httpClientFactory;
        }

        public static async Task<(FailResponse fail, ItemSuccessResponse<ChangeDataResponce> success)> ChangeData(ChangeDataRequest request)
        {
            var model = await MetadataToModelConverter.GetEntityModelByFormAsync(request.Name,
                new BuildModelOptions(ignoreNameCase: true, requestingControl: request.RequestingControl, strategy: BuildModelStartegy.ForChange));

            if (!string.IsNullOrEmpty(model.DataUrl))
            {
                return await ChangeDataForUrlAsync(request, model);
            }

            var data = new DynamicEntityDeserializer(model).DeserializeSingle(request.Data);
            await model.UpdateSingleAsync(data);
            return (null, new ItemSuccessResponse<ChangeDataResponce>(new ChangeDataResponce() {EntityId = data.GetPrimaryKey(), Entity = data.ToDictionary(true)}));
        }

        private static async Task<(FailResponse fail, ItemSuccessResponse<ChangeDataResponce> success)> ChangeDataForUrlAsync(ChangeDataRequest request, EntityModel model)
        {
            string result = null;
            using (HttpClient client = HttpClientFactory.CreateClient(nameof(DataSource)))
            {
                string targetUrl;
                bool isLocal = !model.DataUrl.Contains("://");
                if (isLocal)
                {
                    targetUrl = request.BaseUrl + model.DataUrl;
                    if (request.GetHeadersForLocalRequest != null)
                    {
                        var headers = request.GetHeadersForLocalRequest();
                        foreach (var p in headers)
                            client.DefaultRequestHeaders.Add(p.Key, p.Value);
                    }
                }
                else
                {
                    targetUrl = model.DataUrl;
                }

                var multiContent = new MultipartFormDataContent {{new StringContent(request.Data, Encoding.UTF8, "application/json"), "data"}};
                try
                {
                    using (var res = await client.PostAsync(targetUrl, multiContent))
                    {
                        using (HttpContent content = res.Content)
                        {
                            result = await content.ReadAsStringAsync();

                            var token = JToken.Parse(result);


                            var success = token["success"].ToObject<bool>();
                            var message = token["message"]?.ToObject<string>();
                            var details = token["details"]?.ToObject<string>();
                            var item = token["item"]?.ToObject<ChangeDataResponce>();

                            if (success)
                            {
                                return (null, new ItemSuccessResponse<ChangeDataResponce>(item));
                            }
                            else
                            {
                                return (new FailResponse(message,details), null);
                            }
                        }
                    }
                }
                catch(Exception ex)
                {
                    Logger.LogError(ex, nameof(ChangeDataForUrlAsync) + " - caught unexpected exception, model.Name={0}", model?.Name);
                    return (new FailResponse("An error occured"),null);
                }
            }
        }

        public static async Task<(bool Succeess, string Message)> DeleteData(ChangeDataRequest request)
        {
            var model = await MetadataToModelConverter.GetEntityModelByFormAsync(request.Name,
                new BuildModelOptions(ignoreNameCase: true, requestingControl: request.RequestingControl));

            if (!string.IsNullOrEmpty(model.DataUrl))
            {
                return await DeleteDataForUrlAsync(request, model);
            }

            var data = JsonConvert.DeserializeObject<List<object>>(request.Data);
            
            if (!String.IsNullOrEmpty(request.RequestingControl))
            {
                var targetModel = model.Collections.FirstOrDefault()?.Model;
                if (targetModel != null)
                {
                    await targetModel.DeleteAsync(data.Select(c=> 
                        targetModel.PrimaryKeyAttribute.Type.ParseToCLRType(c)
                    ));
                }
            }
            else
            {   
                await model.DeleteAsync(data.Select(c=> 
                    model.PrimaryKeyAttribute.Type.ParseToCLRType(c)
                ));
            }
            return (true, null);
        }

        public static async Task<(bool Succeess, string Message)> DeleteDataForUrlAsync(ChangeDataRequest request, EntityModel model)
        {
            string result = null;
            using (HttpClient client = HttpClientFactory.CreateClient()) //nb: this uses default config, not named DataSource config
            {
                string targetUrl;
                bool isLocal = !model.DataUrl.Contains("://");
                if (isLocal)
                {
                    targetUrl = request.BaseUrl + model.DataUrl;
                    if (request.GetHeadersForLocalRequest != null)
                    {
                        var headers = request.GetHeadersForLocalRequest();
                        foreach (var p in headers)
                            client.DefaultRequestHeaders.Add(p.Key, p.Value);
                    }
                }
                else
                {
                    targetUrl = model.DataUrl;
                }

                var uriBuilder = new UriBuilder(targetUrl);
                var query = System.Web.HttpUtility.ParseQueryString(uriBuilder.Query);
                query["data"] = request.Data;
                uriBuilder.Query = query.ToString();
                Uri targetUri = new Uri(uriBuilder.ToString());

                try
                {
                    using (HttpResponseMessage res = await client.DeleteAsync(targetUri))
                    {
                        using (HttpContent content = res.Content)
                        {
                            result = await content.ReadAsStringAsync();
                        }

                        try
                        {
                            var token = JToken.Parse(result);
                            return (token["success"].ToObject<bool>(),
                                    token["message"]?.ToObject<string>());
                        }
                        catch
                        {
                            return (true, result);
                        }
                    }
                }
                catch (Exception ex)
                {
                    return (false, ex.Message);
                }
            }
        }

        public static async Task<(DynamicEntity Entity, bool IsFromUrl)> GetDataForFormAsync(GetDataRequest getDataRequest)
        {
            var options = new DynamicEntity(getDataRequest.OptionsDictionary);
            var model = await MetadataToModelConverter.GetEntityModelByFormAsync(getDataRequest.Name,
                new BuildModelOptions(ignoreNameCase: true, requestingControl: getDataRequest.RequestingControlName));

            if (!string.IsNullOrEmpty(model.DataUrl))
            {
                return (await GetDataForUrlAsync(getDataRequest, model), true);
            }

            if (model.IsEmptpy)
                return (new DynamicEntity(), false);

            var filterFromFunction = !string.IsNullOrEmpty(getDataRequest.FilterActionName) 
                ? await CloverRuntime.ServerActions.GetFilterAsync(getDataRequest.FilterActionName, model, new List<dynamic>(), options)
                : Filter.Empty;
            
            var filterFromId = !string.IsNullOrEmpty(getDataRequest.IdValue) && model.HasPrimaryKey 
                ? Filter.And.Equal(model.PrimaryKeyAttribute.Type.ParseToCLRType(getDataRequest.IdValue),model.PrimaryKeyAttributeName)
                : Filter.Empty;

            EntityModel modelForFilterParse = model;
            if (!string.IsNullOrEmpty(getDataRequest.RequestingControlName) && model.HasCollections)
            {
                var collection = model.GetCollectionModelWithName(getDataRequest.RequestingControlName);
                if (collection != null)
                    modelForFilterParse = collection.Model;
            } 
           
            var  filterFromGrid = getDataRequest.Filter.ToORMFilter(modelForFilterParse); //Parsing of client filter has been moved to this extension method

            var filterCriteria = filterFromFunction.Merge(filterFromId).Merge(filterFromGrid);

            if (filterCriteria.IsEmpty && !model.IsVirtual)
            {
                return (await model.NewAsync(), false);
            }

            var orderCriteria = getDataRequest.Sort.ToORMOrder(); //Replaced by extension method

            var pagingCriteria = getDataRequest.Paging == null ? Paging.Empty : new Paging(getDataRequest.Paging.StartIndex, getDataRequest.Paging.PageSize);

            if (!string.IsNullOrEmpty(getDataRequest.RequestingControlName))
            {
                var collectionsRequests = new Dictionary<string, (Filter Filter, Order Order, Paging Paging)>
                {
                    {getDataRequest.RequestingControlName, (Filter:filterCriteria, Order:orderCriteria, Paging:pagingCriteria)}
                };
                var data = (await model.GetAsync(collectionsRequests)).FirstOrDefault();
                return (data,false);

            }
            else
            {
                //FirstOrDefault? what if one form have multiple collection?
                var data = (await model.GetAsync(filterCriteria, orderCriteria, pagingCriteria)).FirstOrDefault();

                return (data,false);
            }
        }

        private static async Task<DynamicEntity> GetDataForUrlAsync(GetDataRequest request, EntityModel model)
        {
            DynamicEntity result = null;
            using (HttpClient client = HttpClientFactory.CreateClient(nameof(DataSource)))
            {

                string targetUrl;
                bool isLocal = !model.DataUrl.Contains("://");
                if (isLocal)
                {
                    targetUrl = request.BaseUrl + model.DataUrl;
                    Dictionary<string, string> headers = request.GetHeadersForLocalRequest();
                    bool isCopyHeaders = (headers != null);
                    if (Logger.IsEnabled(LogLevel.Debug))
                    {
                        Logger.LogDebug("GetDataForUrlAsync: Local - Name={0}, BaseUrl={1}, DataUrl={2}, isCopyHeaders={3}",
                            model.Name, request.BaseUrl, model.DataUrl, isCopyHeaders);
                    }
                    if (isCopyHeaders)
                    {
                        //Copy headers from the original request to the internal one
                        //(notably this includes cookie used for authentication, without which the request is not authorized)
                        foreach (KeyValuePair<string, string> p in headers)
                        {
                            client.DefaultRequestHeaders.Add(p.Key, p.Value);
                        }
                    }
                } //end if isLocal
                else //Not local
                {
                    targetUrl = model.DataUrl;
                    if (Logger.IsEnabled(LogLevel.Debug))
                    {
                        Logger.LogDebug("GetDataForUrlAsync: Remote - Name={0}, DataUrl={1}", model.Name, model.DataUrl);
                    }
                }

                using (HttpResponseMessage res = await client.GetAsync(targetUrl))
                {
                    if (!res.IsSuccessStatusCode)
                    {
                        Logger.LogError("GetDataForUrlAsync: {0} response from {1}", res.StatusCode, targetUrl);
                        //nb: no further action taken on this error so as to preserve the legacy behaviour
                        //    (and which may be like that to support error responses that also return json details in the body?)
                    }

                    using (HttpContent content = res.Content)
                    {
                        string data = await content.ReadAsStringAsync();
                        if (data != null)
                        {
                            result = DynamicEntity.ParseJSON(data);
                        }
                    }
                }
            }
            return result;
        }
        
        public static async Task<(Dictionary<object,string>,long)> GetDictionaryAsync(GetDictionaryRequest getDictionaryRequest)
        {
            if (getDictionaryRequest.Columns == null || getDictionaryRequest.Columns.Count < 1)
                return (new Dictionary<object,string>(), 0);
            
            var model = await MetadataToModelConverter.GetEntityModelByModelAsync(getDictionaryRequest.Name);
            var filter = getDictionaryRequest.Filter.ToORMFilter(model); //Parsing of client filter has been moved to this extension method
            var orderCriteria = getDictionaryRequest.Sort.ToORMOrder(); //Replaced by extension method
            var pagingCriteria = getDictionaryRequest.Paging == null ? Paging.Empty : new Paging(getDictionaryRequest.Paging.StartIndex, getDictionaryRequest.Paging.PageSize);

            var data = await model.GetAsync(filter, orderCriteria, pagingCriteria);
            var count = await model.GetCountAsync(filter);

            var result = new Dictionary<object, string>();
            foreach (var de in data)
            {
                string value;

                if (getDictionaryRequest.Columns.Count == 1)
                {
                    value = de[getDictionaryRequest.Columns.First()]?.ToString();
                }
                else
                {
                    var columnValues = getDictionaryRequest.Columns.Select(c => de[c]?.ToString());
                    value = string.Join(" ", columnValues.Where(cv=>!string.IsNullOrEmpty(cv)));
                }
                if(!result.ContainsKey(de.GetId())) //ZL distinct
                    result.Add(de.GetId(), value);
            }

            return (result, count);
        }
    }
}