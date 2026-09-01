using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.View;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    public class SwzDataController : Controller
    {
        private readonly ILogger<SwzDataController> logger;

        public SwzDataController(ILogger<SwzDataController> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [Route("SwzData/getServerDateTime")]
        [HttpPost]
        public JsonResult GetServerDateTime(string datetimeformat)
        {
            try
            {
                var dateTime = DateTime.Now;
                string dateTimeFormatted;
                if (string.IsNullOrWhiteSpace(datetimeformat) || datetimeformat == "undefined")
                    dateTimeFormatted = dateTime.ToString(Constants.QnnDatetimeFormat);
                else
                    dateTimeFormatted = dateTime.ToString(datetimeformat);


                return Json(new
                {
                    Success = true,
                    Data = dateTimeFormatted,
                    Message = "Load server time success"
                });
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetServerDateTime) + " - caught unexpected exception. datetimeformat={0}" + datetimeformat);
                return Json(new
                {
                    Success = false,
                    Message = "Unable to get time due to " + e.Message
                });
            }
        }

        [Route("SwzData/getSurvey")]
        [HttpGet]
        public async Task<JsonResult> GetSurvey(string survey)
        {
            try
            {
                var _filters = new List<Filter>();
                var _orderByNumId = Order.StartDesc("CreatedDate");
                var _model = await MetadataToModelConverter.GetEntityModelByModelAsync("dwMetadata", 0);
                var surveySet = survey + "-settings.json";
                var isSurvey = "\"isSurvey\": true";

                _filters.Add(Filter.And.Equal(surveySet, "Filename"));
                _filters.Add(Filter.And.Equal(0, "isDeleted"));
                _filters.Add(Filter.And.LikeRightLeft(isSurvey, "Data"));

                var _filter = Filter.And.Equal(surveySet, "Filename");

                if (_filters.Count > 0)
                {
                    _filter = _filters.First();
                    _filters.Remove(_filter);
                    foreach (var item in _filters) _filter.Merge(item);
                }

                var _filterSkip = 0;
                var _filterLimit = 5;
                var _paging = Paging.Create(_filterSkip, _filterLimit);
                var _dm = await _model.GetAsync(_filter, _orderByNumId, _paging);
                var _mView = new List<dynamic>();

                foreach (var item in _dm)
                    _mView.Add(new
                    {
                        Filename = item["Filename"],
                        Data = item["Data"]
                    });

                if (_mView.Count < 1)
                    return Json(new
                    {
                        Success = false,
                        Message = "No survey found"
                    });

                return Json(new
                {
                    Success = true,
                    Data = _mView,
                    Message = "Load survey success"
                });
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetSurvey) + " - caught unexpected exception, survey={0}", survey);
                return Json(new
                {
                    Success = false,
                    Message = "Unable to load survey due to " + e.Message
                });
            }
        }

        [Route("SwzData/get")]
        public async Task<ActionResult> GetData(string name, string control, string urlFilter, string options,
            string filter, string paging, string sort)
        {
            try
            {
                /* if (!await CloverRuntime.Security.CheckFormPermissionAsync(name, "View"))
                 {
                     throw new Exception("Access denied!");
                 }*/ // Do not check for permission as user is not login into resplogin

                string filterActionName = null;
                string idValue = null;
                var filterItems = new List<ClientFilterItem>();


                if (NotNullOrEmpty(urlFilter))
                    try
                    {
                        filterItems.AddRange(JsonConvert.DeserializeObject<List<ClientFilterItem>>(urlFilter));
                    }
                    catch
                    {
                        var filterActions = CloverRuntime.ServerActions.GetFilterNames()
                            .Where(n => n.Equals(urlFilter, StringComparison.OrdinalIgnoreCase)).ToList();
                        string filterAction = null;
                        filterAction = filterActions.Count == 1
                            ? filterActions.First()
                            : filterActions.FirstOrDefault(n => n.Equals(urlFilter, StringComparison.Ordinal));

                        if (!string.IsNullOrEmpty(filterAction))
                            filterActionName = filterAction;
                        else
                            idValue = urlFilter;
                    }

                if (NotNullOrEmpty(filter))
                    filterItems.AddRange(JsonConvert.DeserializeObject<List<ClientFilterItem>>(filter));

                var getRequest = new GetDataRequest(name)
                {
                    RequestingControlName = control,
                    FilterActionName = filterActionName,
                    IdValue = idValue,
                    Filter = filterItems,
                    BaseUrl = string.Format("{0}://{1}", Request.Scheme, Request.Host.Value),
                    GetHeadersForLocalRequest = () =>
                    {
                        var dataUrlParameters = new Dictionary<string, string>();
                        dataUrlParameters.Add("Cookie",
                            string.Join(";",
                                Request.Cookies.Select(c => $"{c.Key}={c.Value}")));
                        return dataUrlParameters;
                    }
                };

                if (NotNullOrEmpty(options))
                    getRequest.OptionsDictionary = JsonConvert.DeserializeObject<Dictionary<string, object>>(options);

                if (NotNullOrEmpty(paging)) getRequest.Paging = JsonConvert.DeserializeObject<ClientPaging>(paging);

                if (NotNullOrEmpty(sort)) getRequest.Sort = JsonConvert.DeserializeObject<List<ClienSortItem>>(sort);

                var data = await DataSource.GetDataForFormAsync(getRequest).ConfigureAwait(false);
                if (data.Entity == null) return Json(new ItemSuccessResponse<object>(new Dictionary<string, object>()));
                if (data.IsFromUrl && FailResponse.IsFailResponse(data.Entity, out var fail)) return Json(fail);

                return Json(new ItemSuccessResponse<object>(data.Entity.ToDictionary(true)));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetData) + " - caught unexpected exception, name={0}, control={1}", name, control);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
        /// Respondent content
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        [Route("SwzData/getmultiple")]
        [HttpGet]
        public async Task<JsonResult> GetMultiple(string type)
        {
            try
            {
                var _filters = new List<Filter>();

                var _orderByNumId = Order.StartAsc("NumberId");

                var _model = await MetadataToModelConverter.GetEntityModelByModelAsync("QNN_RESP_ADMIN", 0);

                //_filters.Add(Filter.And.NotIn(_ids.ToObject<List<string>>(), "Id"));

                _filters.Add(Filter.And.Equal(1, "Status"));
                _filters.Add(Filter.And.Equal(type, "Type"));
                _filters.Add(Filter.And.LessOrEqual(DateTime.Now, "StartDate"));
                _filters.Add(Filter.And.GreaterOrEqual(DateTime.Now, "EndDate"));

                var _filter = Filter.And.Equal(type, "Type");

                if (_filters.Count > 0)
                {
                    _filter = _filters.First();
                    _filters.Remove(_filter);
                    foreach (var item in _filters) _filter.Merge(item);
                }

                var _filterSkip = 0;
                var _filterLimit = 5;

                var _paging = Paging.Create(_filterSkip, _filterLimit);

                var _dm = await _model.GetAsync(_filter, _orderByNumId, _paging);
                var _mView = new List<dynamic>();
                foreach (var item in _dm)
                    _mView.Add(new
                    {
                        Name = item["Name"],
                        EditorState = item["EditorState"],
                        Id = item["Id"],
                        Type = item["Type"],
                        NumberId = item["NumberId"]
                    });

                return Json(new
                {
                    Success = true,
                    Data = _mView,
                    Message = "Load Html View Success"
                });
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetMultiple) + " - caught unexpected exception, type={0}", type);
                return Json(new
                {
                    Success = false,
                    Message = "Unable to view HTML Viewer due to " + e.Message
                });
            }
        }

        public static bool NotNullOrEmpty(string urlFilter)
        {
            return !string.IsNullOrEmpty(urlFilter) && !urlFilter.Equals("null", StringComparison.OrdinalIgnoreCase);
        }


        [Route("SwzData/change")]
        [HttpPost]
        [RequestSizeLimit(100_000_000)]
        public async Task<ActionResult> ChangeData(string name, string data)
        {
            try
            {
                //string dataRcd = Newtonsoft.Json.JsonConvert.SerializeObject(data, Newtonsoft.Json.Formatting.Indented);
                //return JsonConvert.DeserializeObject<List<RootObject>>(content);

                Debug.WriteLine(data);
                Debug.WriteLine(name);

                Debug.WriteLine("changedata");
                var res = await DataSource.ChangeData(new ChangeDataRequest(name, data));
                if (res.success != null)
                    return Json(res.success);
                return Json(res.fail);
            }

            catch (Exception e)
            {
                logger.LogError(e, nameof(ChangeData) + " - caught unexpected exception, name={0}", name);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        [Route("SwzData/import")]
        [HttpPost("bulk")]
        [ProducesResponseType((int) HttpStatusCode.BadRequest)]
        [ProducesResponseType((int) HttpStatusCode.InternalServerError)]
        [DisableRequestSizeLimit]
        public async Task<ActionResult> ImportData(string name, string data)
        {
            try
            {
                //string dataRcd = Newtonsoft.Json.JsonConvert.SerializeObject(data, Newtonsoft.Json.Formatting.Indented);
                //return JsonConvert.DeserializeObject<List<RootObject>>(content);
                var res = await DataSource.ChangeData(new ChangeDataRequest(name, data));
                if (res.success != null)
                    return Json(res.success);
                return Json(res.fail);
            }

            catch (Exception e)
            {
                logger.LogError(e, nameof(ImportData) + " - caught unexpected exception, name={0}", name);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }
    }
}

public class Data
{
    public string data { get; set; }
}