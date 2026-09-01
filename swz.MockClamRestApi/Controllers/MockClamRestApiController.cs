using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.SurveyPlus.InternetApplication;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.MockClamRestApi.Controllers
{
    public class MockClamRestApiController : Controller
    {
        private readonly ILogger<MockClamRestApiController> _logger;

        public MockClamRestApiController(ILogger<MockClamRestApiController> logger)
        {
            _logger = logger;
        }

        /// <summary>
        /// Exposes the /hello endpoint, useful for checking if running, as a target etc
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [HttpPost]
        [Route("hello")]
        public ActionResult HelloWorld(string jwt)
        {
            return HtmlResult(
                  $"<html><body style=\"background-color: #6C8BED\">"
                + $"<div style=\"vertical-align:middle; display:inline; width: 100%; font-size: 3rem;\">"
                + $"<img style=\"vertical-align:middle; height: 3rem;\" src=\"images/mockNevis.png\"/>"
                + $"MockNevis says Hello</div><br/><br/>"
                + $"</body></html>");
        }

        [HttpPost]
        [Route("api/v1/scan")]
        public async Task<ActionResult> ScanFile()
        {
            ClamAVResult result = new ClamAVResult();
            result.data = new ClamAVData();
            try
            {
                if (Request.Form.Files.Count <= 0) 
                    throw new Exception("File is not found.");

                IFormFile file = Request.Form.Files[0];

                List<ClamAVDataItem> resultDataList = new List<ClamAVDataItem>();
                ClamAVDataItem resultData = null;
                if (file.FileName.Contains("virus"))
                {
                    resultData = new ClamAVDataItem(file.FileName, true, new string[] { "The mocked virus No.1", "The m0ck v1ru5 No.2" });
                }
                else
                {
                    resultData = new ClamAVDataItem(file.FileName);
                }

                resultDataList.Add(resultData);
                result.data.result = resultDataList.ToArray();
                result.success = true;
            }
            catch (Exception ex)
            {
                result.message = ex.Message;
                result.success = false;
            }
            return Json(result);
        }

        [HttpGet]
        [Route("api/v1/version")]
        public async Task<ActionResult> CheckVersion()
        {
            return Json(
                new { 
                    success = true, 
                    data = new { version = "ClamAV 0.105.0/26519/Thu Apr 21 16:23:36 2022\n" }
                });
        }

        /// <summary>
        /// Syntactic sugar to return a 200 with the html and content type of text/html
        /// </summary>
        /// <param name="html">content</param>
        /// <returns>asp result to return</returns>
        private ContentResult HtmlResult(string html)
        {
            return new ContentResult
            {
                ContentType = "text/html",
                StatusCode = 200,
                Content = html
            };
        }
    }
}
