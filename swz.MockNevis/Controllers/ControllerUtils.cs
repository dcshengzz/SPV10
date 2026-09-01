using Microsoft.AspNetCore.Mvc;

namespace swz.MockNevis.Controllers
{
    public class ControllerUtils
    {
        /// <summary>
        /// Syntactic sugar to return a 200 with the html and content type of text/html
        /// </summary>
        /// <param name="html">content</param>
        /// <returns>asp result to return</returns>
        public static ContentResult HtmlResult(string html)
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
