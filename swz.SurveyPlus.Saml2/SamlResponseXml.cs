using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Security.Cryptography.Xml;
using System.Xml;
using System.Xml.Schema;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using swz.Clover.Core;
using swz.KeyUtils;
namespace swz.SurveyPlus.Saml2
{
    /// <summary>
    /// Handles the low level details of interacting with the XML and XML APIs so the
    /// higher level logic (in ProcessResponse) doesn't have to concern itself with that
    /// </summary>
    public class SamlResponseXml
    {
        public abstract class SamlResponseXmlException : Exception
        {
           public SamlResponseXmlException(string message) : base(message) { }
        }

        public class InvalidResponseXmlException : SamlResponseXmlException
        {
            public InvalidResponseXmlException(string message) : base(message) { }
        }

        public class AssertionNotDecryptedException : SamlResponseXmlException
        {
            public AssertionNotDecryptedException() : base("The Assertion has not been decrypted yet") { }
        }

        /// <summary>
        /// Subclass of SignedXml that can find elements based on an 'ID' attribute (strict
        /// casing).
        /// This class is necessary because we aren't using DTDs so the base SignedXml
        /// doesn't know that Saml's 'ID' is an XML id attribute.
        /// </summary>
        public class SamlIDAwareSignedXml : SignedXml
        {
            public SamlIDAwareSignedXml(XmlDocument document) : base(document) { }

            public override XmlElement GetIdElement(XmlDocument document, string idValue)
            {
                // 1. Find ALL elements matching the ID (should only be one if xml is correct)
                // Note that we require uppercase ID attribute name and don't accept improper
                // casing.
                XmlNodeList elements = document.SelectNodes($"//*[@ID='{idValue}']");

                // Sanity check: If there is more than one, it's probably an XSW attack
                // (ID values must be unique)
                if (elements != null && elements.Count > 1)
                    throw new SamlResponseXml.InvalidResponseXmlException($"Discovered {elements.Count} elements with ID {idValue}");

                // 4. Return the single unique element, or fallback to base
                if (elements != null && elements.Count == 1)
                {
                    return (XmlElement)elements[0];
                }
                else
                {
                    //Two scenarios where the XPath fails, and the base .impl works:
                    //1. Internal W3C XML Signature References
                    //2. Dynamically Registered IDs
                    return base.GetIdElement(document, idValue);
                }
            }
        }

        public const string Protocol_Namespace = "urn:oasis:names:tc:SAML:2.0:protocol";
        public const string Assertion_Namespace = "urn:oasis:names:tc:SAML:2.0:assertion";
        public const string Signature_Namespace = "http://www.w3.org/2000/09/xmldsig#";
        public const string Encryption_Namespace = "http://www.w3.org/2001/04/xmlenc#";
        public const string StatusCode_Success = "urn:oasis:names:tc:SAML:2.0:status:Success";

        // // // // // // // // // // // // // // // // // // // // // // // //

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(SamlResponseXml));

        private static readonly XmlReaderSettings XmlReaderSettings = new XmlReaderSettings
        {
            DtdProcessing = DtdProcessing.Prohibit, //SAML 2.0 doesn't use DTD, block to stop XXE
            XmlResolver = null, //Prevent parser from doing lookups over network / file system
            MaxCharactersFromEntities = 1024, //Limit entity expansion to guard against "billion laughs"
            MaxCharactersInDocument = 131072, //128kib size limit (Entra unlikely to exceed 50kb)
        };

        public string ResponseID { get; private set; }

        public string AssertionID
        {
            get
            {
                if (IsAssertionEncrypted) throw new AssertionNotDecryptedException();
                return assertion.GetAttribute("ID");
            }
        }

        public string Destination { get; private set; }

        public string ResponseIssuer { get; private set; }

        public bool IsResponseIssuerSpecified { get => !string.IsNullOrWhiteSpace(ResponseIssuer); }

        public string AssertionIssuer { get; private set; }

        public bool IsAssertionIssuerSpecified { get => !string.IsNullOrWhiteSpace(AssertionIssuer); }

        public bool IsResponseSignaturePresent { get => responseSignature != null; }

        public bool IsAssertionSignaturePresent { 
            get {
                if (IsAssertionEncrypted) throw new AssertionNotDecryptedException();
                return assertionSignature != null; 
            } }

        public bool IsAssertionEncrypted { get => assertion != null && "EncryptedAssertion" == assertion.LocalName; }

