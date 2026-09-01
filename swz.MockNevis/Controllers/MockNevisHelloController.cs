using Microsoft.AspNetCore.Mvc;

namespace swz.MockNevis.Controllers
{
    public class MockNevisHelloController : Controller
    {

        [HttpGet]
        [HttpPost]
        [Route("singpass/hello")]
        public ActionResult HelloWorld(string jwt)
        {
            return ControllerUtils.HtmlResult(
                  $"<html><body style=\"background-color: #6C8BED\">"
                + $"<div style=\"vertical-align:middle; display:inline; width: 100%; font-size: 3rem;\">"
                + $"<img style=\"vertical-align:middle; height: 3rem;\" src=\"images/mockNevis.png\"/>"
                + $"MockNevis says Hello</div><br/><br/>"
                + $"{jwt}<br/>"
                + $"</body></html>");
        }
    }
}
