using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Net.Http.Headers;
using swz.Clover.AuthServices.Jwt.Components.Entity;
using swz.SurveyPlus.IntranetApplication.ThirdPartyApi;
using Constants = swz.SurveyPlus.Application.Constants;
using System.Net.Http.Headers;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication;
using swz.Clover.Core.IntegrationApi;
using System.Text;
using System.IO;
using swz.Clover.AuthServices.Jwt.Services;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    /// <summary>
    /// 3PA - "Third-Party API"
    /// Exposes an API for third party retrieval of response data.
    /// Callers should first call the authentication endpoint to retrieve an accessToken they can use in subsequent calls to other
    /// API methods to identify themselves when pulling information. The token is good for multiple calls (has an expiry date). 
    /// </summary>
	public class ThirdPartyApiController : Controller
	{
        private readonly ILogger logger;
		private readonly IWebHostEnvironment env;
        private readonly IntranetAppSetting intranetAppSetting;
        private readonly IJwtService jwtService;

        public ThirdPartyApiController(
            IWebHostEnvironment env, 
            ILogger<ThirdPartyApiController> logger, 
            IntranetAppSetting intranetAppSetting,
            IJwtService jwtService)
		{
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.env = env ?? throw new ArgumentNullException(nameof(env));
            this.intranetAppSetting = intranetAppSetting ?? throw new ArgumentNullException(nameof(intranetAppSetting));
            this.jwtService = jwtService ?? throw new ArgumentNullException(nameof(jwtService));
	    }

        [Authorize]
        [Route("swagger/{mode?}/{name?}")]
        [HttpGet]
        public async Task<ActionResult> GetSwaggerFile()
        {
            try
            {
                if (!CloverRuntime.Security.CheckAccess(Constants.Role.Admins))
                {   //20230127 - We'll now restrict the roles that can generate the file, so only allow Admins for now
                    throw new PermissionException($"{Constants.Role.Admins} role is required to access this endpoint");
                }

                //This has its own enabled/disable setting independent of 3PA
                if (!intranetAppSetting.Clover.IsEnableSwaggerFile)
                {
                    logger.LogWarning(nameof(IntranetAppSetting.Clover.IsEnableSwaggerFile) + " flag is not set, CurrentUser={0}", CloverRuntime.Security.CurrentUser);
                    return NotFound("Generation of API description file is not enabled (modify appsettings to enable)");
                }

                var swagger = await IntegrationApiHttp.GetSwaggerSpecsAsync(HttpContext.Request);
                var filename = "clover.yaml";
                var contentType = "application/yaml";

                return File(Encoding.UTF8.GetBytes(swagger), contentType, filename);
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, nameof(GetSwaggerFile) + " - caught unexpected exception");
                return Json(Constants.Message.InternalErrorException);
            }
        }

        [Route("/modelapi/{operation?}/model/{name?}/{level?}/{id?}")] //IntegrationApiHttp expects only one segment in url before operation
        [AllowAnonymous]
        [HttpGet]
        [HttpPost]
        public async Task<ActionResult> ModelApi(string operation, string name)
        {
            //The following code restores the ModelApi (that was previously in IntegrationApiController
            //as part of u@app only) as a general purpose integration API. Its very powerful so by default
            //we should have it disabled in appsettings, and when enabled should strictly limit the models allowed.

            if(!intranetAppSetting.ThirdPartyApi.IsEnabled)
            {
                logger.LogWarning(nameof(ModelApi) + " - 3PA is not enabled");
                return NotFound();
            }

            if (!intranetAppSetting.ThirdPartyApi.IsModelApiEnabled)
            {
                logger.LogWarning(nameof(ModelApi) + " - 3PA ModelApi is not enabled");
                return NotFound();
            }

            string rawTarget = ControllerUtilities.GetRawTarget(HttpContext);
            if (logger.IsEnabled(LogLevel.Debug))
            {
                logger.LogDebug(nameof(ModelApi) + " - called: rawTarget={0}", rawTarget);
            }
                
            try
            {
                Request.Headers.TryGetValue(IntegrationApiKeys.HeaderApiKey, out var apiKey);
                if (!apiKey.Any() || !CloverRuntime.IntegrationApiKey.Equals(apiKey.First()))
                {
                    //Fail-Fast if the clover-apikey was not specified (this will actually get checked again when the operation is
                    //processed, but we want to fail-fast if its missing for better error reporting
                    await Clover.Core.Utils.AuditHelper.AuditLog(null, null, null, "InvalidAPIKey");
                    throw new PermissionException($"Invalid or missing header for {IntegrationApiKeys.HeaderApiKey}");
                }

                bool hasAccessToken = false; //do they have client-specific jwt (in addition to the apikey)
                if (Request.Headers.TryGetValue(HeaderNames.Authorization, out var _))
                {
                    //nb the value of the token will be validated later if it is needed
                    hasAccessToken = true;
                }

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(ModelApi) + " - operation={0}, name={0}, hasAccessToken={1}, rawTarget={2}", operation, name, hasAccessToken, rawTarget);
                }

                if (!hasAccessToken)
                {
                    if (!IsModelAllowed(operation: operation, name: name, hasAccessToken: false))
                    {
                        logger.LogWarning(nameof(ModelApi) + " - model not allowed (without accessToken): operation={0}, name={1}", operation, name);
                        return Forbid();
                    }
                }
                else
                {
                    if (!IsModelAllowed(operation: operation, name: name, hasAccessToken: true))
                    {
                        logger.LogWarning(nameof(ModelApi) + " - model not allowed (with accessToken): operation={0}, name={1}", operation, name);
                        return Forbid();
                    }

                    Authorize3PARequestResult authorization = await Check3PARequestAuthorisation();
                    if (authorization.IsFailed)
                    {
                        return authorization.ErrorResult;
                    }
                }

                //Now that we've verified all the info was passed and this model is allowed we can actually do the work...
                object result = await IntegrationApiHttp.Process(HttpContext.Request);
                return Json(result);
            }
            catch(PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, nameof(ModelApi) + " - caught unexpected exception, operation={0}, name={1}", operation, name);
                return Json(new IntegrationApiFailResponse(ex)); //TODO - this includes stack trace, need to review
            }
        }

        /// <summary>
        /// Endpoint to authenticate the caller with username & password
        /// Will return accessTokens to be used with the other endpoints.  
        /// Expects a body with json representing an instance of LoginData
        /// </summary>
        /// <param name="loginData"></param>
        /// <returns>LoginResultData in json format</returns>
        [HttpPost]
        [Route("/3pa/v1/authenticate")]
        [AllowAnonymous]
        public async Task<ActionResult> Authenticate([FromBody] TokenLoginHelper.LoginData loginData)
        {
            if (!intranetAppSetting.ThirdPartyApi.IsEnabled)
            {
                logger.LogWarning(nameof(Authenticate) + " - 3PA is not enabled");
                return NotFound();
            }

            if (string.IsNullOrWhiteSpace(loginData.Username)) return BadRequest();
            LoginResultData result = await TokenLoginHelper.LoginUser(
                jwtService,
                Request, 
                loginData);
            if (result == null || IJwtServiceConstants.BadCredentials.Equals(result.Error))
            {
                logger.LogWarning("3PA Authentication Failure: {0}", loginData.Username);
                return Unauthorized();
            }
            else if (!string.IsNullOrEmpty(result.Error))
            {
                logger.LogError("3PA Authentication Error: {0} - {1}", loginData.Username, result.Error);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
            else
            {
                //Success!
                if (logger.IsEnabled(LogLevel.Information)) logger.LogInformation("Successfully authenticated {0}", loginData.Username);
                return Json(result);
            }
        }

        /// <summary>
        /// Endpoint to log out JWT login and invalidate the tokens.
        /// Validate against session token in authorization header.
        /// </summary>
        [HttpPost]
        [Route("/3pa/v1/logoff")]
        public async Task<ActionResult> Logout()
        {
            if (!intranetAppSetting.ThirdPartyApi.IsEnabled)
            {
                logger.LogWarning(nameof(Logout) + " - 3PA is not enabled");
                return NotFound();
            }

            Authorize3PARequestResult authorization = await Check3PARequestAuthorisation();
            SecurityUser user = authorization.AuthorizedUser;
            if (authorization.IsFailed)
            {
                return authorization.ErrorResult;
            }

            AuthenticationHeaderValue authHeader
                = AuthenticationHeaderValue.Parse(Request.Headers[HeaderNames.Authorization]);
            bool isLoggedOut = await jwtService.InvalidateUserToken(authHeader);
            if (isLoggedOut)
            {
                //Success!
                if (logger.IsEnabled(LogLevel.Information)) logger.LogInformation("3PA Successfully logged out user {0}", user.Name);
                return Ok("3PA Logout Successful");
            }
            else
            {
                logger.LogWarning("3PA logout Failure: {0}", user.Name);
                return Unauthorized();
            }
        }

        /// <summary>
        /// Endpoint to renew the token. A new JWT is returned to the caller which must be used in
        /// new API requests. The caller must pass the renewal token (received at the login time) to body.
        /// The header still needs to pass the current token for validation even when it is expired.
        /// Will return a new session token to be used with other endpoints. 
        /// Expects a body with json representing an instance of LoginData
        /// </summary>
        /// <param name="rtoken"></param>
        /// <returns>LoginResultData in json format</returns>
        [HttpPost]
        [Route("/3pa/v1/renewtoken")]
        public async Task<ActionResult> ExtendToken([FromBody] RenewalDto rtoken)
        {
            if (!intranetAppSetting.ThirdPartyApi.IsEnabled)
            {
                logger.LogWarning(nameof(ExtendToken) + " - 3PA is not enabled");
                return NotFound();
            }

            if (!Request.Headers.TryGetValue(HeaderNames.Authorization, out Microsoft.Extensions.Primitives.StringValues authorizationHeaders))
            {
                const string missingHeader = "Authorization header missing";
                if (logger.IsEnabled(LogLevel.Warning)) logger.LogWarning(missingHeader);
                return Unauthorized(missingHeader);
            }
            string authorizationHeader = authorizationHeaders.FirstOrDefault();
            AuthenticationHeaderValue authHeader = AuthenticationHeaderValue.Parse(authorizationHeader);
            if (!"Bearer".Equals(authHeader.Scheme, StringComparison.InvariantCultureIgnoreCase))
            {
                string unsupportedScheme = $"Unsupported Authorization scheme: {authHeader.Scheme}";
                if (logger.IsEnabled(LogLevel.Warning)) logger.LogWarning(unsupportedScheme);
                return Unauthorized(unsupportedScheme);
            }

            string expectedIssuer 
                = await SettingsHelper.GetValue(SettingsHelper.Common.INTRANET_DOMAIN_AUTHORITY, assertDefined: true);
            LoginResultData result 
                = await jwtService.RenewUserToken(authHeader, rtoken.RenewalToken);
            if (!string.IsNullOrEmpty(result.Error))
            {
                logger.LogWarning("3PA Renew Token Failure: {0}", result.Error);
                return Unauthorized("Invalid credentials");
            }
            else
            {
                //Success!
                if (logger.IsEnabled(LogLevel.Information)) logger.LogInformation("3PA renew token successful for user {0}", result.DisplayName);
                return Json(result);
            }
        }

        /// <summary>
        /// v1 Endpoint for pulling response data.
        /// Body of the request should be json representing an ExtractDataRequest.
        /// Expects a bearer token with authorisation jwt.
        /// </summary>
        /// <returns>json response, an array of objects with response and meta information for each matching deployment.Does not include respodent uploaded files for which caller must make a seperate call to another endpoint</returns>
		[HttpPost]
		[Route("/3pa/v1/responseData")]
		public async Task<ActionResult> ExtractResponseData()
		{
            if (!intranetAppSetting.ThirdPartyApi.IsEnabled)
            {
                logger.LogWarning(nameof(ExtractResponseData) + " - 3PA is not enabled");
                return NotFound();
            }

            return await HandleExtractionRequestAsync(
                async (SecurityUser user, DeploymentInfo info, IEnumerable<QnnStatusId> statusIds) =>
                {
                    List<Dictionary<string, object>> responseDataList 
                        = await ThirdPartyApiApplication.ExtractResponseDataAsync(info.Deployments, statusIds);
                    return Json(responseDataList);
                }
            );
		}

        /// <summary>
        /// v1 Endpoint to retreive the respondent uploaded files associated with the matching deployments.
        /// Body of the request should be json representing an ExtractDataRequest.
        /// Expects a bearer token with authorisation jwt.
        /// </summary>
        /// <returns>stream for a zip file, contained within are individual files identified uniquely</returns>
		[HttpPost]
		[Route("/3pa/v1/responseFiles")]
		public async Task<ActionResult> ExtractResponseFiles()
		{
            if (!intranetAppSetting.ThirdPartyApi.IsEnabled)
            {
                logger.LogWarning(nameof(ExtractResponseFiles) + " - 3PA is not enabled");
                return NotFound();
            }

            return await HandleExtractionRequestAsync(
                async (SecurityUser user, DeploymentInfo info, IEnumerable<QnnStatusId> statusIds) =>
                {
                    ThirdPartyApiApplication.ResponseFilesResult result
                        = await ThirdPartyApiApplication.ExtractResponseFilesAsync(
                            env.ContentRootPath, 
                            intranetAppSetting.SurveyPlus.RespFiles3PAFolderPath, 
                            info.Deployments, 
                            statusIds);
                    switch (result.Reason)
                    {
                        case ThirdPartyApiApplication.ResponseFilesResult.Outcome.Success:
                            //2023-10-19 - new behaviour - delete the file immediately after streaming
                            //Use FileStream instead of PhysicalFile so we can specify DeleteOnClose
                            Stream stream = new FileStream(
                                result.FilePath,
                                FileMode.Open,
                                FileAccess.Read,
                                FileShare.None,
                                8192,
                                FileOptions.DeleteOnClose);
                            return File(stream, result.ContentType);

                        case ThirdPartyApiApplication.ResponseFilesResult.Outcome.NoFilesFound:
                            return StatusCode(StatusCodes.Status204NoContent);

                        default:
                            throw new NotImplementedException(result.Reason.ToString());
                    }
                }
            );
        }

        /// <summary>
        /// Common logic for an extraction request, to authorise, find the deployments and status ids based on the request, handle exceptions etc
        /// Will hand-off the marshalled information to the provided handler to do the actual extraction work. 
        /// information 
        /// </summary>
        /// <param name="extractionHandler"></param>
        /// <returns></returns>
        private async Task<ActionResult> HandleExtractionRequestAsync(
            Func<
                SecurityUser, 
                DeploymentInfo, 
                IEnumerable<QnnStatusId>, 
                Task<ActionResult>> extractionHandler)
        {
            try
            {
                Authorize3PARequestResult authorization = await Check3PARequestAuthorisation();
                if (authorization.IsFailed)
                {
                    return authorization.ErrorResult;
                }
                SecurityUser user = authorization.AuthorizedUser;

                DataExtractionRequest dataRequest = await DataExtractionRequest.FromJsonStreamAsync(Request.Body);

                //Check specifier type. This is to catch our own coding ommissions, as should have returned already if invalid
                if (dataRequest.SpecifyDeploymentBy != DataExtractionRequest.SpecifierType.ApiIdentifier)
                {
                    return StatusCode(StatusCodes.Status501NotImplemented);
                }

                //Currently we only support IdentifierDeploymentSpecifier
                DataExtractionRequest.IdentifierDeploymentSpecifier deploymentSpecifier = (DataExtractionRequest.IdentifierDeploymentSpecifier)dataRequest.DeploymentSpecifier;
                DeploymentInfo info = await GetDeploymentInfoAsync(deploymentSpecifier, user);

                if (!info.IsSuccessful)
                {
                    return BadRequest(info.Message);
                }

                if (info.MultipleDeploymentsFound && !dataRequest.AllowMultipleDeployments)
                {
                    return BadRequest(Constants.Message.MultipleDeploymentMatched);
                }

                IEnumerable<QnnStatusId> statusIds = await ResponseApplication.GetStatusIdsFromTitlesAsync(deploymentSpecifier.Status);

                if (logger.IsEnabled(LogLevel.Information))
                { 
                    logger.LogInformation("Handling data extraction request for {0} under endpoint {1} for apiIdentifier {2}", user.Name, Request.Path, deploymentSpecifier.ApiIdentifier);
                }

                return await extractionHandler(user, info, statusIds); //Perform the actual extraction work
            }
            catch (DataExtractionRequest.InvalidDataExtractionRequestException ider)
            {
                //This exception is thrown by the factory method when reading the request from the JSON
                if (logger.IsEnabled(LogLevel.Debug)) logger.LogDebug(ider, "Failed to read body");
                return BadRequest("Invalid request body: " + ider.Message);
            }
            catch (InvalidStatusException ise)
            {
                //Request was ok, but the status specified doesn't exist
                if (logger.IsEnabled(LogLevel.Debug)) logger.LogDebug(ise, "Invalid Status Specified");
                return BadRequest(Constants.Message.InvalidStatus);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(HandleExtractionRequestAsync) + " - caught unexpected exception");
                return StatusCode(500, Constants.Message.InternalErrorException);
            }
        }

        /// <summary>
        /// Given an IdentifierDeploymentSpecifier return the matching QNN_DPLY instances (or failure information)
        /// </summary>
        /// <param name="deploymentSpecifier"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        private async Task<DeploymentInfo> GetDeploymentInfoAsync(
            DataExtractionRequest.IdentifierDeploymentSpecifier deploymentSpecifier, 
            SecurityUser user)
		{
			DateTime? startDate = deploymentSpecifier.DateStart; //exact
			DateTime? endDate = deploymentSpecifier.DateEnd; //exact
			IEnumerable<string> status = deploymentSpecifier.Status;
            DateTime? startAfter = deploymentSpecifier.StartAfter; //inclusive >=
            DateTime? startBefore = deploymentSpecifier.StartBefore; //exclusive <

			//struct
			Guid? selectedStructDivisionId = user.StructDivisionId;
			List<Guid> listStructDivisionId = (selectedStructDivisionId==null)
                ? new List<Guid>() //TODO - is this possible?
                : await StructDivision.SelectChildrenAndThisIdListAsync((Guid)selectedStructDivisionId);

			EntityModel dplyModel =
				await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.FetchJoins);

			Filter dplyFilter = Filter.And
				.Equal(deploymentSpecifier.ApiIdentifier.ToString(), Constants.FieldName.ApiIdentifier)
				.In(listStructDivisionId, Constants.FieldName.StructDivisionId);

			if (startDate != null && endDate != null && endDate < startDate)
				return DeploymentInfo.Fail(Constants.Message.InvalidStartEndDate);

			if (startDate != null)
				dplyFilter = dplyFilter.Merge(Filter.And.Equal(startDate, Constants.FieldName.DateStart));

			if (endDate != null)
				dplyFilter = dplyFilter.Merge(Filter.And.Equal(endDate, Constants.FieldName.DateEnd));

            if (startAfter != null && startBefore != null && startBefore < startAfter)
                return DeploymentInfo.Fail(Constants.Message.InvalidStartBeforeAfterDate);

            if (startAfter != null)
                dplyFilter = dplyFilter.Merge(Filter.And.GreaterOrEqual(startAfter, Constants.FieldName.DateStart));

            if (startBefore != null)
                dplyFilter = dplyFilter.Merge(Filter.And.Less(startBefore, Constants.FieldName.DateStart));

            Order orderByDate = Order
                .StartAsc(Constants.FieldName.DateStart)
                .Asc(Constants.FieldName.DateEnd)
                .Asc(Constants.FieldName.NumberId);
            List<DynamicEntity> deployments = await dplyModel.GetAsync(filter: dplyFilter, order: orderByDate, paging: null);

			return DeploymentInfo.Success(deployments);
		}

        /// <summary>
        /// Result information from GetDeploymentInfo (wraps a list of deployments or the error information)
        /// </summary>
        public class DeploymentInfo
        {
            /// <summary>
            /// Return a successful DeploymentInfo that wraps a collection of QNN_DPLY
            /// </summary>
            /// <param name="deployments">collection of QNN_DPLY entity</param>
            /// <param name="statusIdString">list of response status guids to filter on, or empty for all (for use later in stored procedure calls)</param>
            /// <returns></returns>
            public static DeploymentInfo Success(List<DynamicEntity> deployments)
            {
                if (deployments == null) throw new ArgumentNullException(nameof(deployments));
                return new DeploymentInfo(deployments, null);
            }

            /// <summary>
            /// Return a failed DeploymentInfo which wraps a message
            /// </summary>
            /// <param name="message"></param>
            /// <returns></returns>
            public static DeploymentInfo Fail(string message)
            {
                return new DeploymentInfo(null, (message == null ? Constants.Message.UnknownError : message));
            }

            // // // //

            public List<DynamicEntity> Deployments { get; private set; }
            public string Message { get; private set; }
            public bool IsSuccessful { get { return Message == null && Deployments != null; } }
            public bool MultipleDeploymentsFound { get { return IsSuccessful && Deployments.Count > 1; } }
            public bool NoDeploymentsFound { get { return Deployments == null || !Deployments.Any(); } }

            private DeploymentInfo(List<DynamicEntity> deployments, string message)
            {
                this.Deployments = deployments;
                this.Message = message;
            }
        }

        /// <summary>
        /// Check if the authorization header is present in the request and is of the Bearer scheme and if so use it to find the SecurityUser
        /// and check they have the 3pa role. If so return the SecurityUser, if not return an error result that can be returned to the client. 
        /// Such errors will also be logged at warning level here to facilitate troubleshooting.
        /// </summary>
        /// <returns></returns>
        private async Task<Authorize3PARequestResult> Check3PARequestAuthorisation()
        {
            //Following checks are done in ValidateToken too, but for this api we want more useful error messages
            if (!Request.Headers.TryGetValue(HeaderNames.Authorization, out Microsoft.Extensions.Primitives.StringValues authorizationHeaders))
            {
                const string missingHeader = "Authorization header missing";
                if (logger.IsEnabled(LogLevel.Warning)) logger.LogWarning(missingHeader);
                return Authorize3PARequestResult.Unauthorized(missingHeader);
            }
            string authorizationHeader = authorizationHeaders.FirstOrDefault();
            AuthenticationHeaderValue authHeader = AuthenticationHeaderValue.Parse(authorizationHeader);
            if (!"Bearer".Equals(authHeader.Scheme, StringComparison.InvariantCultureIgnoreCase))
            {
                string unsupportedScheme = $"Unsupported Authorization scheme: {authHeader.Scheme}";
                if (logger.IsEnabled(LogLevel.Warning)) logger.LogWarning(unsupportedScheme);
                return Authorize3PARequestResult.Unauthorized(unsupportedScheme);
            }

            SecurityUser user = await jwtService.GetUser(authHeader); //null on incorrect token or invalid Authorization header
            if (user == null || user.IsLocked)
            {
                const string invalidCredentials = "Invalid credentials";
                if (logger.IsEnabled(LogLevel.Warning)) logger.LogWarning(invalidCredentials);
                return Authorize3PARequestResult.Unauthorized(invalidCredentials);
            }

            if (!await SecurityUserToSecurityRole.HasUserRole(user.Id, Constants.Role.ThirdPartyAPIClient))
            {
                string missingRole = $"{user.Name} lacks {Constants.Role.ThirdPartyAPIClient} role";
                if (logger.IsEnabled(LogLevel.Warning)) logger.LogWarning(missingRole);
                return Authorize3PARequestResult.Forbidden(missingRole);
            }

            return Authorize3PARequestResult.Authorized(user);
        }

        /// <summary>
        /// Is the model allowed for ModelApi
        /// </summary>
        private bool IsModelAllowed(string operation, string name, bool hasAccessToken)
        {
            if (string.IsNullOrEmpty(operation)) throw new ArgumentException(operation);
            if (string.IsNullOrEmpty(name)) throw new ArgumentException(nameof(name));
            ThirdPartyPartyApiOptions options = intranetAppSetting.ThirdPartyApi;      
            
            //TODO - currently we only support specifying the operation, we should enhance the setting to allow
            //       specific operations to be specified for each allowed model too

            if (options.AllowedModelsWithoutToken.Contains(name, Constants.Comparers.ObjectNameCaseInsensitive))
            {
                return true;
            }
            if (hasAccessToken && options.AllowedModelsWithToken.Contains(name, Constants.Comparers.ObjectNameCaseInsensitive))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// Result value returned by Authorize3PARequestAsync
        /// If IsFailed then the caller can return the ErrorResult directly to the client,
        /// otherwise the SecurityUser related to the token can be retrieved from AuthorizedUser property.
        /// </summary>
        private class Authorize3PARequestResult
        {
            public static Authorize3PARequestResult Authorized(SecurityUser securityUser)
            {
                return new Authorize3PARequestResult(securityUser, null);
            }

            public static Authorize3PARequestResult Unauthorized(string message)
            {
                return new Authorize3PARequestResult(null, new ObjectResult(message) { StatusCode = StatusCodes.Status401Unauthorized });
            }

            public static Authorize3PARequestResult Forbidden(string message)
            {
                return new Authorize3PARequestResult(null, new ObjectResult(message) { StatusCode = StatusCodes.Status403Forbidden });
            }

            public bool IsFailed { get { return ErrorResult != null; } }
            public SecurityUser AuthorizedUser { get; private set; }
            public ActionResult ErrorResult { get; private set; }

            private Authorize3PARequestResult(SecurityUser authorizedUser, ActionResult errorResult)
            {
                this.AuthorizedUser = authorizedUser;
                this.ErrorResult = errorResult;
            }
        }

    } //end of ThirdPartyApiController
}