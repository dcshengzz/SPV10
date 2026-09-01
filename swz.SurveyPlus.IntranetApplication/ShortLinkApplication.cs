using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.Security;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Enumeration of the possible QNN_SHORT_LINK.LinkType values
    /// </summary>
    public enum ShortLinkType { Anonymous, Url }

    /// <summary>
    /// Object to hold the Url and its QR Code for a ShortLink
    /// </summary>
    public class ShortLinkUrlAndQrCode
    {
        public byte[] QrCode { get; private set; }

        public Uri Url { get; private set; }

        [JsonConstructor]
        public ShortLinkUrlAndQrCode(Uri url, byte[] qrCode)
        {
            if (url == null) throw new ArgumentNullException(nameof(url));
            if (qrCode == null) throw new ArgumentNullException(nameof(qrCode));
            this.Url = url;
            this.QrCode = qrCode;
        }
    }

    public class ShortLinkApplication
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(ShortLinkApplication));

        /// <summary>
        /// Exception type used to wrap any unexpected exception that occurs suring ProcessShortLink
        /// </summary>
        public class ShortLinkProcessingException : Exception
        {
            public ShortLinkProcessingException(Exception innerException) : base("Unexpected error processing ShortLink", innerException) { }
        }

        /// <summary>
        /// Logic to process a request to use a Short Link
        /// A Short Link url (as currently implemented) looks something like: https://example.surveyplus.net/go/56c/d6hf44x
        /// Here "56c" is the shortLinkCode, essentially an encoded (and sometimes mildly obfuscated) representation of ShortLink NumberId
        /// "d6hf44x" is an AccessCode stored in the QNN_SHORT_LINK which has to match. Use of the AccessCode 
        /// depends on whether "Enhanced Security" option is on for the link. It prevents the short links being enumerated. 
        /// 
        /// </summary>
        /// <param name="shortLinkCode">the part of the URL specifying the Short Link</param>
        /// <param name="accessCodeString">the part of the URL specifiying the AccessCode (when applicable)</param>
        /// <returns>a result indicatinng what response to provide</returns>
        public static async Task<ShortLinkResult> ProcessShortLink(string shortLinkCode, string accessCodeString)
        {
            if (string.IsNullOrEmpty(shortLinkCode)) throw new ArgumentException(nameof(shortLinkCode), "Required");
            bool accessCodeProvided = !string.IsNullOrEmpty(accessCodeString);

            try
            {
                EntityModel qnnShortLinkModel 
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SHORT_LINK, Constants.Level.NoJoins);

                long numberId = AccessCode.DecodeStringAsLong(shortLinkCode);
                if(numberId < 0 || numberId > Int32.MaxValue)
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug("{0} - NumberId out of bounds, NumberId={1}", nameof(ProcessShortLink), numberId);
                    }
                    return ShortLinkResult.Fail(ShortLinkResult.Outcome.InvalidShortLink);
                }

                AccessCode accessCode = null;
                if(accessCodeProvided)
                {
                    if (!AccessCode.IsValidFormat(accessCodeString))
                    {
                        if (logger.IsEnabled(LogLevel.Debug))
                        {
                            logger.LogDebug("{0} - Invalid AccessCode format", nameof(ProcessShortLink));
                        }
                        return ShortLinkResult.Fail(ShortLinkResult.Outcome.InvalidAccessCode);
                    }
                    accessCode = new AccessCode(accessCodeString);

                    //When an accessCode is part of the link, we take advantage of this to further obfuscate the numberId
                    //in the same style as done for a Direct Access link
                    int waxOff = accessCodeString.Select((c) => (int)c).Sum() + Constants.MagicNumber;
                    numberId = ((int)numberId ^ waxOff);
                }

                Filter byNumberId = Filter.And.Equal((int)numberId, Constants.FieldName.NumberId);
                DynamicEntity qnnShortLink = (await qnnShortLinkModel.GetAsync(byNumberId)).FirstOrDefault();
                if (qnnShortLink == null)
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug("{0} - Not found, NumberId={1}", nameof(ProcessShortLink), numberId);
                    }
                    return ShortLinkResult.Fail(ShortLinkResult.Outcome.InvalidShortLink);
                }
                else
                {
                    //the NumberId is valid, process the shortlink as per details in the entity

                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug("{0} - Processing, NumberId={1}", nameof(ProcessShortLink), numberId);
                    }

                    bool isActive = (bool)qnnShortLink[Constants.FieldName.Status];
                    if (!isActive)
                    {
                        if (logger.IsEnabled(LogLevel.Debug))
                        {
                            logger.LogDebug("{0} - Inactive, Id={1}", nameof(ProcessShortLink), qnnShortLink.GetId());
                        }
                        return ShortLinkResult.Fail(ShortLinkResult.Outcome.Inactive);
                    }

                    //Check access code if using enhanced security (n.b. if an access code was supplied then we will always check it too)
                    bool isRequireAccessCode = (bool)qnnShortLink[Constants.FieldName.IsEnhancedSecurity];
                    if (accessCodeProvided || isRequireAccessCode)
                    {
                        AccessCode expectedAccessCode = AccessCode.FromEncryptedString(
                            encryptedAccessCodeBase64: (string)qnnShortLink[Constants.FieldName.AccessCode],
                            key: EncryptionHelper.Bytes(Constants.LoginKey),
                            iv: ((Guid)qnnShortLink[Constants.FieldName.Id]).ToByteArray());
                        if (accessCode != expectedAccessCode)
                        {
                            if (logger.IsEnabled(LogLevel.Debug))
                            {
                                logger.LogDebug("{0} - Incorrect AccessCode, Id={1}, expected={2}, actual={3}",
                                    nameof(ProcessShortLink), qnnShortLink.GetId(), expectedAccessCode, accessCode);
                            }
                            return ShortLinkResult.Fail(ShortLinkResult.Outcome.InvalidAccessCode);
                        }
                    }

                    Uri url = await ShortLinkTarget(qnnShortLink);
                    if(url == null)
                    {
                        if(logger.IsEnabled(LogLevel.Debug))
                        {
                            logger.LogDebug(nameof(ProcessShortLink) + " - Target is not valid, returning as inactive, Id={0}, LinkType={1}, DplyId={2}, FormName={3}, Url={4}",
                                qnnShortLink.GetId(), 
                                qnnShortLink[Constants.FieldName.LinkType], 
                                qnnShortLink[Constants.FieldName.DplyId], 
                                qnnShortLink[Constants.FieldName.FormName], 
                                qnnShortLink[Constants.FieldName.Url]);
                        }
                        return ShortLinkResult.Fail(ShortLinkResult.Outcome.Inactive);
                    }
                    else
                    {
                        return ShortLinkResult.RedirectToUrl(url);
                    }
                }
            }
            catch (Exception e)
            {
                if(logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(ProcessShortLink) + " - caught unexpected exception, shortLinkCode={0}", shortLinkCode);
                }
                throw new ShortLinkProcessingException(e);
            }
        }

        /// <summary>
        /// Convenience method to retrieve a QNN_SHORT_LINK entity
        /// </summary>
        /// <param name="id"></param>
        /// <param name="qnnShortLinkModel">optional model reference to use, pass it if you got it</param>
        /// <returns>QNN_SHORT_LINK entity or null if not found</returns>
        public static async Task<DynamicEntity> GetQnnShortLinkById(Guid id, EntityModel qnnShortLinkModel = null)
        {
            return await ORMUtils.GetEntityById(id, Constants.ModelName.QNN_SHORT_LINK, qnnShortLinkModel);
        }

        /// <summary>
        /// Calculates the target URL of the ShortLink (i.e. the destination to which someone using the short link is to be redirected)
        /// </summary>
        /// <param name="qnnShortLink"></param>
        /// <returns>url (may be null if no target is configured)</returns>
        public static async Task<Uri> ShortLinkTarget(DynamicEntity qnnShortLink)
        {
            if (qnnShortLink == null) throw new ArgumentNullException(nameof(qnnShortLink));
            ShortLinkType linkType = (ShortLinkType)Enum.Parse(typeof(ShortLinkType), (string)qnnShortLink[Constants.FieldName.LinkType]);
            switch (linkType)
            {
                case ShortLinkType.Anonymous:
                    Guid? dplyId = (Guid?)qnnShortLink[Constants.FieldName.DplyId];
                    if (dplyId == null) return null;
                    string internetDomainAuthority
                        = await SettingsHelper.Common.GetInternetDomainAuthority();
                    Guid dlsi = await DeploymentApplication.GetSWZAnonymousDLSI((Guid)dplyId);
                    string formName = (string)qnnShortLink[Constants.FieldName.FormName];
                    string anonymousSurveyUrl = DeploymentApplication.SurveyUrl(internetDomainAuthority, formName, dlsi);
                    return new Uri(anonymousSurveyUrl);

                case ShortLinkType.Url:
                    //We expect the Url to already specify the protocol
                    string url = (string)qnnShortLink[Constants.FieldName.Url];
                    if (string.IsNullOrWhiteSpace(url)) return null;
                    try
                    {
                        return new Uri(url.Trim());
                    }
                    catch(UriFormatException ufe)
                    {
                        if(logger.IsEnabled(LogLevel.Warning))
                        {
                            logger.LogWarning(ufe, "{0} - Invalid Url for {1}, returning null for target, Url={2}",
                                nameof(ShortLinkTarget), qnnShortLink.GetId(), url);
                        }
                        return null;
                    }

                default:
                    throw new NotImplementedException($"{nameof(ShortLinkType)} - {linkType}");
            }
        }

        /// <summary>
        /// Return the URL and the bytes of a PNG image of the Short Link URL
        /// </summary>
        /// <param name="qnnShortCode"></param>
        /// <returns></returns>
        public static async Task<ShortLinkUrlAndQrCode> ShortLinkQrCode(DynamicEntity qnnShortCode)
        {
            if (qnnShortCode == null) throw new ArgumentNullException(nameof(qnnShortCode));

            try
            {
                Uri goUrl = await ShortLinkGoUrl(qnnShortCode);
                byte[] qrCode = QRCodeUtils.GenerateQrCodePng(goUrl.ToString());
                return new ShortLinkUrlAndQrCode(goUrl, qrCode);
            }
            catch(Exception e)
            {
                throw new Exception("Unexpected error generating QR code/url", e);
            }
        }

        /// <summary>
        /// Return the URL of the Short Link (i.e. the short url)
        /// </summary>
        /// <param name="qnnShortLink"></param>
        /// <returns>url</returns>
        public static async Task<Uri> ShortLinkGoUrl(DynamicEntity qnnShortLink)
        {
            if (qnnShortLink == null) throw new ArgumentNullException(nameof(qnnShortLink));
            try
            {
                //enhanced security implies access code must be included
                bool includeAccessCode = (bool)qnnShortLink[Constants.FieldName.IsEnhancedSecurity];
                AccessCode accessCode = includeAccessCode
                    ? AccessCode.FromEncryptedString(
                        encryptedAccessCodeBase64: (string)qnnShortLink[Constants.FieldName.AccessCode],
                        key: EncryptionHelper.Bytes(Constants.LoginKey),
                        iv: ((Guid)qnnShortLink[Constants.FieldName.Id]).ToByteArray())
                    : null;

                //These links will be used in browser GET requests and we don't want MITM to see the url - especially if it has an AccessCode in it
                //therefore we DO NOT support http here. (If they really need it they will have to manually modify the url
                //and go generate their own insecure QR codes). n.b even with this there are plenty of places they can be seen (e.g. in 
                //QR code link checker applications, etc). At the end of the day a simple hyperlink can never be totally secure. Including
                //an access code will merely bring our short link up the same level of security as a direct access link (which of course is
                //the idea it was modelled on anyway)
                string protocol = "https://";

                string internetDomainAuthority = await SettingsHelper.Common.GetInternetDomainAuthority();

                //shortLinkCode is just an encoding of the NumberId (if AccessCode is available then its obfuscated a little more too)
                int numberId = (int)qnnShortLink[Constants.FieldName.NumberId];
                if(accessCode != null)
                {
                    //When the access code is present, the NumberId is mildly obfuscated too
                    //(Would like to alway obfuscate it, but since we use bits from the accesscode to do so, we cant)
                    int waxOn = accessCode.ToString().Select((c) => (int)c).Sum() + Constants.MagicNumber;
                    numberId ^= waxOn;
                }
                string shortLinkCode = AccessCode.EncodeLongAsString(numberId);

                StringBuilder b = new StringBuilder();
                b.Append(protocol); 
                b.Append(internetDomainAuthority);
                if (!internetDomainAuthority.EndsWith('/'))
                {
                    b.Append('/');
                }
                b.Append("go/");
                b.Append(shortLinkCode); //AccessCode chars are already URL-safe
                if (includeAccessCode)
                {
                    b.Append('/');
                    b.Append(accessCode); //AccessCode chars are already URL-safe
                }
                return new Uri(b.ToString());
            }
            catch(Exception e)
            {
                throw new Exception($"Unexpected exception calculating URL", e);
            }
        }

        /// <summary>
        /// Returns true if the current user can see this short link based on struct division id, false if they can't
        /// </summary>
        /// <param name="qnnShortLink"></param>
        /// <returns>bool</returns>
        public static async Task<bool> CheckShortLinkStructDivisionAccessAsync(DynamicEntity qnnShortLink)
        {
            if (qnnShortLink == null) throw new ArgumentNullException(nameof(qnnShortLink));
            Guid? sdi = (Guid?)qnnShortLink?[Constants.FieldName.StructDivisionId];
            return (sdi == null)
                ? false
                : await (await CloverRuntime.Security.GetCurrentUserAsync()).IsInStructDivisionAsync((Guid)sdi);
        }

        public static async Task<int> ValidateShortlinkForm(DynamicEntity data, User user)
        {
            ArgumentNullException.ThrowIfNull(data, nameof(data));
            ArgumentNullException.ThrowIfNull(user, nameof(user));

            if (!await CheckShortLinkStructDivisionAccessAsync(data)) return 2;
            string name = (string)data[Constants.FieldName.Name];
            if (string.IsNullOrWhiteSpace(name) || name.Length > 300) return 101;
            return 0;
        }
    }
}