        /// <summary>
        /// Ordered list of status codes in the response. 
        /// SAML spec dictates that these are case sensitive.
        /// </summary>
        public ImmutableList<string> StatusCodes { get; private set; }

        public string PrimaryStatusCode { get => StatusCodes.Any() ? StatusCodes[0] : null; }

        public bool IsSuccessStatus { get => StatusCode_Success == PrimaryStatusCode; }

        public bool IsAssertionPresent { get => assertion != null; }

        public string AssertionXML { get => IsAssertionPresent ? assertion.InnerXml : null; }

        public DateTime? ConditionsNotOnOrAfter
        {
            get => IsAssertionEncrypted
                ? throw new AssertionNotDecryptedException()
                : GetDateFrom(conditions, "NotOnOrAfter");
        }

        public bool IsConditionsNotOnOrAfterSpecified { get => ConditionsNotOnOrAfter != null; }

        public DateTime? ConditionsNotBefore
        {
            get => IsAssertionEncrypted
                ? throw new AssertionNotDecryptedException()
                : GetDateFrom(conditions, "NotBefore"); 
        }

        public bool IsConditionsNotBeforeSpecified { get => ConditionsNotBefore != null; }

        public HashSet<string> Audience { get; private set; }

        public DateTime? BearerNotOnOrAfter
        {
            get => IsAssertionEncrypted
                ? throw new AssertionNotDecryptedException()
                : GetDateFrom(bearerSubjectConfirmationData, "NotOnOrAfter");
        }

        public string BearerRecipient
        {
            get => IsAssertionEncrypted
                ? throw new AssertionNotDecryptedException()
                : bearerSubjectConfirmationData.GetAttribute("Recipient");
        }

        public string BearerInResponseTo
        {
            get => IsAssertionEncrypted
                ? throw new AssertionNotDecryptedException()
                : bearerSubjectConfirmationData.GetAttribute("InResponseTo");
        }

        public string ResponseInResponseTo
        {
            get => response.GetAttribute("InResponseTo");
        }

        public bool IsBearerInResponseToSpecified { get => !string.IsNullOrWhiteSpace(BearerInResponseTo); }

        public string NameID { get; private set; }

        private readonly XmlDocument doc;
        private readonly XmlNamespaceManager ns;
        private readonly XmlElement response;
        private readonly XmlElement responseSignature;

        //below are not readonly because they are updated when we decrypt
        private XmlElement assertion; 
        private XmlElement assertionSignature;
        private XmlElement conditions;
        private XmlElement subject;
        private XmlElement bearerSubjectConfirmationData;
        

        public SamlResponseXml(string rawxml, ISamlSchemaProvider schemaProvider)
        {
            if(string.IsNullOrWhiteSpace(rawxml)) 
                throw new ArgumentException("required", nameof(rawxml));
            if (schemaProvider == null)
                throw new ArgumentNullException(nameof(schemaProvider));

            XmlSchemaSet schemas = schemaProvider.GetSchemas();
            if (schemas == null)
                throw new NullReferenceException("schema provider returned null");
            doc = ParseDocument(rawxml, schemas);
            ValidateDocumentAgainstSchema();

            ns = new XmlNamespaceManager(doc.NameTable);
            ns.AddNamespace("samlp", Protocol_Namespace);
            ns.AddNamespace("saml", Assertion_Namespace);
            ns.AddNamespace("ds", Signature_Namespace);
            ns.AddNamespace("xenc", Encryption_Namespace);

            response = doc.DocumentElement;
            if (response == null)
                throw new InvalidResponseXmlException("There is no root node");

            if (response.LocalName != "Response" || response.NamespaceURI != Protocol_Namespace)
                throw new InvalidResponseXmlException("This is not a samlp:Response document");

            string version = response.Attributes["Version"]?.Value;
            if (!"2.0".Equals(version, StringComparison.Ordinal))
                throw new InvalidResponseXmlException("The document's SAML Version is not 2.0");

            ResponseID = response.Attributes["ID"]?.Value;
            if (ResponseID == null)
                throw new InvalidResponseXmlException("The Response has no ID");

            Destination = response.Attributes["Destination"]?.Value;
            if (Destination == null)
                throw new InvalidResponseXmlException("The Response has no Destination");

            ResponseIssuer = ReadResponseIssuer();
            StatusCodes = ReadStatusCodeValues().ToImmutableList();
            responseSignature = FindResponseSignature();
            assertion = FindAssertion();
            if(!IsAssertionEncrypted)
                ContinueAssertionRelatedConstructorLogic();
        }

