using System;
using System.IO;
using System.Linq;
using System.Xml;
using System.Xml.Linq;

namespace swz.SurveyPlus.Saml2
{
    public enum SessionBehaviour { Default, ForceAuthn, Passive }

    /// <summary>
    /// Marshalls information needed for the request and provides a method to generate the xml for it.
    /// Currently this is only implemented for using Entra ID as the IdP, for other providers it may
    /// need some additions.
    /// </summary>
    public class AuthnRequest
    {
        public static SessionBehaviour SessionBehaviourFor(bool forceAuthn, bool isPassive)
        {
            if (forceAuthn && isPassive)
                throw new ArgumentException($"{nameof(forceAuthn)} and {nameof(isPassive)} are mutually exclusive");
            else if (!forceAuthn && !isPassive)
                return SessionBehaviour.Default;
            else if (forceAuthn)
                return SessionBehaviour.ForceAuthn;
            else if (isPassive)
                return SessionBehaviour.Passive;
            else
                throw new Exception("Logic error"); //should not be possible to get here
        }

        public static AuthnRequest FromSaml2Options(Saml2Options options)
        {
            string id = "_" + Guid.NewGuid().ToString("N");
            //The format below intended to bypass strict XML/SAML parser limitations (in certain IdP)
            //that might be encountered with "o" or XmlConvert.
            //n.b. Do not use this format to read incoming dates in response from IdP 
            string issueInstant = DateTime.UtcNow.ToString("yyyy-MM-dd'T'HH:mm:ss.fff'Z'"); 
            return new AuthnRequest(
                id: id,
                issueInstant: issueInstant,
                destination: options.Destination, 
                issuer: options.ServiceProviderEntityID, 
                sessionBehaviour: options.SessionBehaviour, 
                assertionConsumerServiceURL: options.AssertionConsumerServiceURL);
        }

        public static AuthnRequest FromXml(string rawxml)
        {
            using (StringReader stringReader = new StringReader(rawxml))
            {
                using (XmlReader xmlReader = XmlReader.Create(
                    stringReader, 
                    new XmlReaderSettings
                    {
                        DtdProcessing = DtdProcessing.Prohibit, //don't need DTD, forbid it to prevent DTD attacks (e.g. billion laughs)
                        XmlResolver = null, //don't allow any external resource loading
                        MaxCharactersInDocument = 32767,
                    }))
                {
                    XNamespace samlp = "urn:oasis:names:tc:SAML:2.0:protocol";
                    XNamespace saml = "urn:oasis:names:tc:SAML:2.0:assertion";

                    XDocument xmlDoc = XDocument.Load(xmlReader);
                    if (xmlDoc.Root == null || xmlDoc.Root.Name != samlp + "AuthnRequest")
                        throw new InvalidOperationException("invalid root element");
                    if (xmlDoc.Descendants(samlp + "AuthnRequest").Count() > 1)
                        throw new InvalidOperationException($"found multiple AuthnRequest elements"); //xml smuggling

                    XElement authnRequest = xmlDoc.Root;
                    string id = authnRequest.Attribute("ID")?.Value;
                    string issueInstant = authnRequest.Attribute("IssueInstant")?.Value;
                    string destination = authnRequest.Attribute("Destination")?.Value;                    
                    string acsUrl = authnRequest.Attribute("AssertionConsumerServiceURL")?.Value;
                    bool forceAuthn = Boolean.TrueString.Equals(authnRequest.Attribute("ForceAuthn")?.Value, StringComparison.OrdinalIgnoreCase);
                    bool isPassive = Boolean.TrueString.Equals(authnRequest.Attribute("IsPassive")?.Value, StringComparison.OrdinalIgnoreCase);
                    string issuer = authnRequest.Element(saml + "Issuer")?.Value;

                    return new AuthnRequest(
                        id: id,
                        issueInstant: issueInstant,
                        destination: destination,
                        issuer: issuer,
                        sessionBehaviour: SessionBehaviourFor(forceAuthn, isPassive),
                        assertionConsumerServiceURL: acsUrl);
                }
            }            
        }

        public string ID { get; private set;  }

        public string IssueInstant { get; private set; }

        public string Destination { get; private set; }

        public bool IsDestinationSpecified { get => !string.IsNullOrWhiteSpace(Destination); }

        public string Issuer { get; private set; }

        public string AssertionConsumerServiceURL { get; private set; }

        public bool IsAssertionConsumerServiceURLSpecified { get => !string.IsNullOrEmpty(AssertionConsumerServiceURL); }

        /// <summary>
        /// Determines whether the ForceAuthn or IsPassive attributes will be added
        /// </summary>
        public SessionBehaviour SessionBehaviour { get; }

        private AuthnRequest(
            string id,
            string issueInstant,
            string destination,
            string issuer,
            SessionBehaviour sessionBehaviour,
            string assertionConsumerServiceURL)
        {
            if (string.IsNullOrEmpty(id)) throw new ArgumentException("must be specified", nameof(id));
            if (string.IsNullOrEmpty(issueInstant)) throw new ArgumentException("must be specified", nameof(issueInstant));
            if (string.IsNullOrEmpty(destination)) throw new ArgumentException("must be specified", nameof(destination));
            if (string.IsNullOrEmpty(issuer)) throw new ArgumentException("must be specified", nameof(issuer));
            this.ID = id;
            this.IssueInstant = issueInstant;
            this.Destination = destination;
            this.Issuer = issuer;
            this.SessionBehaviour = sessionBehaviour;
            this.AssertionConsumerServiceURL = assertionConsumerServiceURL;
        }

        public override string ToString()
        {
            return $"{nameof(AuthnRequest)}[{nameof(ID)}={ID}, {nameof(IssueInstant)}={IssueInstant}, {nameof(Destination)}={Destination}, {nameof(Issuer)}={Issuer}, {nameof(AssertionConsumerServiceURL)}={AssertionConsumerServiceURL}, {nameof(SessionBehaviour)}={SessionBehaviour}]";
        }

        /// <summary>
        /// Generate the XML to be sent to IdP for the request this object represents
        /// </summary>
        /// <returns>AuthnRequest document</returns>
        public XDocument ToXml()
        {
            XNamespace samlp = "urn:oasis:names:tc:SAML:2.0:protocol";
            XNamespace saml = "urn:oasis:names:tc:SAML:2.0:assertion";
            XElement authnRequest = new XElement(samlp + "AuthnRequest",
                new XAttribute(XNamespace.Xmlns + "samlp", samlp.NamespaceName),
                new XAttribute(XNamespace.Xmlns + "saml", saml.NamespaceName),
                new XAttribute("ID", ID),
                new XAttribute("Version", "2.0"),
                new XAttribute("IssueInstant", IssueInstant),
                new XAttribute("Destination", Destination), //Entra ignores, spec requires when signing, best always include
                new XElement(saml + "Issuer", Issuer)
            );
            switch (SessionBehaviour)
            {
                case SessionBehaviour.ForceAuthn:
                    authnRequest.Add(new XAttribute("ForceAuthn", "true"));
                    break;

                case SessionBehaviour.Passive:
                    authnRequest.Add(new XAttribute("IsPassive", "true"));
                    break;
            }
            if(IsAssertionConsumerServiceURLSpecified)
            {
                authnRequest.Add(new XAttribute("AssertionConsumerServiceURL", AssertionConsumerServiceURL));
            }
            return new XDocument(authnRequest);
        }
    }
}
