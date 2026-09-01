using Microsoft.AspNetCore.Mvc;
using System;
using Microsoft.IdentityModel.JsonWebTokens;
using System.Text;
using System.Web;

namespace swz.MockNevis.Controllers
{
    /// <summary>
    /// A simple controller that can stand in during development 
    /// for the Nevis SPCP gateway used in certain SPCP integrations.
    /// There are two concrete subclasses to provide routes for simulating
    /// corppass and singpass respectively.
    /// </summary>
    public abstract class AbstractMockNevisController : Controller
    {
        protected MockNevisAppSetting settings;
        protected readonly IMockNevisService service;

        public AbstractMockNevisController(MockNevisAppSetting settings, IMockNevisService service)
        {
            this.settings = settings ?? throw new ArgumentNullException(nameof(settings));
            this.service = service ?? throw new ArgumentNullException(nameof(service));
        }

        /// <summary>
        /// Endpoint which the Login button will direct the user to (GET).
        /// In the real gateway this kicks off the SPCP authentication flows. 
        /// At the end it returns a 302 targetting the returnUrl which will be the
        /// token consumption path which is also in Nevis (here simulated by ConsumeToken).
        /// </summary>
        /// <param name="returnUrl">token consumption path</param>
        /// <returns>302 to the returnUrl</returns>
        public virtual ActionResult AuthenticationPath(string returnUrl)
        {
            if (string.IsNullOrEmpty(returnUrl)) return BadRequest("returnUrl not specified");
            string tokenConsumptionPath = returnUrl;
            return Redirect(tokenConsumptionPath);
        }

        /// <summary>
        /// The end-result of the Nevis-SPCP authentication flows is a 302 to
        /// the token-consumption-path in Nevis, which this method mocks 
        /// It will return a self-submitting html form containing a JWT token
        /// which will POST to the application (SurveyPlus) with the Nevis token.
        /// Here we use our configuration settings to create a suitable mock
        /// token to pass.
        /// </summary>
        /// <returns>html self-posting form with a jwt</returns>
        public virtual ActionResult TokenConsumptionPath()
        {
            JsonWebToken token = service.CreateNewToken(); //Generate a token simulating one we'd expect from nevis

            string mispTokenUrl = settings.Locations.Application;
            
            string rawToken = HttpUtility.HtmlEncode(token.EncodedToken);
            int delayMs = settings.Preferences.SelfPostDelaySeconds * 1000;
            bool delayEnabled = delayMs >= 0;
            string onload = delayEnabled ? $" onload=\"window.setTimeout( () => document.jwtform.submit(), {delayMs});\"" : "";

            string encryptionAlgorithmsInfo = settings.Token.IsUsingEncryption
                ? $"JWE Alg (KeyWrap) = {token.Alg}<br/>" //in System.IdentityModel it was token.EncryptingCredentials.Alg
                  + $"JWE Enc (Payload) = {token.Enc}<br/>" //in System.IdentityModel it was token.EncryptingCredentials.Enc
                : "(JWE not configured)<br/>";

            //For JWE Alg refers to keywrap algorithm, for JWT it refers to signature algorithm (or at least looks that way)
            //in the old System.Identity it was always under token.SignatureAlgorithm
            string signatureAlg = settings.Token.IsUsingEncryption ? "(need to decrypt JWT payload of JWE to determine signature algorithm)" : token.Alg;
            string selfPostingForm 
                = "<html><head><title>MockNevis JWT Form</title>"
                + "<style>h2 {margin-block-end: 0em;}</style></head>"
                + $"<body style=\"background-color: #6C8BED\"{onload}>" 
                + $"<form name=\"jwtform\" action=\"{mispTokenUrl}\" method=\"post\">"
                + $"<div style=\"vertical-align:middle; display:inline; width: 100%; font-size: 3rem;\">"
                + $"<img style=\"vertical-align:middle; height: 3rem;\" src=\"/images/mockNevis.png\"/>"
                + $"Mock Nevis JWT Form</div><br/>"
                + $"<h2>Algorithms:</h2>"
                + $"JWS Signature = {signatureAlg}<br/>"
                + encryptionAlgorithmsInfo
                + $"<h2>Token Claims:</h2>"
                + "<div style='font-family: monospace'>" + ClaimsHtml(token) + "</div>"
                + $"<br/>"
                + $"<textarea readonly=\"readonly\" name=\"{settings.Token.TokenParameter}\" cols=\"80\" rows=\"16\">{rawToken}</textarea><br/>"
                + $"<button type=\"submit\">POST to {HttpUtility.HtmlEncode(mispTokenUrl)}</textarea>&nbsp;"
                + $"<br/>" + (delayEnabled 
                    ? $"(Form will self-post after {delayMs} milliseconds)" 
                    : "(Form self-post is switched off)")
                
                + $"</button>&nbsp; TokenParameter={settings.Token.TokenParameter}"
                + $"</form></body></html>";
            return ControllerUtils.HtmlResult(selfPostingForm);
        }

        private string ClaimsHtml(JsonWebToken token)
        {
            if (token.IsEncrypted) return "<i>(need to decrypt JWT payload of JWE to inspect claims)</i>";
            StringBuilder b = new StringBuilder();
            foreach(var claim in token.Claims)
            {
                bool highlight = ("sub".Equals(claim.Type) || "entityInfo".Equals(claim.Type));
                string type = HttpUtility.HtmlEncode(claim.Type);
                string value = HttpUtility.HtmlEncode(claim.Value);
                if (highlight) b.Append("<strong>");
                b.Append($"{type} = {value}");
                if (highlight) b.Append("</strong>");
                b.Append("<br/>");
            }
            return b.ToString();
        }

        //private void AnalyseToken(JsonWebToken token)
        //{
        //    JsonWebTokenHandler tokenHandler = new JsonWebTokenHandler();

        //    TokenValidationParameters validationParameters = new TokenValidationParameters()
        //    {
        //        RequireAudience = false,
        //        ValidateAudience = false,
        //        IgnoreTrailingSlashWhenValidatingAudience = true,

        //        ValidateIssuer = false,

        //        RequireExpirationTime = false,
        //        ValidateLifetime = false,

        //        RequireSignedTokens = false,
        //        ValidateIssuerSigningKey = false,

        //        TokenDecryptionKeys = surveyPlusPrivateKeys,

        //        //ValidAlgorithms = nevisSettings.IsRestrictAlgorithms ? nevisSettings.GetValidAlgorithms() : null,

        //    };
        //    TokenValidationResult result = tokenHandler.ValidateTokenAsync(token, validationParameters).Result;
        //    bool valid = result.IsValid;
        //    //.....
        //}
    }
}
