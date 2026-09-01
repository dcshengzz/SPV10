using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.Clover.AuthServices.Jwt.Components.Entity
{
    /// <summary>
    /// Helper class to retrieve and wrap JWT issuing settings used in JwtController.
    /// </summary>
    public class TokenIssueSettings
    {
        public const string SETTING_INTRANET_DOMAIN_AUTHORITY = "IntranetDomainAuthority";
        public const string SETTING_INTERNET_DOMAIN_AUTHORITY = "InternetDomainAuthority";
        public const string SETTING_RESP_JWT_SESSION_TOKEN_EXPIRY = "RespJwtSessionTokenExpiry";
        public const string SETTING_RESP_JWT_RENEWAL_TOKEN_EXPIRY = "RespJwtRenewalTokenExpiry";
        public const string SETTING_3PA_JWT_SESSION_TOKEN_EXPIRY = "3PAJwtSessionTokenExpiry";
        public const string SETTING_3PA_JWT_RENEWAL_TOKEN_EXPIRY = "3PAJwtRenewalTokenExpiry";

        private const string FALLBACK_ISSUER_INTERNET = "SWZ.SurveyPlus.Internet"; //if authority isn't set (unlikely)
        private const string FALLBACK_EXPIRY_INTERNET = "255"; //if the expiry value isn't set (unlikely)

        private const string FALLBACK_ISSUER_INTRANET = "SWZ.SurveyPlus.Intranet"; //if authority isn't set (unlikely)       
        private const string FALLBACK_EXPIRY_INTRANET = "255"; //if the expiry value isn't set (unlikely)

        private static readonly List<string> settingNames = new List<string> {
            SETTING_INTRANET_DOMAIN_AUTHORITY,
            SETTING_INTERNET_DOMAIN_AUTHORITY,
            SETTING_RESP_JWT_SESSION_TOKEN_EXPIRY,
            SETTING_RESP_JWT_RENEWAL_TOKEN_EXPIRY,
            SETTING_3PA_JWT_SESSION_TOKEN_EXPIRY,
            SETTING_3PA_JWT_RENEWAL_TOKEN_EXPIRY };

        private static string Issuer(string domainAuthority, string fallback)
        {
            if (string.IsNullOrWhiteSpace(domainAuthority))
                return fallback;
            else if (domainAuthority.StartsWith("https://", StringComparison.OrdinalIgnoreCase))
                return domainAuthority;
            else
                return $"https://{domainAuthority}";
        }

        public static async Task<TokenIssueSettings> GetFromAppSettings()
        {
            Dictionary<string, string> settings
                = (await AppSettings.SelectAsync(Filter.And.In(settingNames, AppSettings.ATTRIBUTE_NAME)))
               .ToDictionary(s => s.Name, s => s.Value);
            return GetFromDictionary(settings);
        }

        /// <summary>
        /// Read the values from the supplied dictionary. Will fallback to 'reasonable' defaults for any missing values.
        /// Note that unparseable numerical values will cause an ArgumentException will be raised.
        /// </summary>
        public static TokenIssueSettings GetFromDictionary(Dictionary<string, string> settings)
        {
            if (settings == null) throw new ArgumentNullException(nameof(settings));
            try
            {
                return new TokenIssueSettings(
                internetIssuer:
                    Issuer(settings.GetValueOrDefault(SETTING_INTERNET_DOMAIN_AUTHORITY), FALLBACK_ISSUER_INTERNET),
                respTokenExpiryMinutes:
                    double.Parse(settings.GetValueOrDefault(SETTING_RESP_JWT_SESSION_TOKEN_EXPIRY, FALLBACK_EXPIRY_INTERNET)),
                respTokenRenewalMinutes:
                    double.Parse(settings.GetValueOrDefault(SETTING_RESP_JWT_RENEWAL_TOKEN_EXPIRY, FALLBACK_EXPIRY_INTERNET)),
                intranetIssuer:
                    Issuer(settings.GetValueOrDefault(SETTING_INTRANET_DOMAIN_AUTHORITY), FALLBACK_ISSUER_INTRANET),
                thirdPartyApiTokenExpiryMinutes:
                    double.Parse(settings.GetValueOrDefault(SETTING_3PA_JWT_SESSION_TOKEN_EXPIRY, FALLBACK_EXPIRY_INTRANET)),
                thirdPartyApiTokenRenewalMinutes:
                    double.Parse(settings.GetValueOrDefault(SETTING_3PA_JWT_RENEWAL_TOKEN_EXPIRY, FALLBACK_EXPIRY_INTRANET)));
            }
            catch(Exception e)
            {
                throw new ArgumentException("Failed to parse values in the dictionary", nameof(settings), e);
            }
            
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// Value to use for the issuer claim in tokens issued for internet respondent u@app api use
        /// </summary>
        public readonly string RespTokenIssuer;

        /// <summary>
        /// Validity duration of the jwt issued for internet respondent u@app api use
        /// </summary>
        public readonly double RespTokenExpiryMinutes;

        /// <summary>
        /// Validity duration of the renewal token issued for internet respondent u@app api use
        /// (measured from the issue time of the related jwt)
        /// </summary>
        public readonly double RespTokenRenewalMinutes;

        /// <summary>
        /// Value to use for the issuer claim in tokens issued for intranet 3pa api use
        /// </summary>
        public readonly string ThirdPartyApiTokenIssuer;

        /// <summary>
        /// Validity duration of the jwt issued for intranet 3pa api use
        /// </summary>
        public readonly double ThirdPartyApiTokenExpiryMinutes;

        /// <summary>
        /// Validity duration of the renewal token issued for intranet 3pa api use
        /// (measured from the issue time of the related jwt)
        /// </summary>
        public readonly double ThirdPartyApiTokenRenewalMinutes;

        public TokenIssueSettings(
            string internetIssuer,
            double respTokenExpiryMinutes,
            double respTokenRenewalMinutes,
            string intranetIssuer,
            double thirdPartyApiTokenExpiryMinutes,
            double thirdPartyApiTokenRenewalMinutes)
        {
            ThirdPartyApiTokenIssuer = intranetIssuer ?? throw new ArgumentNullException(nameof(intranetIssuer));
            RespTokenIssuer = internetIssuer ?? throw new ArgumentNullException(nameof(internetIssuer));
            RespTokenExpiryMinutes = respTokenExpiryMinutes;
            RespTokenRenewalMinutes = respTokenRenewalMinutes;
            ThirdPartyApiTokenExpiryMinutes = thirdPartyApiTokenExpiryMinutes;
            ThirdPartyApiTokenRenewalMinutes = thirdPartyApiTokenRenewalMinutes;
        }
    }
}
