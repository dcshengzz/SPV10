using System;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.SPCP;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.InternetApplication;

namespace swz.SurveyPlus.InternetWeb.Controllers
{
    //NOTE: No CheckSessionFilter here, I presume it was removed to allow for anonymous login

    //survey form
    //if it is anonymous survey, add uid session; respondent grid should filter out anonymous deployment
    //TODO rename this controller so its purpose is clearer to the casual glance
    public class StarterApplicationController : Controller
    {
        private readonly ILogger logger;
        private readonly IRespondentService respondentService;
        private readonly CommonPageSettingsOptions CommonPageSettings;  //deliberately capitalised
        private readonly SPCPOptions spcpOptions;

        public StarterApplicationController(
            IRespondentService respondentService, 
            ILogger<StarterApplicationController> logger, 
            CommonPageSettingsOptions commonPageSettings,
            SPCPOptions spcpOptions)
        {
            this.CommonPageSettings = commonPageSettings ?? throw new ArgumentNullException(nameof(commonPageSettings)); ;
            this.respondentService = respondentService ?? throw new ArgumentNullException(nameof(respondentService));
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.spcpOptions = spcpOptions ?? throw new ArgumentNullException(nameof(spcpOptions));
        }

        /// <summary>
        /// Adapted from decompiled code of Microsoft.ApplicationInsights.AspNetCore.Extensions.HttpRequestExtensions
        /// so that we can remove that PackageReference, this will give the Uri of the request
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        private Uri GetUri()
        {
            HttpRequest request = Request;

            if (request == null)
            {
                throw new ArgumentNullException("request");
            }

            if (string.IsNullOrWhiteSpace(request.Scheme))
            {
                throw new ArgumentException("Http request Scheme is not specified");
            }

            if (!request.Host.HasValue)
            {
                throw new ArgumentException("Http request Host is not specified");
            }

            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(request.Scheme).Append("://").Append(request.Host);
            if (request.Path.HasValue)
            {
                stringBuilder.Append(request.Path.Value);
            }

            if (request.QueryString.HasValue)
            {
                stringBuilder.Append(request.QueryString);
            }

            return new Uri(stringBuilder.ToString());
        }

        public async Task<IActionResult> Index()
        {
            try
            {
                ViewData[nameof(CommonPageSettings)] = CommonPageSettings;
                ViewData["IsSPCPLogin"] = spcpOptions.IsSPCPLogin; //nb: means enabled as a global internet setting (na for anonymous)
                
                Uri myUri = GetUri();
                string dlsiSegment = myUri.Segments?[myUri.Segments.Length - 1];

                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace("Index dlsi={0}", dlsiSegment);
                }

                if (!Guid.TryParse(dlsiSegment, out Guid dlsi)) return NotFound(); //previously Redirect(loginPageUrl);

                //nb: I make repeated calls to IsLoggedIn below rather than store the value in a bool because
                //    depending on which logic branches are executed the login state may change

                bool isAnonymousSurvey = await respondentService.IsAnonymousSurveyAsync(dlsi);
                if (isAnonymousSurvey)
                {
                    //For an anonymous survey, check if the respondent is already logged in as a normal
                    //sample (i.e. other than swzAnonymous) and log them out first before proceeding
                    bool isLoggedInAsAnotherSample
                        = SurveyPlusInternet.IsLoggedIn(HttpContext, out string uid)
                        && !TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IsAnonymousSample(uid);
                    if(isLoggedInAsAnotherSample)
                    {
                        await SurveyPlusInternet.Logoff(logger, HttpContext, respondentService);
                    }

                    //At this point, if they aren't already logged in as swzAnonymous yet then we need to do that
                    bool performAnonymousLoginNow = !SurveyPlusInternet.IsLoggedInAsAnonymousSample(HttpContext);
                    if (performAnonymousLoginNow)
                    {
                        try
                        {
                            LoginResult result = await respondentService.PasswordLoginAsync(
                                Constants.SwzAnonymous.Uid, 
                                Constants.SwzAnonymous.Password);
                            if (result.IsSuccess)
                            {
                                SurveyPlusInternet.RecordRespondentLogin(result, HttpContext);                                
                            }
                            else
                            {
                                //For the anonymous login it shouldn't fail because the call is coming from inside the house,
                                //not the clientside, so a failure here is our fault, not the user's
                                throw new InternalException($"{nameof(IRespondentService.PasswordLoginAsync)} unexpectedly failed with reason{result.Reason}");
                            }
                        }
                        catch (Exception e)
                        {
                            //Wrap anything that goes wrong here. Will be logged in the outer catch block.
                            throw new InternalException($"Failure to perform the anonymous login, Message={e.Message}", e);
                        }
                    } //end if performAnonymousLoginNow

                    //If, as expected, is an anonymous survey, and we are indeed logged in as anonymous,
                    //then all is well and we can proceed to the view
                    if (!SurveyPlusInternet.IsLoggedInAsAnonymousSample(HttpContext))
                        throw new InternalException("Internal assertion failure, not logged in as anonymous but this is an anonymous survey");  
                } //end if is anonymous survey
                else 
                {  
                    //This is NOT an anonymous survey so verify we are properly logged in as a normal respondent
                    if(  !SurveyPlusInternet.IsLoggedIn(HttpContext)
                       || SurveyPlusInternet.IsLoggedInAsAnonymousSample(HttpContext))
                    {
                        throw new SessionInvalidException();
                    }
                    else
                    {
                        await respondentService.VerifySessionActive(); //Check session was not invalidated on api side
                    }
                }

                return View(Constants.ViewName.Index);
            }
            catch (SessionInvalidException)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                    logger.LogDebug(nameof(Index) + " - invalidated sesssion");
                return SurveyPlusInternet.InvalidateSessionAndRedirectToLogin(HttpContext);
            }
            catch (Exception e)
            {
                //Unexpected exception. Log it and fail. 
                logger.LogError(e, nameof(Index) + " - caught unexpected exception");
                return StatusCode(StatusCodes.Status500InternalServerError, "Internal Error, please contact helpdesk for assistance");
            }
        } //end of Index


    } //end of StarterApplicationController
}
