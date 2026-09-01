using swz.Clover.Core.Metadata.DbObjects;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Net.Mail;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Utilities
{
    //My use of SecurityUser and StructDivision lookups makes this hard to test
    //as it means we depend on the ambient context and ORM to all be available.
    //Ideally we could have a way to allow injecting inject some kind of looker-uperer that
    //can be mocked out at test time so we can test the rest of the logic without the ORM

    /// <summary>
    /// Utility email address resolver class that can take an comma delimited email setting
    /// string such as:
    ///     "test@example.com, DataEditor, dadmin, my cats name is snowflake" 
    /// and from it build a list of 'resolutions' where it will add valid email address 
    /// to the list, then checking the invalid elements to see if they are a SurveyPlus role
    /// or a login name, using those to lookup address of valid unlocked users in the 
    /// specified organisations. 
    /// The Resolutions property contains the details of this exercise, while if you just want
    /// a list of distinct validated email address then you can call GetValidDistinctEmails()
    /// to get it.
    /// (Note that email address validation is concerned only with format. It has no way to
    /// check if that is a live actual email address that can currently receive mail or not)
    /// </summary>
    public class MailRecipients
    {
        // Please keep this class immutable to callers (ie. anything a caller can
        // see once they get the instance back from factory should be read-only for them)

        public static async Task<MailRecipients> FromStringForAllOrganisations(string emailSetting)
        {
            Guid rootOrganisation = (await StructDivision.SelectRoot()).Id;
            return await FromString(emailSetting, rootOrganisation);
        }

        public static async Task<MailRecipients> FromString(
            string emailSetting,
            Guid structDivisionId)
        {
            try
            {
                HashSet<Guid> organisations
                    = await StructDivision.SelectChildrenAndThisIdSetAsync(structDivisionId);
                MailRecipients instance = new MailRecipients(emailSetting, structDivisionId, organisations);
                await instance.Init();
                return instance;
            }
            catch(Exception e)
            {
                throw new InternalException($"Failed to create an instance of {nameof(MailRecipients)} for organisation {structDivisionId} from {emailSetting}", e);
            }            
        }

        public class Resolution
        {
            public enum ElementType 
            {
                Address,
                Role,
                User,
                Invalid
            }

            public enum Outcome
            {
                UnresolveableElement,   //that's bad
                ResolvedFromAddress,    //that's good
                UserIsLocked,           //that's bad
                ResolvedFromUser,       //that's good                             
                UserLacksAddress,       //that's bad
                UserAddressInvalid,     //that's bad
            }

            /// <summary>
            /// Did this resolution result in a valid email destination?
            /// </summary>
            public bool IsValid { get => Address != null; }

            public ElementType Source { get; private set; }

            /// <summary>
            /// Resolution detail
            /// </summary>
            public Outcome Reason { get; private set; }

            /// <summary>
            /// An email address if this is a vlaid reslution
            /// or null if this is not a valid resolution
            /// </summary>
            public MailAddress Address { get; private set; }  

            public SecurityUser User { get; private set; }

            /// <summary>
            /// Element in the original mail setting that is the source of this resolution
            /// (Note that some elements, such a role codes, may have multiple resolutions)
            /// </summary>
            public string SourceElement { get; private set; }
            
            public Resolution(string element, MailAddress address, SecurityUser user, ElementType source, Outcome reason)
            {
                this.SourceElement = element;
                this.Address = address; //nullable
                this.User = user; //nullable
                this.Source = source;
                this.Reason = reason;
            }

            public override string ToString()
            {
                return $"{nameof(Resolution)}[{nameof(SourceElement)}={SourceElement}, {nameof(Address)}={Address}, {nameof(User)}={User?.Name}, {nameof(Source)}={Source.ToString()}, {nameof(Reason)}={Reason.ToString()}]";
            }
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        public readonly string EmailSetting;
        public readonly Guid StructDivisionId;
        public readonly IImmutableSet<Guid> Organisations;

        public ImmutableList<Resolution> Resolutions { get; private set; } //set by Init
        public bool IsAnyInvalid { get => Resolutions.Any(r => !r.IsValid); }
        public bool IsAnyValid { get => Resolutions.Any(r => r.IsValid); }

        /// <summary>
        /// Constructor is private because callers should only 
        /// get an initialised instance by calling the factory method 
        /// because the instance isn't fully initialised in the constructor.
        /// </summary>
        private MailRecipients(
            string emailSetting,
            Guid structDivisionId,            
            IEnumerable<Guid> organisations)
        {
            ArgumentNullException.ThrowIfNull(organisations, nameof(organisations));
            if (!organisations.Contains(structDivisionId))
                throw new ArgumentException($"Not in {nameof(organisations)}", nameof(structDivisionId));
            this.EmailSetting = emailSetting??"";
            this.StructDivisionId = structDivisionId;
            this.Organisations = organisations.ToImmutableHashSet();
        }

        /// <summary>
        /// Returns a new mutable List containing the distinct email addresses of valid resolutions
        /// as strings. List will be order by the address part only.
        /// (List might be empty but will never be null). 
        /// </summary>
        public List<string> GetValidDistinctEmails()
        {
            return Resolutions
                .Where(r => r.IsValid)
                .OrderByDescending(r => !string.IsNullOrEmpty(r.Address.DisplayName)) //prefer with DN
                .DistinctBy(r => r.Address.Address, Constants.Comparers.ObjectNameCaseInsensitive)
                .OrderBy(r => r.Address.Address)
                .Select(r => r.Address.ToString())
                .ToList();
        }

        /// <summary>
        /// Returns a new mutable List containing the valid resolutions
        /// </summary>
        public List<Resolution> GetValidResolutions()
        {
            return Resolutions.Where(r => r.IsValid).ToList();
        }

        public List<Resolution> GetInvalidResolutions()
        {
            return Resolutions.Where(r => !r.IsValid).ToList();
        }

        /// <summary>
        /// Parse the comma delimited list of recipients. Each recipient can be either an
        /// email address or a # followed by the name of a role, these will be expanded to the
        /// email addresses of unlocked users in the specified organisation or organisations 
        /// below it in the organisational hieracrchy.
        /// </summary>
        private async Task Init()
        {
            try
            {
                List<Resolution> resolutions = new List<Resolution>();
                List<string> values = EmailSetting
                    .Split(',')
                    .Where(e => !string.IsNullOrWhiteSpace(e))
                    .Select(e => e.Trim())
                    .Distinct()
                    .ToList();
                foreach (string element in values)
                {
                    try
                    {   //First try to resolve from element as an email address
                        MailAddress address = new MailAddress(element);
                        resolutions.Add(new Resolution(element, address, null, Resolution.ElementType.Address, Resolution.Outcome.ResolvedFromAddress));
                    }
                    catch (FormatException)
                    {   //But if its not a valid email, it may refer to a role or a login
                        SecurityRole role = await SecurityRole.SelectByCodeOrName(element);
                        if(role != null)
                        {
                            resolutions.AddRange( await ResolveFromRole(element, role) );
                        }
                        else
                        {
                            SecurityUser user = await SecurityUser.SelectByPrincipal(element);
                            if(user != null)
                            {
                                resolutions.AddRange (ResolveFromUser(element, user, Resolution.ElementType.User) );
                            }
                            else
                            {
                                resolutions.Add(new Resolution(element, null, null, Resolution.ElementType.Invalid, Resolution.Outcome.UnresolveableElement));
                            }
                        }
                    }
                }
                Resolutions = resolutions.ToImmutableList();
            }
            catch(Exception e)
            {
                throw new InternalException($"Unrecoverable error resolving elements for organisation {StructDivisionId}, {nameof(EmailSetting)}={EmailSetting}", e);
            }
        }

        private async Task<IEnumerable<Resolution>> ResolveFromRole(string element, SecurityRole role)
        {
            ArgumentException.ThrowIfNullOrWhiteSpace(element, nameof(element));
            ArgumentNullException.ThrowIfNull(role, nameof(role));
            try
            {
                List<Resolution> recipients = new List<Resolution>();
                List<SecurityUser> usersInRole = await SecurityRole.GetUsersByRoleId(role.Id);
                foreach(SecurityUser user in usersInRole)
                {
                    recipients.AddRange(ResolveFromUser(element, user, Resolution.ElementType.Role));
                }
                return recipients;
            }
            catch (Exception e)
            {
                throw new InternalException($"Unrecoverable error resolving role {element}", e);
            }
        }

        /// <summary>
        /// Verify the user is in the allowed organisations, is not locked, and also check their
        /// address is ok. (Users in non-applicable organisation will be ignored with no resolution
        /// generated. Users who are locked or have a bad address will generate an invalid
        /// resolution). 
        /// </summary>
        /// <param name="element"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        /// <exception cref="InternalException"></exception>
        private IEnumerable<Resolution> ResolveFromUser(string element, SecurityUser user, Resolution.ElementType source)
        {
            ArgumentNullException.ThrowIfNull(user, nameof(user));
            try
            {
                if(    user.StructDivisionId==null 
                    || !Organisations.Contains(user.StructDivisionId.Value))
                {
                    return []; //Ignore this user without generating a resolution
                }
                if (user.IsLocked)
                {  //User is locked, we will ignore their email address and not provide it in the result
                    return [new Resolution(
                        element, 
                        address: null, 
                        user, 
                        source, 
                        Resolution.Outcome.UserIsLocked)];
                }
                else if (string.IsNullOrWhiteSpace(user.Email))
                {   //No email address
                    return [new Resolution(
                        element, 
                        address: null, 
                        user, source, 
                        Resolution.Outcome.UserLacksAddress)];
                }
                else
                {
                    try
                    {   //Usual case, return the users address
                        MailAddress email = new MailAddress(user.Email);
                        return [new Resolution(
                            element, 
                            address: email, 
                            user, 
                            source, 
                            Resolution.Outcome.ResolvedFromUser)];
                    }
                    catch (FormatException)
                    {   //User with an invalid address
                        return [new Resolution(
                            element, 
                            address: null, 
                            user, 
                            source, 
                            Resolution.Outcome.UserAddressInvalid)];
                    }
                }
            }
            catch (Exception e)
            {
                throw new InternalException($"Unrecoverable error resolving user {element}", e);
            }
        }
    }
}
