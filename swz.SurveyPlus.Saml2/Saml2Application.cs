using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.Saml2
{
    public static class Saml2Application
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(Saml2Application));

        /// <summary>
        /// Logic level validation of the Response from the IdP.
        /// Does decryption, assertion and response signature checks as applicable.
        /// Verifies validity period and audience and issuer are as expected.
        /// Checks InResponseTo against the correlation cookie where applicable. 
        /// A result object is returned with details of the outcome. Where successful it contains the
        /// NameID of the user identified by the response.
        /// </summary>
        public static async Task<SamlAuthenticationResult> ProcessResponse(
            Saml2Options saml2Options, 
            Saml2Keys keys,
            ISamlSchemaProvider schemaProvider,
            string rawxml,
            SamlCorrelationCookie correlationCookie,
            DateTime now)
        {
            if (saml2Options == null)
                throw new ArgumentNullException(nameof(saml2Options));
            if (keys == null)
                throw new ArgumentNullException(nameof(keys));
            if (schemaProvider == null)
                throw new ArgumentNullException(nameof(schemaProvider));
            if (string.IsNullOrWhiteSpace(rawxml))
                throw new ArgumentException("required", nameof(rawxml));
            //the cookie may be null here, will check it later
            DateTime utcNow = now.ToUniversalTime();

            if(saml2Options.IsLogResponseXml && logger.IsEnabled(LogLevel.Debug))
            {
                logger.LogDebug(nameof(ProcessResponse) + " - called, utcNow={0}, correlationCookie={1}, rawxml={2}", utcNow, correlationCookie, rawxml);
            }

            try
            {
                
                bool isResponseSignatureVerified = false;
                bool isAssertionSignatureVerified = false;

                //0. Parse the XML, check structure, locate significant nodes
                SamlResponseXml xml = new SamlResponseXml(rawxml, schemaProvider);

                //1. Check Destination, if not intended for us we can reject it immediately
                bool IsResponseAddressedToUs = saml2Options.IsAssertionConsumerServiceURLSpecified && (saml2Options.AssertionConsumerServiceURL == xml.Destination);
                if (!IsResponseAddressedToUs)
                    return SamlAuthenticationResult.Invalid($"Required destination is {saml2Options.AssertionConsumerServiceURL} but destination in response is {xml.Destination ?? "not specified"}");

                //2. Check the response-level Issuer
                bool isCheckResponseIssuer = xml.IsResponseIssuerSpecified || xml.IsResponseSignaturePresent;
                if(isCheckResponseIssuer)
                {
                    if (saml2Options.IdentityProviderEntityID != xml.ResponseIssuer)
                        return SamlAuthenticationResult.Invalid($"Expected Response Issuer to be {saml2Options.IdentityProviderEntityID} but found {xml.ResponseIssuer??"none"}");
                }

                //3. Verify the Response level signature if required or if present
                bool isCheckResponseSignature = (xml.IsResponseSignaturePresent || saml2Options.IsRequireSignedResponse);
                IEnumerable<RsaSecurityKey> idpPublicKeys
                    = await keys.GetIdentityProviderVerificationPublicKeys();
                if (isCheckResponseSignature)
                {
                    if (saml2Options.IsRequireSignedResponse && !xml.IsResponseSignaturePresent)
                        throw new InvalidOperationException("Response signature is required but was not provided");
                    isResponseSignatureVerified = xml.IsResponseSignedWith(idpPublicKeys);
                    if (!isResponseSignatureVerified)
                        return SamlAuthenticationResult.Invalid($"Response signature failed verification, {idpPublicKeys.Count()} keys were tried");
                }

                //4. Check the StatusCode
                if (!xml.IsSuccessStatus)
                    return SamlAuthenticationResult.Fail(xml.StatusCodes);

                //5. Decrypt the assertion
                if (xml.IsAssertionEncrypted)
                {
                    IEnumerable<RsaSecurityKey> spPrivateKeys
                        = await keys.GetServiceProviderEncryptionPrivateKeys();
                    xml.DecryptAssertion(spPrivateKeys);

                    if (saml2Options.IsLogDecryptedAssertionXml && logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(ProcessResponse) + " - decrypted assertion={0}", xml.AssertionXML);
                    }
                }

                //6. Assertion Issuer check, this one is always required
                if (saml2Options.IdentityProviderEntityID != xml.AssertionIssuer)
                    return SamlAuthenticationResult.Invalid($"Expected Assertion Issuer to be {saml2Options.IdentityProviderEntityID} but found {xml.AssertionIssuer ?? "none"}");

                //7. Verify the assertion signature
                bool isCheckAssertionSignature = (xml.IsAssertionSignaturePresent | saml2Options.IsRequireSignedAssertion);
                if (isCheckAssertionSignature)
                {
                    if (saml2Options.IsRequireSignedAssertion && !xml.IsAssertionSignaturePresent)
                        throw new InvalidOperationException("Assertion signature is required but was not provided");
                    isAssertionSignatureVerified = xml.IsAssertionSignedWith(idpPublicKeys);
                    if (!isAssertionSignatureVerified)
                        return SamlAuthenticationResult.Invalid($"Assertion signature failed verification, {idpPublicKeys.Count()} keys were tried");
                }

                //8. Confirm that at least one signature was actually verified successfully
                //   (This covers the case where we don't explicitly configure which one was needed at SP)
                if (!(isResponseSignatureVerified || isAssertionSignatureVerified))
                    return SamlAuthenticationResult.Invalid("No signatures were verified but at least one signature is required");

                //9. Conditions Audience check
                if (!xml.Audience.Contains(saml2Options.ServiceProviderEntityID))
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(nameof(ProcessResponse) + " - Audience check failed, expected={0}, Audience={1}", saml2Options.ServiceProviderEntityID, string.Join(',', xml.Audience));
                    }
                    return SamlAuthenticationResult.Invalid($"Audience check failed, did not find {saml2Options.ServiceProviderEntityID} in the Assertion's audience list");
                }

                //10. Conditions time check (NotBefore, NotOnOrAfter)
                TimeSpan clockSkew = TimeSpan.FromSeconds(saml2Options.ClockSkewSeconds);
                if (xml.IsConditionsNotBeforeSpecified)
                {
                    if(utcNow < xml.ConditionsNotBefore.Value.ToUniversalTime().Subtract(clockSkew))
                        return SamlAuthenticationResult.Invalid($"Assertion NotBefore check failed, NotBefore= {xml.ConditionsNotBefore}, clockSkew={saml2Options.ClockSkewSeconds}, now={utcNow}");
                }
                DateTime? conditionsNotOnOrAfter;
                if(xml.IsConditionsNotOnOrAfterSpecified)
                {
                    conditionsNotOnOrAfter = xml.ConditionsNotOnOrAfter.Value.ToUniversalTime();
                    if (utcNow >= conditionsNotOnOrAfter.Value.Add(clockSkew))
                        return SamlAuthenticationResult.Invalid($"Assertion NotOnOrAfter check failed, NotOnOrAfter={conditionsNotOnOrAfter}, clockSkew={saml2Options.ClockSkewSeconds}, now={utcNow}");
                }
                else
                {
                    conditionsNotOnOrAfter = null;
                }

                //11. Verify the SubjectConfirmationData (for the bearer method)
                if (saml2Options.AssertionConsumerServiceURL != xml.BearerRecipient)
                    return SamlAuthenticationResult.Invalid($"SubjectConfirmationData Recipient check failed, expected {saml2Options.AssertionConsumerServiceURL} but found {xml.BearerRecipient}");

                DateTime bearerNotOnOrAfter = xml.BearerNotOnOrAfter.Value.ToUniversalTime();
                if (utcNow >= bearerNotOnOrAfter.Add(clockSkew))
                    return SamlAuthenticationResult.Invalid($"SubjectConfirmationData NotOnOrAfter check failed, NotOnOrAfter={bearerNotOnOrAfter}, clockSkew={saml2Options.ClockSkewSeconds}, now={utcNow}");

                //12. Original request correlation - Verify InResponseTo / AssertionID
                //Check the InResponseTo (if provided) for SP initiated login against the ID we
                //recorded in the correlation cookie 
                bool isCheckCorrelation 
                    = saml2Options.IsRequireCorrelationCookie 
                    || xml.IsBearerInResponseToSpecified 
                    || correlationCookie != null;
                if(isCheckCorrelation)
                {
                    if(!xml.IsBearerInResponseToSpecified)
                        return SamlAuthenticationResult.Invalid($"SubjectConfirmationData InResponseTo check failed because InResponseTo is not set");

                    if(correlationCookie == null)
                        return SamlAuthenticationResult.Invalid($"SubjectConfirmationData InResponseTo check failed because the correlation cookie was missing or expired");

                    if(xml.BearerInResponseTo != correlationCookie.OriginalRequestID)
                        return SamlAuthenticationResult.Invalid($"SubjectConfirmationData InResponseTo check failed because the expected ID {correlationCookie.OriginalRequestID} from the cookie did not match the InResponseTo value {xml.BearerInResponseTo}");

                    if(xml.BearerInResponseTo != xml.ResponseInResponseTo)
                        return SamlAuthenticationResult.Invalid($"The InResponseTo value {xml.ResponseInResponseTo} in the Response is not the same as the InResponseTo value {xml.BearerInResponseTo} in the SubjectConfirmationData");
                }

                //13. Replay prevention - Verify AssertionID hasn't been used already
                //We check this by trying to insert to db table where its the key,
                //relying on SQL Server to enforce uniqueness in multi-server environment
                // Assuming both of these were converted to UTC DateTimes during validation
                if(saml2Options.IsCheckForAssertionReplay)
                {
                    DateTime latestExpiration = conditionsNotOnOrAfter > bearerNotOnOrAfter
                    ? conditionsNotOnOrAfter.Value
                    : bearerNotOnOrAfter;
                    DateTime cacheExpiration = latestExpiration.Add(clockSkew * 2).ToUniversalTime(); //UTC!
                    bool isAssertionUnique = await InsertSamlRecentAssertion.NewAssertion(xml.AssertionID, cacheExpiration);
                    if (!isAssertionUnique)
                        return SamlAuthenticationResult.Invalid($"Assertion replay check failed, AssertionID={xml.AssertionID}");
                }
                
                //14. Done
                //n.b. we currently ignore the AuthnContext and AttributeStatement
                return SamlAuthenticationResult.Success(xml.NameID, xml.StatusCodes);

            }
            catch(SamlResponseXml.InvalidResponseXmlException irx)
            {
                return SamlAuthenticationResult.Invalid(irx.Message);
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(ProcessResponse) + " - caught unexpected exception");
                throw new InternalException("Error processing SAML Response", e);
            }
        }

        public static readonly string JobId_CleanupRecentSamlAssertion = "CleanupRecentSamlAssertion";

        /// <summary>
        /// Job to cleanup the expired assertion IDs that we don't need in the database anymore
        /// </summary>
        // *** WARNING ***************************************************************************************************
        // * This is a hangfire entrypoint method.                                                                       *
        // * If changing the method signature please be cautious of existing jobs in database still using old signature! *
        // ***************************************************************************************************************
        public static async Task CleanupRecentSamlAssertionJob()
        {
            try
            {
                logger.LogTrace(nameof(CleanupRecentSamlAssertion) + " - executing job");
                await CleanupRecentSamlAssertion.Execute();
            }
            catch(Exception e)
            {
                logger.LogError(e, nameof(CleanupRecentSamlAssertion) + " - caught unexpected exception");
            }
        }
    }
}
