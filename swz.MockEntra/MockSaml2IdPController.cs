using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using swz.SurveyPlus.Saml2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Encodings.Web;
using System.Threading.Tasks;

namespace swz.MockEntra
{
    /// <summary>
    /// Mock implementation of a SAML2 IdP Controller for testing and development purposes
    /// </summary>
    public class MockSaml2IdPController : Controller
    {
        private readonly ILogger<MockSaml2IdPController> logger;

        private static string HtmlEncode(string s) => string.IsNullOrEmpty(s) ? string.Empty : HtmlEncoder.Default.Encode(s);

        public MockSaml2IdPController(ILogger<MockSaml2IdPController> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("/saml2/handlerequest")]
        public async Task<ActionResult> HandleRequest(
            [FromServices] Saml2Settings saml2,
            [FromServices] MockEntraSamlKeySuppliers keys)
        {
            try
            {
                //Parse and check the incoming request
                SamlRedirect sr = SamlRedirect.FromQueryString(Request.QueryString.Value);
                if ((saml2.IsRequireAuthnRequestSignature || sr.IsSignatureProvided) && !saml2.IsDisableAuthnRequestSignatureVerification)
                {
                    List<SecurityKey> spPublicKeys = await keys.SpVerificationKeySupplier.PublicKeys();
                    sr.AssertSignatureIsValid(spPublicKeys);
                }
                AuthnRequest authnRequest = sr.ToAuthnRequest();
                //TODO - simulate checks on things like issuer and age of issueinstant etc


                //Present the mock 'login page', wth fields where we can edit what we
                //put in the response for testing


                string acsUrl
                    = authnRequest.IsAssertionConsumerServiceURLSpecified
                    ? authnRequest.AssertionConsumerServiceURL
                    : saml2.ServiceProviderAssertionConsumerServiceURL;

                string html = $@"
                    <!DOCTYPE html>
                    <html>
                    <head><title>swz.MockEntra</title></head>
                    <body>
                        <h3>swz.MockEntra</h3>
                        <form method='POST' action='sendresponse'>
                            <table>
                            
                            <tr><td>&nbsp;</td><td>{HtmlEncode(authnRequest.ToString())}</td></tr>

                            <tr><td>User&nbsp;Email</td><td><input type='text' name='userEmail' value='{saml2.DefaultUserEmail}' size='32' /></td></tr>

                            <tr><td>InResponseTo</td><td><input type='text' name='inResponseTo' value='{HtmlEncode(authnRequest.ID)}' size='32' /></td></tr>

                            <tr><td>Response&nbsp;Issuer</td><td><input type='text' name='responseIssuerID' value='{HtmlEncode(saml2.IdentityProviderEntityID)}' size='32' /></td></tr>

                            <tr><td>Assertion&nbsp;Issuer</td><td><input type='text' name='assertionIssuerID' value='{HtmlEncode(saml2.IdentityProviderEntityID)}' size='32' /></td></tr>

                            <tr><td>Audience</td><td><input type='text' name='audience' value='{HtmlEncode(authnRequest.Issuer)}' size='32' /></td></tr>

                            <tr><td>ACS&nbsp;URL</td><td><input type='text' name='acsUrl' value='{HtmlEncode(acsUrl)}' size='64' /></td></tr>

                            <tr><td>RelayState</td><td><input type='text' name='relayState' value='{HtmlEncode(sr.RelayState)}' size='64' /></td></tr>

                            <tr><td>&nbsp;</td><td><button type='submit'>Login</button></td></tr>
                            </table>
                        </form>
                    </body>
                    </html>";
                return Content(html, "text/html");
            }
            catch (Exception e)
            {
                // Gemini notes that "When Entra ID (or any standard Identity Provider like Okta, Ping, or ADFS) receives a
                // fundamentally invalid AuthnRequest—such as one with a bad signature, an unsupported algorithm,
                // or malformed XML—it follows a strict "Fail-Secure / Dead-End" model. Instead of redirecting the user
                // back to your application with an error code, the IdP halts the transaction completely and displays
                // an error page directly to the user.
                //Examples of when Entra ID might redirect back with an error:
                //  1. Passive Authentication Failure: If you send IsPassive = "true" in your AuthnRequest(telling Entra ID to
                //  log the user in silently without showing a UI), but the user doesn't have an active session cookie,
                //  Entra ID will redirect back to your app with a NoPassive error status.
                //
                //  2. User Cancellation: If the user clicks "Cancel" or "Back" during a consent prompt(though Entra's
                //  specific behavior here can sometimes still dead-end depending on tenant settings).

                //TODO - specific exceptions and better UX for those 'expected' failure types

                logger.LogError(e, nameof(HandleRequest) + " - caught exception");
                return StatusCode(500, $"Failed - {e.Message}");
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [Route("/saml2/sendresponse")]
        public async Task<ActionResult> SendResponse(
            [FromServices] Saml2Settings saml2,
            [FromServices] MockEntraSamlKeySuppliers keys)
        {
            try
            {
                string userEmail = Request.Form["userEmail"];
                string responseIssuerID = Request.Form["responseIssuerID"];
                string assertionIssuerID = Request.Form["assertionIssuerID"];
                string audience = Request.Form["audience"];
                string inResponseTo = Request.Form["inResponseTo"];
                string acsUrl = Request.Form["acsUrl"];
                string relayState = Request.Form["relayState"];

                List<string> audienceMembers
                    = Enumerable.Range(0, Random.Shared.Next(1, 9))
                    .Select(_ => $"api://MockID{Guid.NewGuid()}")   //mock data of some other audience
                    .ToList();
                audienceMembers.Add(audience); //Add the real one into the list
                audienceMembers = audienceMembers.OrderBy(item => Random.Shared.Next()).ToList(); //Shuffle

                MockSamlResponse samlResponse = MockSamlResponse.Success(
                    userEmail,
                    inResponseTo, 
                    acsUrl, 
                    responseIssuerID,
                    assertionIssuerID,
                    audienceMembers);

                //TODO keys pleeze
                RsaSecurityKey idpAssertionSigningKey
                    = saml2.IsSignAssertion
                    ? (RsaSecurityKey)(await keys.IdpSigningKeySupplier.PrivateKeys()).FirstOrDefault()
                    : null;
                if (saml2.IsSignAssertion && idpAssertionSigningKey == null)
                    throw new InvalidOperationException("No key to sign Assertion with");

                RsaSecurityKey idpResponseSigningKey
                    = saml2.IsSignResponse
                    ? (RsaSecurityKey)(await keys.IdpSigningKeySupplier.PrivateKeys()).FirstOrDefault()
                    : null;
                if (saml2.IsSignResponse && idpResponseSigningKey == null)
                    throw new InvalidOperationException("No key to sign Response with");

                RsaSecurityKey spEncryptionKey
                    = saml2.IsEncryptAssertion
                    ? (RsaSecurityKey)(await keys.SpEncryptionKeySupplier.PublicKeys()).FirstOrDefault()
                    : null;
                if (saml2.IsEncryptAssertion && spEncryptionKey == null)
                    throw new InvalidOperationException("No key to encrypt Assertion with");

                string responseXml = samlResponse.ToXML(
                    idpAssertionSigningKey,
                    idpResponseSigningKey,
                    spEncryptionKey);

                string relayStateHtml = string.IsNullOrEmpty(relayState)
                    ? ""
                    : $"<input type='text' name='RelayState' value='{HtmlEncode(relayState)}' /><br />";

                //Entra only supports POST binding for the response
                string html 
                    = $@"<html>
                        POSTing to {HtmlEncode(samlResponse.DestinationAcsUrl)}<br/>
                        <body onload='document.forms[0].submit()'>
                            <form method='POST' action='{HtmlEncode(samlResponse.DestinationAcsUrl)}'>
                                SAMLResponse=<input type='text' name='SAMLResponse' value='{HtmlEncode(responseXml)}' /><br />
                                    {relayStateHtml}
                            </form>
                        </body>
                    </html>";

                return Content(html, "text/html");
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SendResponse) + " - caught exception");
                return StatusCode(500, $"Failed - {e.Message}");
            }
        }

        

    }
}
