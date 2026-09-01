using System.Linq;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Net.Mail;
using System.Net;
using System;
using Microsoft.Extensions.Logging;
using System.IO;
using System.Net.Mime;
using swz.Clover.Core.Metadata.DbObjects;
using System.Web;

namespace swz.Clover.Core.Utils
{
    /// <summary>
    /// Utility methods for sending mail. If you have only a single message to send then you can use the SendAsync or FormSendAsync methods.
    /// If you are doing a mail blast it is recommended to create an instance of IMailer and send using that (the SendAsync, FormSendAsync
    /// us it internally and just provide you a simpler api). IMailer in turn wraps details of the actual mailer implementation (currently
    /// we use System.Net.SmtpClient).
    /// </summary>
    public class Email
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(Email));

        /// <summary>
        /// Object to hold the information necessary to define an attachment or linked-resource to
        /// be included with mail. You can use one of the convenience factory methods to construct.
        /// Note that while Item does NOT implement IDisposable, the Stream it wraps will be disposble.
        /// Pay attention to semantics of how this is disposed (i.e. the IMailer.SendAsync and the convenience SendAysnc
        /// to use it will dispose of the streams in these Items - in the case of the SmptMailer implementation this will
        /// be because they are
        /// </summary>
        public class Item
        {
            public enum AttachmentMode { Attach, Embed }

            public AttachmentMode Mode { get; private set; }
            public Stream FileData { get; private set; }
            public string Name { get; private set; }
            public string ContentType { get; private set; }

            public Item(AttachmentMode mode, Stream fileData, string name, string contentType)
            {
                if(fileData==null) throw new ArgumentNullException(nameof(fileData));
                if (string.IsNullOrEmpty(name)) throw new ArgumentException(nameof(name));
                if (string.IsNullOrEmpty(contentType)) throw new ArgumentException(nameof(contentType));

                this.Mode = mode;
                this.FileData = fileData;
                this.Name = name;
                this.ContentType = contentType;
            }
        }

        /// <summary>
        /// Convenience factory method to create an Item object representing an attachment.
        /// </summary>
        /// <param name="fileData"></param>
        /// <param name="fileName"></param>
        /// <param name="fileContentType"></param>
        /// <returns>attachment item</returns>
        public static Item CreateAttachment(Stream fileData, string fileName, string fileContentType)
        {
            return new Item(Item.AttachmentMode.Attach, fileData, fileName, fileContentType);
        }

        /// <summary>
        /// Convenience factory method to create an Item object representing a linked resource.
        /// </summary>
        /// <param name="fileData"></param>
        /// <param name="fileName"></param>
        /// <param name="fileContentType"></param>
        /// <returns>attachment item</returns>
        public static Item CreateEmbedded(Stream fileData, string fileName, string fileContentType)
        {
            return new Item(Item.AttachmentMode.Embed, fileData, fileName, fileContentType);
        }

        /// <summary>
        /// Convenience factory method to return an attachment Item with contentType application/pdf
        /// </summary>
        /// <param name="fileData"></param>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static Item CreatePdfAttachment(Stream fileData, string fileName)
        {
            return new Item(Item.AttachmentMode.Attach, fileData, fileName, "application/pdf");
        }

        /// <summary>
        /// Convenience factory method to return an attachment Item with contentType text/csv
        /// </summary>
        /// <param name="fileData"></param>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static Item CreateCsvAttachment(Stream fileData, string fileName)
        {
            return new Item(Item.AttachmentMode.Attach, fileData, fileName, "text/csv");
        }

        /// <summary>
        /// Convenience factory method to return an embedded (linked resource) Item with contentType image/png
        /// </summary>
        /// <param name="fileData"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        public static Item CreatePngEmbed(Stream fileData, string name)
        {
            return new Item(Item.AttachmentMode.Attach, fileData, name, "image/png");
        }

        /// <summary>
        /// Convenience factory method to return an attachment Item with contentType application.zip
        /// </summary>
        /// <param name="fileData"></param>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static Item CreateZipAttachment(Stream fileData, string fileName)
        {
            return new Item(Item.AttachmentMode.Attach, fileData, fileName, "application/zip");
        }

        /// <summary>
        /// Constant to allow caller to make more explicit their intent that the default emailFrom value be used.
        /// </summary>
        public const string UseDefaultEmailFrom = null;

        /// <summary>
        /// Constant to allow caller to make more explicit their intent that the default senderDisplayName be used.
        /// Do note that an explicit name part in the emailFrom argument to SendAsync will override this.
        /// </summary>
        public const string UseDefaultSenderDisplayName = null;

        /// <summary>
        /// Convenience method for using an IMailer to send a single message. 
        /// Creates a new IMailer instance and use it to send a message with optional attachments.
        /// DO NOT USE THIS METHOD IN A LOOP. This method is syntactic sugar for creating an IMailer instance and using
        /// it to send a single message. If you need to send more than one message then you should use IMailer.
        /// </summary>
        /// <param name="mailSettings"></param>
        /// <param name="mailTo"></param>
        /// <param name="mailCc"></param>
        /// <param name="mailBcc"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="senderDisplayName"></param>
        /// <param name="emailFrom">Optional sender address. If this includes a display name part it will override any value passed for senderDisplayName.</param>
        /// <param name="items"></param>
        /// <returns></returns>
        /// <exception cref="ArgumentNullException"></exception>
        public static async Task<bool> SendAsync(
            MailSettings mailSettings,
            IEnumerable<string> mailTo,
            IEnumerable<string> mailCc,
            IEnumerable<string> mailBcc,
            string subject,
            string body,
            string senderDisplayName = UseDefaultSenderDisplayName,
            string emailFrom = UseDefaultEmailFrom,
            params Item[] items)
        {
            if (mailSettings == null) throw new ArgumentNullException(nameof(mailSettings));
            if (mailTo == null) throw new ArgumentNullException(nameof(mailTo));

            using(IMailer mailer = await CreateMailer(
                mailSettings: mailSettings,
                senderDisplayName: senderDisplayName,
                emailFrom: emailFrom) )
            {
                return await mailer.SendAsync(
                    mailTo: mailTo,
                    mailCc: mailCc,
                    mailBcc: mailBcc,
                    subject: subject,
                    body: body,
                    items: items);
            }
        }

        /// <summary>
        /// Convenience version for the most common mail sending case (single message with single to-address)
        /// Creates a new IMailer instance and use it to send a message with optional attachments.
        /// DO NOT USE THIS METHOD IN A LOOP. This method is syntactic sugar for creating an IMailer instance and using
        /// it to send a single message. If you need to send more than one message then you should use IMailer.
        /// If you want to use the default from address along with attachments then you can pass the constant UseDefaultEmailFrom
        /// (which is just null, but makes the intent more readable in your code).
        /// If you don't specify the (optional)emailFrom then the login for the SMTP server will be used. You can specify UseDefaultEmailFrom
        /// to be explicit about this. 
        /// </summary>
        /// <param name="mailSettings">Provides the configuration to connect to the SMTP server</param>
        /// <param name="mailTo">the email address to send to</param>
        /// <param name="subject">subject line</param>
        /// <param name="body">mail body</param>
        /// <param name="senderDisplayName">(optional) displayed as name of the sender in the from address</param>
        /// <param name="emailFrom">(optional) the from address (will use the default from addres if left unspecified). If this includes a display name part it will override any value passed for senderDisplayName.</param>
        /// <param name="attachments">(optional) file attachements to include in the mail (will be disposed by this call)</param>
        /// <returns>false on sending error, true normally (exception will be logged at error level (if calling code needs access to this exception it will have to create a mailer instance itself instead of using this convenience method))</returns>
        public static async Task<bool> SendAsync(
            MailSettings mailSettings,
            string mailTo,
            string subject,
            string body,
            string senderDisplayName = UseDefaultSenderDisplayName,
            string emailFrom = UseDefaultEmailFrom,
            params Item[] items)
        {
            using (IMailer mailer = await CreateMailer(
                mailSettings: mailSettings,
                senderDisplayName: senderDisplayName,
                emailFrom: emailFrom))
            {
                return await mailer.SendAsync(
                    mailTo: new String[] { mailTo },
                    mailCc: null,
                    mailBcc: null,
                    subject: subject,
                    body: body,
                    items: items);
            }
        }

        /// <summary>
        /// Check the single email address passed is formatted correctly for a single email address.
        /// (Doesn't check if the address is real and can receive mail)
        /// Supports display name, so for example the following would all be valid:
        /// example@example.com
        /// "Mr Roboto" &lt;kilroy@example.com&gt;
        /// "Bond, James" &lt;007@example.com&gt;    (note that a single email can contain a comma!)
        /// Example example@example.com
        /// 
        /// nb: current implementation uses System.Net.MailAddress internally to check, but this
        ///     may change in future versions.
        /// </summary>
        /// <param name="address">email to be check</param>
        /// <returns>bool true if email is valid, otherview false</returns>
        public static bool IsAddressFormatValid(string address)
        {
            if (string.IsNullOrWhiteSpace(address)) return false;
            try
            {
                var _ = new MailAddress(address);
                return true;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Split a comma delimited string of email addresses into a list of individual address 
        /// and normalise their format in the output list. 
        /// It is expected that the list is formatted validly, if not then a FormatException is raised.
        /// WARNING: in this version commas in quoted display names are not properly supported yet!
        /// </summary>
        /// <param name="emails">(if this is null or empty then an empty list is returned)</param>
        /// <param name="removeLineEndings">true by default, strips out any line endings in the string</param>
        /// <returns>a new List of string email address values (the list is modifiable by caller)</returns>
        public static List<string> SplitAddresses(string addresses, bool removeLineEndings=true)
        {
            if (string.IsNullOrWhiteSpace(addresses))
                return new List<string>();
;
            try
            {
                MailAddressCollection mailAddresses = new MailAddressCollection();
                mailAddresses.Add(
                    removeLineEndings
                        ? addresses.ReplaceLineEndings("")
                        : addresses);
                return mailAddresses.Select(ma => ma.ToString()).ToList();
            }
            catch(Exception e)
            {
                throw new FormatException($"Invalid comma delimited email address list \"{addresses}\n", e);
            }

            //old impl that was being used inline in the mail merger before (pasted here for reference)
            // .Split(',', StringSplitOptions.RemoveEmptyEntries).Select(s => s.Trim()).Where(s => !string.IsNullOrEmpty(s));
        }

        /// <summary>
        /// Split the comma delimited email address and extract a list of distinct email addresses 
        /// (Warning: the current implementation always drops any display names, but we hope to add 
        ///           some smarts in the future to retain the display name part if there is no conflict)
        /// </summary>
        public static List<string> SplitAddressesExtractDistinct(
            IEnumerable<string> listOfCommaDelimitedAddresses,
            bool removeLineEndings = true)
        {
            try
            {
                MailAddressCollection mailAddresses = new MailAddressCollection();
                foreach (string commaDelimitedAddresses in listOfCommaDelimitedAddresses)
                {
                    if(!string.IsNullOrWhiteSpace(commaDelimitedAddresses))
                        mailAddresses.Add(
                            removeLineEndings
                            ? commaDelimitedAddresses.ReplaceLineEndings("")
                            : commaDelimitedAddresses );
                }
                List<string> result = mailAddresses
                    .Select(ma => ma.Address)
                    .Distinct(StringComparer.InvariantCultureIgnoreCase) //TODO - should this be ordinal?
                    .ToList();
                return result;
            }
            catch (Exception e)
            {
                throw new FormatException("Failed to parse enumeration of comma delimited email addresses", e);
            }
        }

        /// <summary>
        /// Send an email message based on subject and body controls in the specified Clover form with token substitution.
        /// Note that this does *not* attempt to generate an html mail that looks like the form, instead it uses the content
        /// from controls named 'subject' and 'body' in the named form. The advantage of this is the Clover form can be edited
        /// at runtime, so it provides a convenient mechanism to allow for customisation of the mail content.
        /// </summary>
        public static async Task<bool> FormSendAsync(
            MailSettings mailSettings, 
            IEnumerable<string> mailTo,
            IEnumerable<string> mailCc,
            IEnumerable<string> mailBcc,
            string formName,
            Dictionary<string, string> parameters = null,
            string senderDisplayName = UseDefaultSenderDisplayName,
            string emailFrom = UseDefaultEmailFrom,
            params Item[] items)
        {
            if (mailSettings == null) throw new ArgumentNullException(nameof(mailSettings));
            if (string.IsNullOrEmpty(formName)) throw new ArgumentException(nameof(formName));
            bool isHtmlEncode = true; //TODO - allow this to be passed

            Metadata.Form form = CloverRuntime.Metadata.GetForm(formName); //20260701 - was CR.M
            Dictionary<string, Newtonsoft.Json.Linq.JToken> controls = form.GetControls(new List<string>() { "subject", "body" });
            StringBuilder subject = new StringBuilder(controls.Where(c => c.Key == "subject").Select(c => c.Value["content"].ToString()).FirstOrDefault());
            StringBuilder body = new StringBuilder(controls.Where(c => c.Key == "body").Select(c => c.Value["content"].ToString()).FirstOrDefault());

            //TODO - later if we update the ProfileMailMerger in SurveyPlus to use a more efficient templating mechanism
            //       we should consider using it here
            if(parameters != null)
            {
                foreach (var p in parameters)
                {
                    var key = string.Format("{{{0}}}", p.Key);

                    if (subject.Length > 0)
                        subject.Replace(key, p.Value);  //Subject does not need HTML encoding

                    if (body.Length > 0)
                    {
                        string value = isHtmlEncode
                            ? HttpUtility.HtmlEncode(p.Value??"").Replace("\n", "<br />")
                            : p.Value;
                        body.Replace(key, value);
                    }
                        
                }
            }

            using (IMailer mailer = await CreateMailer(
                mailSettings: mailSettings,
                senderDisplayName: senderDisplayName,
                emailFrom: emailFrom))
            {
                return await mailer.SendAsync(
                    mailTo: mailTo,
                    mailCc: mailCc,
                    mailBcc: mailBcc,
                    subject: subject.ToString(),
                    body: body.ToString(),
                    items: items);
            }
        }

        /// <summary>
        /// OLD SendEmail api here for legacy compatability (eg if we use this Core with non-SurveyPlus application)
        /// DO NOT USE THIS METHOD - please use the non-obsolete methods now. 
        /// Internally this now calls FormSendAsync
        /// </summary>
        /// <param name="formName"></param>
        /// <param name="email"></param>
        /// <param name="parameters"></param>
        /// <param name="ccEmail"></param>
        /// <param name="bccEmail"></param>
        /// <returns></returns>
        [Obsolete]
        public static async Task<bool> SendEmail(
            string formName,
            string email,
            Dictionary<string, string> parameters,
            List<string> ccEmail = null,
            List<string> bccEmail = null)
        {
            logger.LogWarning(nameof(SendEmail) + " - Use of obsolete variant of SendEmail, formName={0}", formName);
            MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
            List<AppSettings> settings = await AppSettings.SelectAsync(Filter.And.Equal("ApplicationName", "Name"));
            string appName = settings.FirstOrDefault()?.Value;
            return await FormSendAsync(
                mailSettings: mailSettings,
                mailTo: new string[] { email },
                mailCc: ccEmail,
                mailBcc: bccEmail,
                formName: formName,
                parameters: parameters,
                senderDisplayName: appName,
                emailFrom: UseDefaultEmailFrom);
        }

        /// <summary>
        /// Factory method to create an instance of IMailer for the supplied configuration.
        /// You MUST Dispose of the mailer when you are done with it.
        /// </summary>
        /// <param name="mailSettings"></param>
        /// <param name="senderDisplayName"></param>
        /// <param name="emailFrom"></param>
        /// <returns></returns>
        public static async Task<IMailer> CreateMailer(
                MailSettings mailSettings,
                string senderDisplayName = UseDefaultSenderDisplayName,
                string emailFrom = UseDefaultEmailFrom)
        {
            //TODO - we should look toward moving away from SmtpClient, its use is no longer recommended
            //See: https://docs.microsoft.com/en-us/dotnet/api/system.net.mail.smtpclient?view=netcore-3.1
            return await SystemNetSmtpMailer.Create(mailSettings, senderDisplayName, emailFrom);
        }

        /// <summary>
        /// Wraps implementation specific exceptions caught in the IMailer implementations
        /// </summary>
        public class MailerException : Exception
        {
            public MailerException(string message) : base(message) { }

            public MailerException(string message, Exception innerException) : base(message, innerException) { }
        }

        /// <summary>
        /// Abstracts the interaction with underlying mail client (currently we use System.Net.Smtp) to facilitate
        /// more efficient sending of bulk mail. To use create an instance using the provided factory method and
        /// then call SendAsync for each message. When finished you must Dispose() of it (implements IDisposable).
        /// TODO: describe threadsafety and mutability considerations
        /// 
        /// TODO: currently this still requires callers to know about Sstem.Net.Mail.Attachment. We will need to abstract over this
        ///       and also find a convenient way to allow for using LinkedResource where applicable.
        //Internally the convenience send methods in Email will also use this so we don't have to maintain many
        //minor variants of of email code.
        public interface IMailer : IDisposable
        {
            /// <summary>
            /// If SendAsync encountered an exception while sending it will return false. You can use this property to
            /// get the exception from the last call to SendAsync. (If the last call was successful this will be null).
            /// The actual exception will be the InnerException, we use a MailerException to wrap it.
            /// (Note: Does not apply to exceptions raised from validation of arguments passed by caller).
            /// </summary>
            MailerException LastSendException { get; }

            /// <summary>
            /// Send an email message.
            /// Note: this method only raises exceptions for invalid arguments, other exceptions are caught and
            /// stored in LastSendException and false is returned
            /// </summary>
            /// <param name="mailTo"></param>
            /// <param name="mailCc"></param>
            /// <param name="mailBcc"></param>
            /// <param name="subject"></param>
            /// <param name="body"></param>
            /// <param name="items"></param>
            /// <returns>true if message was successfully passed to mail server to be sent, false if an error was caught while sending (can check LastSendException property for details). Note that this won't indicate if a successfully passed message actually reached its destination.</returns>
            Task<bool> SendAsync(IEnumerable<string> mailTo,
                IEnumerable<string> mailCc,
                IEnumerable<string> mailBcc,
                string subject,
                string body,
                params Item[] items);
        }

        /// <summary>
        /// Implementation of IMailer that uses System.Net.SmtpClient internally.
        /// </summary>
        private class SystemNetSmtpMailer : IMailer
        {

            /// <summary>
            /// Create an instance of IMailer using the specified connection settings.
            /// </summary>
            /// <param name="mailSettings">SMTP server connection settings</param>
            /// <param name="senderDisplayName">(Optional) Name to use as sender name instead of default. Note that an explicit sender name in the emailFrom will override this.</param>
            /// <param name="emailFrom">(Optional) sender address. If not specified will use the configured default from address. If the value specified for emailFrom includes a display name part it will override any value passed for senderDisplayName.</param>
            /// <returns></returns>
            public static async Task<SystemNetSmtpMailer> Create(
                MailSettings mailSettings,
                string senderDisplayName = UseDefaultSenderDisplayName,
                string emailFrom = UseDefaultEmailFrom)
            {
                //The signature of this is async to facilitate future changes, (such as if we move to MailKit?)
                //We will be able to call an InitAsync() after the constructor if any async initialisation is
                //needed before we return the mailer. 
                
                SystemNetSmtpMailer mailer = new SystemNetSmtpMailer();
                await mailer.InitAsync(mailSettings, senderDisplayName, emailFrom);
                return mailer;
            }

            private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(SystemNetSmtpMailer));

            private bool disposed = false; //used in Dispose()
            private SmtpClient smtpClient = null;
            private MailAddress from;

            public MailerException LastSendException { get; private set; } = null;

            /// <summary>
            /// Constructor is private so that instances can only be created by the provided aysync factory methods.
            /// Factory methods must call InitAsyc after construction before returning the object.
            /// </summary>
            private SystemNetSmtpMailer()
            {
                ;
            }

            private bool IsUseDefaultEmailFrom(string emailFrom)
            {
                return string.IsNullOrEmpty(emailFrom);
            }

            private bool IsUseDefaultSenderDisplayName(string senderDisplayName)
            {
                return string.IsNullOrEmpty(senderDisplayName);
            }

            private async Task InitAsync(
                MailSettings mailSettings,
                string senderDisplayName = UseDefaultSenderDisplayName,
                string emailFrom = UseDefaultEmailFrom)
            {
                if (mailSettings == null)
                    throw new ArgumentNullException(nameof(mailSettings));
                try
                {
                    smtpClient = new SmtpClient(mailSettings.MailServer,mailSettings.MailServerPort);
                    smtpClient.Credentials = new NetworkCredential(mailSettings.MailServerLogin,mailSettings.MailServerPass);
                    smtpClient.EnableSsl = mailSettings.MailServerSsl;

                    //Following logic will determine what the FromAddress and display name is. This consists of both an email
                    //address and a sender name to display. If the sender name was explicitly specified in the emailFrom string
                    //(e.g. "Mr Roboto" <kiloy@example.com>) then that name will be used regardless of what is passed
                    //in senderDisplayName argument. If however it is not then the senderDisplayName will be used. If this
                    //is specified as UseDefaultSenderName then we use the 'default' (which is currently nothing) otherwise
                    //we will use the name specified in the senderDisplayName argument along with the address we determined
                    //for the fromAddress (ie: if UseDefaultFromAddress we will use the configured login for our SMTP server
                    //note that we don't really expect that to contain an explicit display name, but if it does it would override
                    //the senderDisplayName arg in the same way putting a displayName in the emailFrom will.)
                    //This means that we can pass the appName as a fallback to senderDisplayName and then the fromEmail can be optionally
                    //specified, and if it is it can optionally also specify the display name to use. If nothing is specified then we
                    //would send using the SMTP login address together with the appName that was passed as the display name.
                    //Do note however that some SMTP servers (eg gmail) might choose not to respect the sender address
                    //and force the use of the login address for all sends! Others such as Amazon SES might have
                    //a completely seperate non-email-address login name, but also require a sender address to 
                    //always be specified, and to be at a certain domain.
                    String senderAddressString = IsUseDefaultEmailFrom(emailFrom)
                        ? mailSettings.MailServerDefaultFrom
                        : emailFrom; //This one comes from the argument, might have an explicit displayName
                    if (!MailAddress.TryCreate(senderAddressString, out MailAddress senderAddress))
                    {
                        throw new MailerException($"Invalid sender address: {senderAddressString}");
                    }
                    bool emailFromContainsDisplayName = !string.IsNullOrEmpty(senderAddress.DisplayName);
                    if(emailFromContainsDisplayName)
                    {
                        from = senderAddress;
                    } 
                    else
                    {
                        from = IsUseDefaultSenderDisplayName(senderDisplayName)
                                ? senderAddress
                                : new MailAddress(senderAddress.Address, senderDisplayName);
                    }
                }
                catch(MailerException)
                {
                    throw;
                }
                catch(Exception e)
                {
                    if (logger.IsEnabled(LogLevel.Debug))
                    {
                        logger.LogDebug(e, nameof(InitAsync) + " - caught unexpected exception");
                    }
                    throw new MailerException("Error initialising mailer", e);
                }
            }

            public async Task<bool> SendAsync(
                IEnumerable<string> mailTo,
                IEnumerable<string> mailCc,
                IEnumerable<string> mailBcc,
                string subject,
                string body,
                params Item[] attachments)
            {
                if (disposed || smtpClient == null) 
                    throw new InvalidOperationException(nameof(SystemNetSmtpMailer) + " has been disposed or is not useable");
                if (mailTo == null) 
                    throw new ArgumentNullException(nameof(mailTo));

                try
                {
                    LastSendException = null;

                    (List<Attachment> attachments, List<LinkedResource> linkedResources) items = PrepareItems(attachments);

                    using (MailMessage mailMessage = new MailMessage())
                    {
                        mailMessage.From = from;

                        mailMessage.Subject = subject ?? "";
                        //mailMessage.SubjectEncoding = Encoding.UTF8;

                        if (items.linkedResources.Any())
                        {
                            AlternateView av = AlternateView.CreateAlternateViewFromString(
                                content: body,
                                contentEncoding: null,
                                mediaType: "text/html");
                            foreach (LinkedResource linkedResource in items.linkedResources)
                            {
                                av.LinkedResources.Add(linkedResource);
                            }
                            mailMessage.AlternateViews.Add(av);
                        }
                        else
                        {
                            mailMessage.Body = body ?? "";
                            //mailMessage.BodyEncoding = Encoding.UTF8;
                        }

                        mailMessage.IsBodyHtml = true;

                        foreach (string address in mailTo)
                        {
                            mailMessage.To.Add(address);
                        }

                        foreach (string address in mailCc ?? Array.Empty<string>())
                        {
                            mailMessage.CC.Add(address);
                        }

                        foreach (string address in mailBcc ?? Array.Empty<string>())
                        {
                            mailMessage.Bcc.Add(address);
                        }

                        foreach (Attachment attachment in items.attachments)
                        {
                            mailMessage.Attachments.Add(attachment);
                        }

                        //nb: important to wait for sending here before sending another, and we also want to see any exception it throws
                        //see: https://stackoverflow.com/questions/389709/why-can-smtpclient-sendasync-only-be-called-once
                        await smtpClient.SendMailAsync(mailMessage);
                        return true;
                    } //end using mailMessage (also disposes linked resources such as attachments)
                }
                catch (Exception e)
                {
                    const string msg = "SendAsync caught exception";
                    logger.LogError(e, msg);
                    MailerException wrapException = new MailerException(msg, e);
                    LastSendException = wrapException;
                    return false; //In general caller will prefer to carry on with their next message so we return error flag and log the exception
                }
            }

            private (List<Attachment> attachments, List<LinkedResource> linkedResources) PrepareItems(Item[] items)
            {
                List<Attachment> attachments = new List<Attachment>();
                List<LinkedResource> linkedResources = new List<LinkedResource>();
                foreach(Item item in items)
                {
                    if (item == null) throw new ArgumentException("There is a null element in the items array", nameof(items));
                    ContentType contentType = new ContentType(item.ContentType);
                    switch (item.Mode)
                    {
                        case Item.AttachmentMode.Attach:
                            Attachment attachment = new Attachment(item.FileData, contentType);
                            attachment.ContentDisposition.FileName = item.Name;
                            attachments.Add(attachment);
                            break;

                        case Item.AttachmentMode.Embed:
                            LinkedResource linkedResource = new LinkedResource(item.FileData, contentType);
                            linkedResource.ContentId = item.Name;
                            linkedResources.Add(linkedResource);
                            break;
                    }
                }
                return (attachments, linkedResources);
            }

            public void Dispose()
            {
                if (disposed) 
                    return;

                //See Rule2 here: https://dzone.com/articles/how-to-properly-dispose-of-resources-in-net-core

                if (smtpClient != null)
                {
                    smtpClient.Dispose();
                    smtpClient = null;
                }
                disposed = true;

                //I didn't bother with a finalizer as smtpClient has its own
            }

        } //end of SystemNetSmtpMailer
    } //end of Email
}