        //n.b. please keep this particular private method right below the constructor
        /// <summary>
        /// Continued constructor logic once the assertion has been decrypted.
        /// This will either be called directly from the constructor if the Assertion is not
        /// encrypted or the call to here will be deferred until after the decryption is done.
        /// </summary>
        private void ContinueAssertionRelatedConstructorLogic()
        {
            if (IsAssertionEncrypted)
                throw new AssertionNotDecryptedException();
            AssertionIssuer = ReadAssertionIssuer();
            assertionSignature = FindAssertionSignature();
            conditions = FindConditions();
            Audience = ReadAudience();
            subject = FindSubject();
            bearerSubjectConfirmationData = FindSubjectConfirmationData();
            NameID = ReadNameID();
        }

        /// <summary>
        /// Perform assertion decryption, replacing the EncryptedAssertion with the decrypted Assertion
        /// </summary>
        /// <param name="spEncryptionPrivateKeys">decryption keys</param>
        public void DecryptAssertion(IEnumerable<RsaSecurityKey> spEncryptionPrivateKeys)
        {
            if (!IsAssertionEncrypted)
                throw new InvalidOperationException("Assertion is already decrypted");

            if (spEncryptionPrivateKeys == null)
                throw new ArgumentNullException(nameof(spEncryptionPrivateKeys));

            XmlElement encryptedDataNode = (XmlElement)assertion.SelectSingleNode("./xenc:EncryptedData", ns);
            if (encryptedDataNode == null)
                throw new InvalidResponseXmlException("EncryptedAssertion lacks EncryptedData");
            SamlEncryptedXml exml = new SamlEncryptedXml(doc, spEncryptionPrivateKeys);
            EncryptedData ed = new EncryptedData();
            ed.LoadXml(encryptedDataNode);

            // Extract the AES algorithm and decrypt the bytes
            // Calls custom DecryptEncryptedKey logic
            try
            {
                using (SymmetricAlgorithm symAlg = exml.GetDecryptionKey(ed, null))
                {
                    if (symAlg == null)
                        throw new CryptographicException("Unable to resolve the symmetric decryption key.");
                    byte[] decryptedBytes = exml.DecryptData(ed, symAlg);
                    //Replace the EncryptedData element in the DOM with the plaintext Assertion
                    exml.ReplaceData(encryptedDataNode, decryptedBytes);
                }
            }
            catch(SamlEncryptedXml.UnableToDecryptKeyException fail)
            {
                throw new InvalidResponseXmlException(fail.Message);
            }

            //Replace the EncryptedAssertion with the Assertion
            XmlElement decryptedAssertionNode = (XmlElement)assertion.SelectSingleNode("./saml:Assertion", ns);
            if (decryptedAssertionNode == null)
                throw new InvalidResponseXmlException("Encrypted payload does not contain an Assertion");
            assertion.ParentNode.ReplaceChild(decryptedAssertionNode, assertion);

            //Need to validate again because who knows what was lurking in the encrypted section...
            ValidateDocumentAgainstSchema();

            //Update the assertion related references
            assertion = FindAssertion(); //method will re-verify theres still only 1 assertion node
            ContinueAssertionRelatedConstructorLogic();
        }

        public bool IsResponseSignedWith(IEnumerable<RsaSecurityKey> keys)
        {
            return IsResponseSignaturePresent
                && IsSignedWith(response, responseSignature, keys);
        }

        public bool IsAssertionSignedWith(IEnumerable<RsaSecurityKey> keys)
        {
            if (IsAssertionEncrypted)
                throw new AssertionNotDecryptedException();
            return IsAssertionSignaturePresent
                && IsSignedWith(assertion, assertionSignature, keys);
        }

