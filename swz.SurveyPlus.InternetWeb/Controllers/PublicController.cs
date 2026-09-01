using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.InternetWeb.Controllers
{
    public class PublicController : Controller
    {
        /// <summary>
        /// useractioninvoker.jsx will redirect to here for completion without a completion URL
        /// and we will send the user to the defualt builtin thankyou page. We also use this to
        /// log out the anonymous respondent after an anonymous survey
        /// </summary>
        public async Task<ActionResult> Index()
        {
            if(SurveyPlusInternet.IsLoggedInAsAnonymousSample(HttpContext))
            {
                SurveyPlusInternet.ClearRespondentLogin(HttpContext);
            }

            return Redirect(Constants.ThankYouPage);
        }
    }
}