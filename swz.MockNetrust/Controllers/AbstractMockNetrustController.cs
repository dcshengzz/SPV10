using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Net;
using System.Web;

namespace swz.MockNetrust.Controllers
{
    public abstract class AbstractMockNetrustController : Controller
    {
        protected MockNetrustAppSetting settings;
        protected readonly IMockNetrustService service;

        public AbstractMockNetrustController(MockNetrustAppSetting settings, IMockNetrustService service)
        {
            this.settings = settings ?? throw new ArgumentNullException(nameof(settings));
            this.service = service ?? throw new ArgumentNullException(nameof(service));
        }

        /// <summary>
        /// Interrupt redirect flow with a page requiring user interaction.
        /// (This affects how browsers evaluate same-site for cookies)
        /// We also allow editing of nonce, etc for testing purposes.
        /// </summary>
        /// <returns>html</returns>
        public virtual ActionResult SpcpAuthPath()
        {
            string scope = Request.Query["scope"];
            string response_type = Request.Query["response_type"];
            string nonce = Request.Query["nonce"];
            string state = Request.Query["state"];
            //Use the redirect_uri set by SurveyPlus unless explicitly overridden in our appsettings
            string redirectUri = string.IsNullOrWhiteSpace(settings.Locations.Application)
                ? Request.Query["redirect_uri"]
                : settings.Locations.Application;
            string html = $@"
                <!DOCTYPE html>
                <html>
                <head><title>swz.MockNetrust</title></head>
                <body>
                    <h3>swz.MockNetrust</h3>
                    <form method='POST' action='SpcpAuthSubmit'>
                        <table>
                        <tr><td>scope</td><td><strong>{WebUtility.HtmlEncode(scope)}</strong></td></tr>
                        <tr><td>response_type</td><td><strong>{WebUtility.HtmlEncode(response_type)}</strong></td></tr>
                        <tr><td>nonce</td><td><input type='text' name='nonce' value='{WebUtility.HtmlEncode(nonce)}' size='48' /></td></tr>
                        <tr><td>state</td><td><input type='text' name='state' value='{WebUtility.HtmlEncode(state)}' size='48' /></td></tr>
                        <tr><td>redirect_uri</td><td><input type='text' name='redirect_uri' value='{WebUtility.HtmlEncode(redirectUri)}' size='64' /></td></tr>
                        <tr><td>&nbsp;</td><td><button type='submit'>Login as {settings.Token.MockCPEntID}</button></td></tr>
                        </table>
                    </form>
                </body>
                </html>";
            return Content(html, "text/html");
        }

        /// <summary>
        /// Endpoint for submission from the mock SPCP login page, redirects to surveyplus
        /// </summary>
        /// <returns>redirect</returns>
        public virtual ActionResult SpcpAuthSubmit()
        {
            string nonce = Request.Form["nonce"];
            string state = Request.Form["state"];
            string redirectUri = Request.Form["redirect_uri"];
            string code = service.createNewToken(nonce, settings.Token.MockCPEntID);
            NameValueCollection query = HttpUtility.ParseQueryString(string.Empty);
            query.Add("code", code);
            query.Add("state", state);

            UriBuilder uriBuilder = new UriBuilder(redirectUri);
            uriBuilder.Query = query.ToString();

            return Redirect(uriBuilder.ToString());
        }

        /// <summary>
        /// Simulate Call to Netrust Gateway
        /// </summary>
        /// <returns>Token of SPCP</returns>
        public virtual ActionResult NetrustGatewayPath()
        {
            string code = null;
            switch (Request.Method)
            {
                case "POST":
                    StreamReader stream = new StreamReader(Request.Body);
                    string body = stream.ReadToEndAsync().Result;

                    Dictionary<string,string> value = JsonConvert.DeserializeObject<Dictionary<string,string>>(body);
                    code = value["code"];
                    break;
                case "GET":
                    code = Request.Query["code"];
                    break;
            }

            SPCPToken token = service.getToken(code);

            if(token != null)
            {
                return Ok(JsonConvert.SerializeObject(token));
            }

            return Json("Fail to retrive token");
        }
    }
}
