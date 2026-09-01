using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.SurveyPlus.IdentityAccessManagement;
using Microsoft.AspNetCore.Routing;
using swz.SurveyPlus.IdentityAccessManagement.Domain;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    public class IamController : Controller
    {
        private readonly ILogger logger;

        public IamController(ILogger<IamController> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [ServiceFilter(typeof(IamAuthorization))]
        [HttpPost]
        [Route("users/info")]
        public async Task<IActionResult> GetUserInfo([FromBody] UserInput value)
        {
            try
            {
                Guid userId = Guid.Parse(value.userId);
                string iamLogin = HttpContext.Request.Query["accountid"].ToString();

                User u = await IamApplication.GetUser(iamLogin, userId);
                if (u.id != null)
                {
                    string o = JsonConvertEx.SerializeObject(u);
                    return Ok(o);
                }
                else
                {
                    return new ContentResult() { StatusCode = 404, Content = JsonConvert.SerializeObject(new BaseReturn { Detail = "Account Not Found", Status = "404" }) };
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetUserInfo) + " - caught unexpected exception");
                //TODO - why does the below return 404, shouldn't it return 500?
                return new ContentResult() { StatusCode = 404, Content = JsonConvert.SerializeObject(new BaseReturn { Detail = "Account Not Found", Status = "404" }) };
            }
        }

        [ServiceFilter(typeof(IamAuthorization))]
        [HttpPost]
        [Route("users/findbycriteria")]
        public async Task<IActionResult> GetUserFindByCriteria([FromBody] ListInput value)
        {
            try
            {
                string iamLogin = HttpContext.Request.Query["accountid"].ToString();

                UserList ul = await IamApplication.GetUserList(iamLogin, value);
                string o = JsonConvertEx.SerializeObject(ul);

                return Ok(o);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetUserFindByCriteria) + " - caught unexpected exception");
                //TODO - why does the below return 404, shouldn't it return 500?
                return new ContentResult() { StatusCode = 404, Content = JsonConvert.SerializeObject(new BaseReturn { Detail = "Unknown Error", Status = "404" }) };
            }
        }

        [ServiceFilter(typeof(IamAuthorization))]
        [HttpPost]
        [Route("users/update")]
        public async Task<IActionResult> UpdateUser([FromBody] PatchOpBoolean value)
        {
            try
            {
                Guid userId = Guid.Parse(value.userId);
                bool userActivityStatus = value.Operations[0].value;
                string iamLogin = HttpContext.Request.Query["accountid"].ToString();

                User u = await IamApplication.SetUserActivityStatus(iamLogin, userId, userActivityStatus);
                if (u.id != null)
                {
                    string o = JsonConvertEx.SerializeObject(u);
                    return Ok(o);
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(UpdateUser) + " - caught unexpected exception");
                //TODO - why do we return 404 for this error shouldn't it return 500?
            }

            //TODO - the below should be an explicit return from an else block when checking the above
            return new ContentResult() { StatusCode = 404, Content = JsonConvert.SerializeObject(new BaseReturn { Detail = "Account Not Found", Status = "404" }) };
        }

        [ServiceFilter(typeof(IamAuthorization))]
        [HttpPost]
        [Route("users/remove")]
        public async Task<IActionResult> RemoveUser([FromBody] UserInput value)
        {
            try
            {
                Guid userId = Guid.Parse(value.userId);
                string iamLogin = HttpContext.Request.Query["accountid"].ToString();

                string id = await IamApplication.DeleteUser(iamLogin, userId);
                if (id.Length > 0)
                {
                    return new ContentResult() { StatusCode = 204, Content = string.Empty };

                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(RemoveUser) + " - caught unexpected exception");
            }

            //TODO - logic flow is confusing here, appears to conflate 500 and 404 in some case. Does id.Length > 0 mean not found or is
            //       it another error condition? Need to modify code to make the intent explicit to reader
            return new ContentResult() { StatusCode = 404, Content = JsonConvert.SerializeObject(new BaseReturn { Detail = "Account Not Found", Status = "404" }) };
        }
    }
}
