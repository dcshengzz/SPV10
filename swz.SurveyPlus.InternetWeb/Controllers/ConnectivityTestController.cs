using System;
using System.Threading.Tasks;
using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.InternetApplication;

namespace swz.SurveyPlus.InternetWeb.Controllers
{
    public class ConectivityTestController : Controller
    {
        private readonly ILogger logger;
        private readonly IRespondentService respondentService;
        private readonly CommonPageSettingsOptions CommonPageSettings; //deliberately capitalised to match use elsewhere
        private readonly SurveyPlusOptions surveyPlusOptions;

        public ConectivityTestController(
            IRespondentService respondentService,
            ILogger<ConectivityTestController> logger,
            CommonPageSettingsOptions commonPageSettings,
            SurveyPlusOptions surveyPlusOptions)
        {
            this.CommonPageSettings = commonPageSettings ?? throw new ArgumentNullException(nameof(commonPageSettings)); ;
            this.respondentService = respondentService ?? throw new ArgumentNullException(nameof(respondentService));
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.surveyPlusOptions = surveyPlusOptions ?? throw new ArgumentNullException(nameof(surveyPlusOptions));
        }

        [HttpGet]
        [Route("debug/apiconnectivitytest")]
        public async Task<IActionResult> ApiConnectivityTest(string accessCode)
        {
            try
            {
                bool enabled = !string.IsNullOrWhiteSpace(surveyPlusOptions.ApiConnectivityTestAccessCode);
                if (!enabled)
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                        logger.LogDebug(nameof(ApiConnectivityTest) + " - was called but is not enabled in appsettings");
                    return NotFound();
                }
                else
                {
                    bool validAccessCodeProvided = surveyPlusOptions.ApiConnectivityTestAccessCode.Equals(accessCode);
                    if (!validAccessCodeProvided)
                    {
                        return new ContentResult
                        {
                            ContentType = "text/plain",
                            StatusCode = 403,
                            Content = Constants.Message.YouDontHaveThePermission,
                        };
                    }
                    else
                    {
                        //n.b since we only have U@App at the moment, the page text is somewhat specific to that, so if we ever
                        //add other impls (like U@Db) then revise the text to be more general or based on which impl is in use.
                        try
                        {
                            string result = await respondentService.ConnectivityTest();
                            string content = $"<html><body><head><title>{WebUtility.HtmlEncode(CommonPageSettings.ShortApplicationName)}</title></head><h1>Internet Application U@App API Connectivity Test: <strong style=\"background-color: green; color: black;\">SUCCESS</strong></h1><p>Note that this tests only a basic minimal level of connectivity from internet application to intranet application for the route <strong>{Constants.UAppRoutes.ApiBase}{Constants.UAppRoutes.ConnectivityTest}</strong><br/>Individual U@App API endpoints may still need verification via application functionality testing.</p><p><strong>Result Message:</strong>{WebUtility.HtmlEncode(result)}</p></body></html>";
                            return new ContentResult
                            {
                                ContentType = "text/html",
                                StatusCode = 200,
                                Content = content,
                            };
                        }
                        catch (Exception e)
                        {
                            logger.LogError(e, nameof(ApiConnectivityTest) + " - encountered an exception while performing the test");
                            return new ContentResult
                            {
                                ContentType = "text/html",
                                StatusCode = 500,
                                Content = $"<html><body><head><title>{WebUtility.HtmlEncode(CommonPageSettings.ShortApplicationName)}</title></head><h1>Internet Application U@App API Connectivity Test: <strong style=\"background-color: red; color: black;\">FAIL</strong></h1><p>Oh no! Please check logs for details</p></body></html>",
                                //TODO - can we output which appserver to check on ?
                            };
                        }
                    }
                }
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(ApiConnectivityTest) + " - encountered an unexpected exception");
                return new StatusCodeResult(((int)HttpStatusCode.InternalServerError));
            }
        }
    }
}
