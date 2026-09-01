using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.SurveyPlus.InternetApplication;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.MockClamRestApi.Controllers
{
    public class MockTrendRestApiController : Controller
    {
        private readonly ILogger<MockTrendRestApiController> _logger;

        public MockTrendRestApiController(ILogger<MockTrendRestApiController> logger)
        {
            _logger = logger;
        }

        /// <summary>
        /// Exposes the /hello endpoint, useful for checking if running, as a target etc
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [HttpPost]
        [Route("hello2")]
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
        [Route("/")]
        public async Task<ActionResult> ScanFile()
        {
            IFormFile file = Request.Form.Files[0];
            TrendAVResult result = null;

            if (Request.Form.Files.Count <= 0)
                result = new TrendAVResult
                    (
                    ResultCode: "400",
                    Message: "Bad Request",
                    Detail: "There is something wrong with the request the client has sent",
                    Reference: "ff6537c3e8a46a82b9ffe0bc9a4c8600",
                    Filename: file.FileName,
                    version: "123456",
                    TransactionDate: DateTime.Now.ToString()
                    );

            else if (file.FileName.Contains("virus"))
                result = new TrendAVResult
                    (
                    ResultCode: "450",
                    Message: "Virus Found",
                    Detail: "Trend Micro said there is a virus",
                    Reference: "ff6537c3e8a46a82b9ffe0bc9a4c8600",
                    Filename: file.FileName,
                    version: "123456",
                    TransactionDate: DateTime.Now.ToString()
                    );
            else if (file.FileName.Contains("serverdown"))
                result = new TrendAVResult
                    (
                    ResultCode: "503",
                    Message: "Trend Micro Server is Unavailable",
                    Detail: "The API is trying to communicate with the TM Server but the TM Server is Unavailable",
                    Reference: "ff6537c3e8a46a82b9ffe0bc9a4c8600",
                    Filename: file.FileName,
                    version: "123456",
                    TransactionDate: DateTime.Now.ToString()
                    );
            else if (Request.Headers["APIKEY"] != "xhsrQdjFLtno7JETNDKwECnN")
                result = new TrendAVResult
                    (
                    ResultCode: "403",
                    Message: "Not Authorized",
                    Detail: "Keys are Not Allowed",
                    Reference: "ff6537c3e8a46a82b9ffe0bc9a4c8600",
                    Filename: file.FileName,
                    version: "123456",
                    TransactionDate: DateTime.Now.ToString()
                    );
            else if (file.ContentType == "application/octet-stream")
                result = new TrendAVResult
                    (
                    ResultCode: "415",
                    Message: "File type Unsupported",
                    Detail: "Filetype is not the Accepted file",
                    Reference: "ff6537c3e8a46a82b9ffe0bc9a4c8600",
                    Filename: file.FileName,
                    version: "123456",
                    TransactionDate: DateTime.Now.ToString()
                    );
            else if (file.Length > 1073741824)
                result = new TrendAVResult
                    (
                    ResultCode: "413",
                    Message: "File too Large",
                    Detail: "File is too big from the maximum of 1GB",
                    Reference: "ff6537c3e8a46a82b9ffe0bc9a4c8600",
                    Filename: file.FileName,
                    version: "123456",
                    TransactionDate: DateTime.Now.ToString()
                    );
            else if (file.FileName.Contains("encrypted"))
                result = new TrendAVResult
                    (
                    ResultCode: "406",
                    Message: "File is Encrypted",
                    Detail: "The Scan Cannot Recognize the file because it might be encrypted",
                    Reference: "ff6537c3e8a46a82b9ffe0bc9a4c8600",
                    Filename: file.FileName,
                    version: "123456",
                    TransactionDate: DateTime.Now.ToString()
                    );
            else if (file.FileName.Contains("configerror"))
                result = new TrendAVResult
                    (
                    ResultCode: "500",
                    Message: "Configuration Error",
                    Detail: "There was a problem with the file you have submitted",
                    Reference: "ff6537c3e8a46a82b9ffe0bc9a4c8600",
                    Filename: file.FileName,
                    version: "123456",
                    TransactionDate: DateTime.Now.ToString()
                    );
            else
                result = new TrendAVResult
                    (
                    ResultCode: "200",
                    Message: "Success - No Virus",
                    Detail: "File has no Virus",
                    Reference: "ff6537c3e8a46a82b9ffe0bc9a4c8600",
                    Filename: file.FileName,
                    version: "123456",
                    TransactionDate: DateTime.Now.ToString()
                    );
            return Json(result);
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
