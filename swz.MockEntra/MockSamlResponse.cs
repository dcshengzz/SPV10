using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Security.Cryptography;
using System.Security.Cryptography.Xml;
using System.Xml;
using Microsoft.IdentityModel.Tokens;

namespace swz.MockEntra
{
    public class MockSamlResponse
    {
        /// <summary>
        /// Defines some constants for XML namespaces used here
        /// </summary>
        private static class NS
        {
            public static class Prefix
            {
                public const string Protocol = "samlp";
                public const string Assertion = "saml";                
            }

            public static class Uri
            {
                public const string Protocol = "urn:oasis:names:tc:SAML:2.0:protocol";
                public const string Assertion = "urn:oasis:names:tc:SAML:2.0:assertion";
            }
        }

        public static MockSamlResponse Success(
            string userEmail, 
            string inResponseToId, 
            string destinationAcsUrl, 
            string responseIssuerEntityId,
            string assertionIssuerEntityId,
            IEnumerable<string> audience)
        {
            const int expirySeconds = 300;
            MockSamlResponse r = new MockSamlResponse
            {
                StatusCodes = ["urn:oasis:names:tc:SAML:2.0:status:Success","urn:example:foo", "urn:example:bar"], //success doesn't really have secondary codes IRL...
                UserEmail = userEmail,
                ID = "_" + Guid.NewGuid().ToString("N"),
                AssertionID = "_" + Guid.NewGuid().ToString("N"),
                IssueInstant = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ss.fffZ", CultureInfo.InvariantCulture),
                NotOnOrAfter = DateTime.UtcNow.AddSeconds(expirySeconds).ToString("yyyy-MM-ddTHH:mm:ss.fffZ", CultureInfo.InvariantCulture),
                ResponseIssuer = responseIssuerEntityId,
                AssertionIssuer = assertionIssuerEntityId,
                Audience = audience,
                InResponseToId = inResponseToId,
                DestinationAcsUrl = destinationAcsUrl
            };
            return r;
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        public string ID { get; private set; }

        public string AssertionID { get; private set; }

        public string IssueInstant { get; private set; }

        public string UserEmail { get; private set; }

        public string ResponseIssuer { get; private set; }

        public string AssertionIssuer { get; private set; }

        public string DestinationAcsUrl { get; private set; }

        public string InResponseToId { get; private set; }

        public List<string> StatusCodes { get; private set; }

        public string NotOnOrAfter { get; private set; }

        public IEnumerable<string> Audience { get; private set; }

        private MockSamlResponse()
        {
            ; //private constructor and all construction is done by factory methods
        }

        //TODO - support failure case too
        public string ToXML(
            RsaSecurityKey idpAssertionSigningKey,
            RsaSecurityKey idpResponseSigningKey,
            RsaSecurityKey spEncryptionKey)
        {
            bool isSignAssertion = (idpAssertionSigningKey != null);
            bool isSignResponse = (idpResponseSigningKey != null);
            bool isEncryptAssertion = (spEncryptionKey != null);


            // Extract standard RSA cryptography objects from RSASecurityKey
            //AH BROKEN LOGIC because no 'using' when one is created from parameters
            //   also note that if we get from the key then we should NOT dispose it ourselves
            //   so need to track how we get hold of it and handle accordingly
            //   thinking to add a wrapper class in KeyUtils that bundles that flag and a dispose method 
            //   and then make it a using here TODO TODO TODO !!!
                 // update to use SamlDisposalTracker now (lower priority because this is just the mock)
            RSA idpAssertionRsa
                = isSignAssertion
                ? idpAssertionSigningKey.Rsa ?? RSA.Create(idpAssertionSigningKey.Parameters)
                : null;
            RSA idpRsa
                = isSignResponse
                ? idpResponseSigningKey.Rsa ?? RSA.Create(idpResponseSigningKey.Parameters)
                : null;
            RSA spRsa
                = isEncryptAssertion
                ? spEncryptionKey.Rsa ?? RSA.Create(spEncryptionKey.Parameters)
                : null;

            XmlDocument doc = new XmlDocument { PreserveWhitespace = true };

            // ---------------------------------------------------------------------
            // 1. BUILD RAW XML DOM (<samlp:Response> + <saml:Assertion>)
            // ---------------------------------------------------------------------
            XmlElement responseElement = doc.CreateElement(NS.Prefix.Protocol, "Response", NS.Uri.Protocol);
            responseElement.SetAttribute("ID", ID);
            responseElement.SetAttribute("Version", "2.0");
            responseElement.SetAttribute("IssueInstant", IssueInstant);
            responseElement.SetAttribute("Destination", DestinationAcsUrl);
            if (!string.IsNullOrEmpty(InResponseToId))
            {
                responseElement.SetAttribute("InResponseTo", InResponseToId);
            }
            doc.AppendChild(responseElement);

            // <saml:Issuer> (Response level)
            XmlElement responseIssuer = doc.CreateElement(NS.Prefix.Assertion, "Issuer", NS.Uri.Assertion);
            responseIssuer.InnerText = ResponseIssuer;
            responseElement.AppendChild(responseIssuer);

            // <samlp:Status>
            XmlElement status = doc.CreateElement(NS.Prefix.Protocol, "Status", NS.Uri.Protocol);
            if (StatusCodes != null && StatusCodes.Count > 0)
            {
                XmlElement currentParent = status;
                foreach (string codeValue in StatusCodes)
                {
                    XmlElement statusCode = doc.CreateElement(NS.Prefix.Protocol, "StatusCode", NS.Uri.Protocol);
                    statusCode.SetAttribute("Value", codeValue);
                    currentParent.AppendChild(statusCode);
                    currentParent = statusCode;
                }
            }
            responseElement.AppendChild(status);

            //TODO - support failed response with no assertion

            // <saml:Assertion>
            XmlElement assertionElement = doc.CreateElement(NS.Prefix.Assertion, "Assertion", NS.Uri.Assertion);
            assertionElement.SetAttribute("ID", AssertionID);
            assertionElement.SetAttribute("Version", "2.0");
            assertionElement.SetAttribute("IssueInstant", IssueInstant);

            // <saml:Issuer> (Assertion level) - mandatory
            XmlElement assertionIssuer = doc.CreateElement(NS.Prefix.Assertion, "Issuer", NS.Uri.Assertion);
            assertionIssuer.InnerText = AssertionIssuer;
            assertionElement.AppendChild(assertionIssuer);

            // <saml:Subject>
            XmlElement subject = doc.CreateElement(NS.Prefix.Assertion, "Subject", NS.Uri.Assertion);
            XmlElement nameId = doc.CreateElement(NS.Prefix.Assertion, "NameID", NS.Uri.Assertion);
            nameId.SetAttribute("Format", "urn:oasis:names:tc:SAML:2.0:nameid-format:emailAddress");
            nameId.InnerText = UserEmail;
            subject.AppendChild(nameId);

            XmlElement subjectConfirmation = doc.CreateElement(NS.Prefix.Assertion, "SubjectConfirmation", NS.Uri.Assertion);
            subjectConfirmation.SetAttribute("Method", "urn:oasis:names:tc:SAML:2.0:cm:bearer");
            XmlElement scData = doc.CreateElement(NS.Prefix.Assertion, "SubjectConfirmationData", NS.Uri.Assertion);
            scData.SetAttribute("Recipient", DestinationAcsUrl);
            scData.SetAttribute("NotOnOrAfter", NotOnOrAfter);
            if (!string.IsNullOrEmpty(InResponseToId))
            {
                scData.SetAttribute("InResponseTo", InResponseToId);
            }
            subjectConfirmation.AppendChild(scData);
            subject.AppendChild(subjectConfirmation);
            assertionElement.AppendChild(subject);

            // <saml:Conditions>
            XmlElement conditions = doc.CreateElement(NS.Prefix.Assertion, "Conditions", NS.Uri.Assertion);
            conditions.SetAttribute("NotBefore", IssueInstant);
            conditions.SetAttribute("NotOnOrAfter", NotOnOrAfter);
            assertionElement.AppendChild(conditions);

            // <saml:AudienceRestriction>
            if(Audience.Any())
            {
                XmlElement audienceRestriction = doc.CreateElement(NS.Prefix.Assertion, "AudienceRestriction", NS.Uri.Assertion);
                foreach (string member in Audience)
                {
                    XmlElement audience = doc.CreateElement(NS.Prefix.Assertion, "Audience", NS.Uri.Assertion);
                    audience.InnerText = member;
                    audienceRestriction.AppendChild(audience);
                }
                conditions.AppendChild(audienceRestriction);
            }
            
            // <saml:AuthnStatement>
            //this info is fake for the mock    TODO
            XmlElement authnStatement = doc.CreateElement(NS.Prefix.Assertion, "AuthnStatement", NS.Uri.Assertion);
            authnStatement.SetAttribute("AuthnInstant", IssueInstant);
            XmlElement authnContext = doc.CreateElement(NS.Prefix.Assertion, "AuthnContext", NS.Uri.Assertion);
            XmlElement authnContextClassRef = doc.CreateElement(NS.Prefix.Assertion, "AuthnContextClassRef", NS.Uri.Assertion);
            authnContextClassRef.InnerText = "urn:oasis:names:tc:SAML:2.0:ac:classes:unspecified";
            authnContext.AppendChild(authnContextClassRef);
            authnStatement.AppendChild(authnContext);
            assertionElement.AppendChild(authnStatement);

            responseElement.AppendChild(assertionElement);

            // ---------------------------------------------------------------------
            // 2. SIGN ASSERTION (If Requested)
            // ---------------------------------------------------------------------
            if (isSignAssertion)
            {
                SignElement(doc, assertionElement, AssertionID, idpRsa, insertAfterElement: assertionIssuer);
            }

            // ---------------------------------------------------------------------
            // 3. ENCRYPT ASSERTION (If Requested)
            // ---------------------------------------------------------------------
            if (isEncryptAssertion)
            {
                // Encrypt the target assertion using AES-256
                using var aes = Aes.Create();
                aes.KeySize = 256;
                aes.GenerateKey();

                EncryptedData ed = new EncryptedData
                {
                    Type = EncryptedXml.XmlEncElementUrl,
                    EncryptionMethod = new EncryptionMethod(EncryptedXml.XmlEncAES256Url)
                };

                //// Wrap the AES key using the SP's RSA key (RSA-OAEP)
                //EncryptedKey ek = new EncryptedKey
                //{
                //    CipherData = new CipherData(spRsa.Encrypt(aes.Key, RSAEncryptionPadding.OaepSHA1)),
                //    EncryptionMethod = new EncryptionMethod(EncryptedXml.XmlEncRSAOAEPUrl)
                //};

                string idpModulus = Convert.ToBase64String(spRsa.ExportParameters(false).Modulus);
                System.Diagnostics.Debug.WriteLine($"IDP MODULUS: {idpModulus}");

                EncryptedKey ek = new EncryptedKey
                {
                    // Pass 'true' to specify OAEP padding. 
                    // This perfectly aligns the padding with what the SP's EncryptedXml expects.
                    CipherData = new CipherData(EncryptedXml.EncryptKey(aes.Key, spRsa, true)),
                    EncryptionMethod = new EncryptionMethod(EncryptedXml.XmlEncRSAOAEPUrl)
                };

                //// Force explicit OAEP-SHA1 padding  TO TRY
                //byte[] explicitCiphertext = spRsa.Encrypt(aes.Key, RSAEncryptionPadding.OaepSHA1);

                //EncryptedKey ek = new EncryptedKey
                //{
                //    CipherData = new CipherData(explicitCiphertext),
                //    EncryptionMethod = new EncryptionMethod(EncryptedXml.XmlEncRSAOAEPUrl)
                //};

                string test = Convert.ToBase64String(ek.CipherData.CipherValue);

                ed.KeyInfo = new KeyInfo();
                ed.KeyInfo.AddClause(new KeyInfoEncryptedKey(ek));

                EncryptedXml exml = new EncryptedXml();
                ed.CipherData.CipherValue = exml.EncryptData(assertionElement, aes, false);

                // Create <saml:EncryptedAssertion> wrapper element
                XmlElement encryptedAssertionElement = doc.CreateElement(NS.Prefix.Assertion, "EncryptedAssertion", NS.Uri.Assertion);
                XmlElement encryptedDataXml = ed.GetXml();
                encryptedAssertionElement.AppendChild(doc.ImportNode(encryptedDataXml, true));

                // Replace plain Assertion with EncryptedAssertion in DOM
                responseElement.ReplaceChild(encryptedAssertionElement, assertionElement);
            }

            // ---------------------------------------------------------------------
            // 4. SIGN RESPONSE ENVELOPE (If Requested)
            // ---------------------------------------------------------------------
            if (isSignResponse)
            {
                // Must be signed AFTER Assertion encryption so the signature hash covers <saml:EncryptedAssertion>
                SignElement(doc, responseElement, ID, idpRsa, insertAfterElement: responseIssuer);
            }

            return doc.OuterXml;
        }

        private static void SignElement(XmlDocument doc, XmlElement targetElement, string elementId, RSA signingKey, XmlElement insertAfterElement)
        {
            SignedXml signedXml = new SignedXml(doc)
            {
                SigningKey = signingKey
            };
            signedXml.SignedInfo.SignatureMethod = SignedXml.XmlDsigRSASHA256Url;
            signedXml.SignedInfo.CanonicalizationMethod = SignedXml.XmlDsigExcC14NTransformUrl; //http://www.w3.org/2001/10/xml-exc-c14n#

            // Configure reference to target element ID
            Reference reference = new Reference($"#{elementId}");
            reference.AddTransform(new XmlDsigEnvelopedSignatureTransform());
            reference.AddTransform(new XmlDsigExcC14NTransform());
            reference.DigestMethod = SignedXml.XmlDsigSHA256Url;

            signedXml.AddReference(reference);
            signedXml.ComputeSignature();

            XmlElement signatureXml = signedXml.GetXml();

            // SAML 2.0 Schema Requirement: <ds:Signature> MUST immediately follow <saml:Issuer>
            if (insertAfterElement != null && insertAfterElement.ParentNode == targetElement)
            {
                targetElement.InsertAfter(signatureXml, insertAfterElement);
            }
            else
            {
                targetElement.AppendChild(signatureXml);
            }
        }
    }
}
