using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Http;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core;
using swz.Clover.Core.Security;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;

namespace swz.SurveyPlus.IdentityAccessManagement
{
    [AttributeUsage(AttributeTargets.Method)]
    public class IamAuthorization : Attribute, IAuthorizationFilter
    {
        private readonly ILogger logger;
        private readonly IamSettings iamSettings;

        public IamAuthorization(IamSettings iamSettings, ILogger<IamAuthorization> logger)
        {
            this.iamSettings = iamSettings ?? throw new ArgumentNullException(nameof(iamSettings));
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        private async void CheckAccountAndAuthorizationHeader(AuthorizationFilterContext context)
        {
            Func<string, byte[]> _ = (s) => { return Encoding.UTF8.GetBytes(s); };
            Func<string, int> setUnauthorizedCode = (s) =>
            {
                context.Result = new ContentResult()
                {
                    StatusCode = 401,
                    Content = JsonConvert.SerializeObject(new BaseReturn { Detail = "Unauthorised Request - " + s, Status = "401" })
                };
                logger.LogError("Unauthorised Request - " + s);
                return 0;
            };

            //Account and Secret
            string acctIDq = context.HttpContext.Request.Query["accountid"].ToString();
            string secretKey = iamSettings.SecretKey;

            SecurityCredential securityCredential = await SecurityUser.GetCredentialByLogin(acctIDq);
            if (securityCredential == null)
            {
                setUnauthorizedCode("Invalid account ID");
                return;
            }
            User currentUser = await CloverRuntime.Security.GetUserByIdAsync(securityCredential.SecurityUserId, includeLockedUsers: true);
            if (currentUser == null || !currentUser.IsInRole(SurveyPlus.Application.Constants.Role.IamClient))
            {
                setUnauthorizedCode("Invalid account role");
                return;
            }

            //Construct string for authorisation
            string httpMethod = context.HttpContext.Request.Method.ToUpper();
            string protocol = context.HttpContext.Request.IsHttps ? "https" : "http";
            string hostName = context.HttpContext.Request.Host.Value.ToLower();
            string url = context.HttpContext.Request.Path.ToString();

            string queryStringSorted = context.HttpContext.Request.Query.OrderBy(x => x.Key)
                .Select(x => $"{x.Key}={x.Value}").Aggregate((x, y) => $"{x}&{y}").ToLower();
            string combinedString = $"{httpMethod}&{protocol}://{hostName}{url}?{queryStringSorted}";
            string authString = Convert.ToBase64String(new HMACSHA256(_(secretKey)).ComputeHash(_(combinedString)));
            //Get authorisation header from request
            string authHeader = GetAuthorizationHeader(context.HttpContext.Request.Headers);

            if (authHeader != authString)
            {
                setUnauthorizedCode("Invalid authorization header");
                return;
            }
        }

        private string GetAuthorizationHeader(IHeaderDictionary headers)
        {
            var authHeader = headers["Authorization"].ToString();
            if (!string.IsNullOrEmpty(authHeader))
            {
                return authHeader.Replace("Bearer", "").Trim();
            }
            return string.Empty;
        }

        private void CheckNonce(AuthorizationFilterContext context)
        {
            // TODO: to replace this with proper NONCE handling that cater for scalability deployment and housekeeping mechanism
            string nonce = context.HttpContext.Request.Query["nonce"].ToString();
            if (!string.IsNullOrEmpty(nonce))
            {
                return;
            }
            logger.LogError("Unauthorised Request - Invalid nonce");
            context.Result = new ContentResult()
            {
                StatusCode = 401,
                Content = JsonConvert.SerializeObject(new BaseReturn { Detail = "Unauthorised Request - Invalid nonce", Status = "401" })
            };
        }

        private void CheckTimeStamp(AuthorizationFilterContext context)
        {
            string reqdtq = context.HttpContext.Request.Query["ts"].ToString();
            string gracePeriod = iamSettings.RequestExpiry;
            if (!string.IsNullOrEmpty(reqdtq))
            {
                try
                {
                    long gracePeriodl = long.Parse(gracePeriod);
                    long lreqDt = long.Parse(reqdtq);
                    DateTime reqDateTime = new DateTime(1970, 1, 1).AddMilliseconds(lreqDt);
                    if (DateTime.UtcNow.Subtract(reqDateTime).TotalSeconds <= gracePeriodl)
                    {
                        return;
                    }
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(CheckTimeStamp) + " - caught unexpected exception");
                }
            }
            logger.LogError("Unauthorised Request - Invalid request date time");
            context.Result = new ContentResult()
            {
                StatusCode = 401,
                Content = JsonConvert.SerializeObject(new BaseReturn { Detail = "Unauthorised Request - Invalid request date time", Status = "401" })
            };
        }

        public void OnAuthorization(AuthorizationFilterContext context)
        {
            if (iamSettings.IsEnabled)
            {
                CheckNonce(context);
                if (context.Result == null) CheckTimeStamp(context);
                if (context.Result == null) CheckAccountAndAuthorizationHeader(context);
            }
            else
            {
                context.Result = new ContentResult()
                {
                    StatusCode = 500,
                    Content = JsonConvert.SerializeObject(new BaseReturn { Detail = "IAM settings not enable", Status = "500" })
                };
            }
        }
    }
}