        private bool IsSignedWith(XmlElement target, XmlElement signature, IEnumerable<RsaSecurityKey> keys)
        {
            if (target == null) throw new ArgumentNullException(nameof(target));
            if (signature == null) throw new ArgumentNullException(nameof(signature));
            if (keys == null) throw new ArgumentNullException(nameof(keys));
            SignedXml signedXml = new SamlIDAwareSignedXml(doc);
            signedXml.LoadXml(signature);

            //Before we check the signature is valid we must check that its actually signing the element
            //we are checking it for right now (i.e. the Response or the Assertion)
            string targetId = target.GetAttribute("ID");
            if (string.IsNullOrWhiteSpace(targetId))
                throw new InvalidResponseXmlException($"No ID attribute specified for {target.Name}");
            string expectedUri = $"#{targetId}";

            //In SAML 2.0 spec, the signature for a <Response> or <Assertion> MUST contain exactly one
            //<Reference> element, and it MUST point to the ID of the element being signed.
            if (signedXml.SignedInfo.References.Count != 1)
                throw new InvalidResponseXmlException($"Signature for {target.Name} contains {signedXml.SignedInfo.References.Count} references but SAML 2.0 requires exactly 1 here");
            //And that single Reference must of course point at our target element
            Reference reference = (Reference)signedXml.SignedInfo.References[0];
            if (reference.Uri != expectedUri)
                throw new InvalidResponseXmlException($"Signature for {target.Name} Reference URI is '{reference.Uri}' which does not match expected the target's element ID '{expectedUri}'.");

            //Now we can check that signature is actually valid
            foreach (RsaSecurityKey key in keys)
            {
                using RsaDisposalTracker t = RsaDisposalTracker.FromKey(key);

                if (logger.IsEnabled(LogLevel.Trace))
                    logger.LogTrace(nameof(IsSignedWith) + " - checking signature of {0} with KeyId={1}, keySize={2}, IsOurResponsibilityToDispose={3}", target.Name, key.KeyId, key.KeySize, t.IsOurResponsibilityToDispose);

                bool success = signedXml.CheckSignature(t.Rsa);

                if (success) 
                {   //Win!
                    if (logger.IsEnabled(LogLevel.Debug))
                        logger.LogTrace(nameof(IsSignedWith) + " - signature of {0} successfully verified with KeyId={1}, keySize={2}", target.Name, key.KeyId, key.KeySize);
                    return true;                                
                }
            }

            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(IsSignedWith) + " - no keys matched signature of {0}, tried {1} keys", target.Name, keys.Count());
            return false; //Fail! - none of the available keys work so we consider signature invalid
        }

        /// <summary>
        /// Locate the response-level Signature node and make sure its in the correct place
        /// and covers the response, and that its the only signature node at that level.
        /// </summary>
        /// <returns>signature element or null if the response isn't signed</returns>
        private XmlElement FindResponseSignature()
        {
            //Find the signature and ensure it is the only one at the root level
            XmlNodeList responseSignatures = doc.SelectNodes("/samlp:Response/ds:Signature", ns);

            if (responseSignatures.Count > 1)
            {
                throw new InvalidOperationException("Multiple Response-level signatures found. Potential XSW attack.");
            }

            XmlElement signatureNode = responseSignatures.Count == 1 ? (XmlElement)responseSignatures[0] : null;

            if (signatureNode != null)
            {
                // b: Verify strict SAML 2.0 schema ordering
                // Schema dictates: Issuer (0..1) -> Signature (0..1) -> Extensions (0..1) -> Status (1)
                List<XmlElement> childElements 
                    = doc.DocumentElement.ChildNodes
                    .OfType<XmlElement>()
                    .ToList();
                int sigIndex = childElements.IndexOf(signatureNode);

                for (int i = 0; i < sigIndex; i++)
                {
                    // If anything other than 'Issuer' comes before the signature, it's malformed
                    if (childElements[i].LocalName != "Issuer")
                    {
                        throw new InvalidResponseXmlException($"Invalid schema: '{childElements[i].LocalName}' appeared before Signature.");
                    }
                }

                // Verify the signature actually covers the Response
                // (Reference must be "#" + the ID of the signed element)
                XmlElement referenceNode = (XmlElement)signatureNode.SelectSingleNode("ds:SignedInfo/ds:Reference", ns);
                string responseId = doc.DocumentElement.GetAttribute("ID");
                string referenceUri = referenceNode?.GetAttribute("URI");
                if (string.IsNullOrEmpty(responseId) || referenceUri != $"#{responseId}")
                {
                    throw new InvalidResponseXmlException($"Signature target URI '{referenceUri}' does not match Response ID '#{responseId}' (wrong data is covered)");
                }
                return signatureNode;
            } 
            else
            {
                return null; //Response is not signed
            }
        }

        private XmlElement FindAssertion()
        {
            XmlNodeList assertionNodes = doc.SelectNodes("//saml:Assertion | //saml:EncryptedAssertion", ns);
            if (assertionNodes.Count == 0)
            {
                return null; //Not found (e.g. this could be the case if not a success response)
            }
            else if (assertionNodes.Count > 1)
            {
                throw new InvalidResponseXmlException($"Found {assertionNodes.Count} Assertion or EncryptedAssertion nodes, but there should only be 1");
            }
            else
            {
                XmlElement assertionNode = (XmlElement)assertionNodes[0];
                if (assertionNode.ParentNode != response)
                    throw new InvalidResponseXmlException("The assertion node is not a child of the Response");
                bool isDecrypted = ("Assertion" == assertionNode.LocalName);
                if(isDecrypted)
                {
                    if ("2.0" != assertionNode.Attributes["Version"]?.Value)
                        throw new InvalidResponseXmlException("The Assertion Version is not 2.0");
                }
                return assertionNode;
            }
        }

        private XmlElement FindAssertionSignature()
        {
            if (IsAssertionEncrypted)
                throw new AssertionNotDecryptedException();

            // Find all signatures nested anywhere inside the Assertion
            XmlNodeList signatures = assertion.SelectNodes(".//ds:Signature", ns);

            if (signatures == null || signatures.Count == 0)
                return null; //Assertion is unsigned

            // There should be only one signature in a signed assertion
            if (signatures.Count > 1)
            {
                throw new InvalidResponseXmlException($"Expected at most 1 Signature in Assertion, but found {signatures.Count}");
            }

            XmlElement signatureElement = (XmlElement)signatures[0];

            // The Signature must be a direct child of the Assertion
            if (signatureElement.ParentNode != assertion)
            {
                throw new InvalidResponseXmlException("The Assertion Signature is not a direct child of the Assertion");
            }

            // Cryptographic Binding: Does this signature actually cover this specific assertion?
            // (Signature's Reference URI must point to exact ID of the Assertion with a '#' prefix)
            string assertionId = assertion.GetAttribute("ID");
            if (string.IsNullOrEmpty(assertionId))
            {
                throw new InvalidResponseXmlException("The Assertion is missing the mandatory 'ID' attribute.");
            }
            XmlElement referenceElement = (XmlElement)signatureElement.SelectSingleNode("ds:SignedInfo/ds:Reference", ns);
            if (referenceElement == null)
            {
                throw new InvalidResponseXmlException("The Assertion Signature missing ds:SignedInfo/ds:Reference.");
            }
            string referenceUri = referenceElement.GetAttribute("URI");
            if (referenceUri != $"#{assertionId}")
            {
                throw new InvalidResponseXmlException($"Signature Reference URI '{referenceUri}' does not match the Assertion ID '#{assertionId}' (signature is covering the wrong data)");
            }

            return signatureElement;
        }

        private List<string> ReadStatusCodeValues()
        {
            XmlNodeList statusNodes = doc.SelectNodes("//samlp:Status", ns);
            if (statusNodes.Count != 1)
                throw new InvalidResponseXmlException($"There should be exactly 1 Status element in the document, but found {statusNodes.Count}");

            XmlElement status = (XmlElement)statusNodes[0];
            if (status.SelectSingleNode("parent::samlp:Response", ns) == null)
                throw new InvalidResponseXmlException("The Status block is incorrectly placed in the document");

            XmlElement primaryStatusCode = (XmlElement)status.SelectSingleNode("samlp:StatusCode", ns);
            if (primaryStatusCode == null)
                throw new InvalidResponseXmlException("Status element lacks StatusCode child");

            List<string> statusCodes = new List<string>();
            XmlElement current = primaryStatusCode;
            while (current != null)
            {
                string value = current.GetAttribute("Value");
                if (!string.IsNullOrEmpty(value))
                    statusCodes.Add(value);
                current = current.ChildNodes.OfType<XmlElement>().FirstOrDefault(e => e.LocalName == "StatusCode");
            }
            return statusCodes;
        }

        private XmlElement FindConditions()
        {
            if (IsAssertionEncrypted)
                throw new AssertionNotDecryptedException();
            return (XmlElement)assertion.SelectSingleNode("saml:Conditions", ns)
                ?? throw new InvalidResponseXmlException("Did not find Conditions node in the Assertion");
        }

        private HashSet<string> ReadAudience()
        {
            if (IsAssertionEncrypted)
                throw new AssertionNotDecryptedException();
            XmlNodeList nodes = conditions.SelectNodes("saml:AudienceRestriction/saml:Audience", ns);
            if (nodes.Count == 0) //WEB SSO Profile requires some Audience even though schema doesn't
                throw new InvalidResponseXmlException("Did not find any Audience nodes in the Conditions");
            return nodes
                .Cast<XmlNode>()
                .Select(audience => audience.InnerText.Trim())
                .ToHashSet(StringComparer.Ordinal);
        }

        private DateTime? GetDateFrom(XmlElement element, string attributeName)
        {
            string value = element?.GetAttribute(attributeName);
            return string.IsNullOrEmpty(value)
                ? null
                : XmlConvert.ToDateTime(value, XmlDateTimeSerializationMode.Utc);
        }

        private string ReadResponseIssuer()
        {
            XmlElement issuer = (XmlElement)response.SelectSingleNode("saml:Issuer", ns);
            return issuer?.InnerText;
        }

        private string ReadAssertionIssuer()
        {
            if (IsAssertionEncrypted)
                throw new AssertionNotDecryptedException();
            XmlElement issuer = (XmlElement)assertion.SelectSingleNode("saml:Issuer", ns);
            return issuer?.InnerText;
        }

        private XmlElement FindSubject()
        {
            if (IsAssertionEncrypted)
                throw new AssertionNotDecryptedException();
            XmlElement subject = (XmlElement)assertion.SelectSingleNode("saml:Subject", ns);
            if (subject == null) //schema allows 0 or 1, SSO requires 1
                throw new InvalidResponseXmlException("The Assertion has no Subject");

            return subject;
        }

        private XmlElement FindSubjectConfirmationData()
        {
            if (IsAssertionEncrypted)
                throw new AssertionNotDecryptedException();
            XmlNodeList bearerConfirmations = subject.SelectNodes("saml:SubjectConfirmation[@Method='urn:oasis:names:tc:SAML:2.0:cm:bearer']", ns);
            if (bearerConfirmations.Count == 0)
                throw new InvalidResponseXmlException($"The Subject has no bearer confirmations");
            //Major IdPs like Entra ID and Okta will only send one SubjectConfirmation for standard web logins so we don't support multiple for now
            if (bearerConfirmations.Count > 1) 
                throw new InvalidResponseXmlException($"The Subject has multiple bearer confirmations (not supported)");
            XmlElement scd = (XmlElement)bearerConfirmations[0].SelectSingleNode("saml:SubjectConfirmationData", ns);
            if(scd == null) //can be 0 or 1 per schema, and for SSO requires 1
                throw new InvalidResponseXmlException($"The bearer SubjectConfirmation lacks a SubjectConfirmationData");

            //For SSO profile the SubjectConfirmationData element MUST NOT contain a NotBefore attribute
            if (scd.HasAttribute("NotBefore"))
                throw new InvalidResponseXmlException($"SubjectConfirmationData may not have a NotBefore attribute");

            //SSO requires NotOnOrAfter
            if (string.IsNullOrWhiteSpace(scd.GetAttribute("NotOnOrAfter")))
                throw new InvalidResponseXmlException($"SubjectConfirmationData is missing NotOnOrAfter");

            //SSO requires Recipient
            if (string.IsNullOrWhiteSpace(scd.GetAttribute("Recipient")))
                throw new InvalidResponseXmlException($"SubjectConfirmationData is missing Recipient");

            return scd;
        }

        private string ReadNameID()
        {
            XmlNodeList nameIDs = subject.SelectNodes("saml:NameID", ns);
            //it should contain 1 NameID for SSO (schema effectively allows 0 or 1)
            //and Entra won't use saml:EncryptedID here
            if (nameIDs.Count != 1)
                throw new InvalidResponseXmlException($"The Subject has {nameIDs.Count} NameID elements, expected 1");
            return nameIDs[0].InnerText;
        }

        private XmlDocument ParseDocument(string xml, XmlSchemaSet schemas)
        {
            if (string.IsNullOrWhiteSpace(xml))
                throw new ArgumentException("required", nameof(xml));
            if (schemas == null)
                throw new ArgumentNullException(nameof(schemas));
            XmlDocument doc = new XmlDocument
            {
                PreserveWhitespace = true, //necessary for reproducible signing
                XmlResolver = null, //must block external resolution here too
                Schemas = schemas, //Attach schemas here, but we validate elsewhere
            };
            using StringReader stringReader = new StringReader(xml);
            using XmlReader xmlReader = XmlReader.Create(stringReader, XmlReaderSettings);
            doc.Load(xmlReader);
            return doc;
        }

        private void ValidateDocumentAgainstSchema()
        {
            doc.Validate((sender, args) =>
            {
                if (args.Severity == XmlSeverityType.Error)
                {
                    // Throw immediately on the first structural violation
                    throw new InvalidResponseXmlException($"Schema validation failed, message={args.Message}");
                }
            });
        }

    }
}
