using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;

namespace swz.SurveyPlus.Saml2
{
    public class SamlAuthenticationResult
    {
        public static SamlAuthenticationResult Success(string nameId, IEnumerable<string> statusCodes)
        {
            if (string.IsNullOrWhiteSpace(nameId)) throw new ArgumentException(nameof(nameId));
            if (statusCodes == null) throw new ArgumentNullException(nameof(statusCodes));
            if (!statusCodes.Any()) throw new ArgumentException("may not be empty", nameof(statusCodes));
            string primary = statusCodes.FirstOrDefault();
            if (SamlResponseXml.StatusCode_Success != primary) throw new ArgumentException($"Primary status code must be {SamlResponseXml.StatusCode_Success} here but was passed {primary}", nameof(statusCodes));

            return new SamlAuthenticationResult(Reason.Success)
            {
                NameID = nameId,
                StatusCodes = statusCodes.ToImmutableList(),
            };
        }

        public static SamlAuthenticationResult Fail(IEnumerable<string> statusCodes)
        {
            if (statusCodes == null) throw new ArgumentNullException(nameof(statusCodes));
            if (!statusCodes.Any()) throw new ArgumentException("may not be empty", nameof(statusCodes));
            return new SamlAuthenticationResult(Reason.Failed)
            {
                StatusCodes = statusCodes.ToImmutableList(),
            };
        }

        public static SamlAuthenticationResult Invalid(string message)
        {
            return new SamlAuthenticationResult(Reason.Invalid)
            {
                Message = message,
            };
        }

        public enum Reason { Success, Failed, Invalid }

        // // // // // // // // // // // // // // // // // // // // // // // //

        public Reason Outcome { get; private set; }

        public string NameID { get; private set; }

        public ImmutableList<string> StatusCodes { get; private set; } = ImmutableList<string>.Empty;

        public string PrimaryStatusCode { get => StatusCodes.Any() ? StatusCodes.FirstOrDefault() : null; }

        public string Message { get; private set; }

        private SamlAuthenticationResult(Reason outcome)
        {
            this.Outcome = outcome;
        }
    }
}
