using Microsoft.AspNetCore.Mvc;

namespace swz.SurveyPlus.InternetWeb.Controllers
{
    [Route("error")]
    public class ErrorController : Controller
    {
        [Route("500")]
        public IActionResult Error500()
        {
			return LocalRedirect("/error/index.html");
        }

        [Route("404")]
        public IActionResult PageNotFound()
        {
			return LocalRedirect("/error/index.html");
		}
    }
}