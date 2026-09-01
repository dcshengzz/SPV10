using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication
{
    public enum FileTicketPurpose
    {
        //.............................  n.b. length must be <= 32 (but try to keep it even shorter)
        Unspecified,
        ResponseData,
        ResponseFiles,
        AuditArchive,
        ResponseImport,
        SampleOwnerImport,
        PrePopulation,
        SampleListImport,
    }

    /// <summary>
    /// Helper to simplify creating a new QNN_FILE_TICKET entity
    /// </summary>
    public class FileTicketBuilder
    {
        private Guid? fileId;
        private readonly Guid? structDivisionId;
        private FileTicketPurpose purpose;
        private bool isEnabled = true;
        private DateTime? expiryDate;
        private bool isDeleteFileOnExpiry = true;
        private HashSet<string> roles = new HashSet<string>();
        private Guid? userId;
        private Guid? createdBy;

        /// <summary>
        /// Constructor.
        /// For the StructDivision you should specify the organisation to which the file belongs. (Depending on the use-case this
        /// may well differ from the current user's organisation. For example, a response export should have the StructDivisionId of
        /// the deployment).
        /// </summary>
        /// <param name="token">File token</param>
        /// <param name="purpose"></param>
        /// <param name="structDivisionId">organisation the file belongs to</param>
        /// <exception cref="ArgumentException"></exception>
        public FileTicketBuilder(string token, FileTicketPurpose purpose, Guid structDivisionId)
        {
           if (string.IsNullOrEmpty(token)) throw new ArgumentException(nameof(token));

           if(!Guid.TryParse(token, out Guid id))
                throw new ArgumentException("invalid", nameof(token));
            this.fileId = id;
            this.purpose = purpose;
            this.structDivisionId = structDivisionId;
        }

        /// <summary>
        /// Alternate constructor for use when the token isn't known yet
        /// </summary>
        /// <param name="purpose"></param>
        /// <param name="structDivisionId"></param>
        public FileTicketBuilder(FileTicketPurpose purpose, Guid structDivisionId)
        {
            this.purpose = purpose;
            this.structDivisionId = structDivisionId;
        }

        public FileTicketBuilder Token(string token)
        {
            if (string.IsNullOrEmpty(token)) throw new ArgumentException(nameof(token));

            if (!Guid.TryParse(token, out Guid id))
                throw new ArgumentException("Invalid token", nameof(token));
            else
                this.fileId = id;
            return this;
        }

        public FileTicketBuilder Enable(bool isEnabled)
        {
            this.isEnabled = isEnabled;
            return this;
        }

        public FileTicketBuilder Expires(DateTime? expiryDate)
        {
            this.expiryDate = expiryDate;
            return this;
        }

        public FileTicketBuilder DeleteFileOnExpiry(bool isDeleteOnExpiry)
        {
            this.isDeleteFileOnExpiry = isDeleteOnExpiry;
            return this;
        }

        /// <summary>
        /// Add the code of a role that is allowed to download the file. If any such restrictions are set then only a user with one
        /// of the listed roles is allowed to download the file. If no restrictions are set then no particular role is required beyond
        /// being authenticated).
        /// This can be called multiple times to add more roles.
        /// </summary>
        public FileTicketBuilder AddRoleRestriction(string roleCode)
        {
            this.roles.Add(roleCode);
            return this;
        }

        /// <summary>
        /// Specify a single user who is allowed to download the file (this does not take multiple values and repeated calls will
        /// override the previous setting)
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public FileTicketBuilder RestrictToUser(Guid userId)
        {
            this.userId = userId;
            return this;
        }

        public FileTicketBuilder CreatedBy(Guid userId)
        {
            this.createdBy = userId;
            return this;
        }

        /// <summary>
        /// Build a QNN_FILE_TICKET entity.
        /// If you specify a token it will take priority over the token specified earlier (without mutating the builder
        /// state). 
        /// </summary>
        public async Task<DynamicEntity> Build(string token = null)
        {
            Guid? fileId = this.fileId;
            if(!string.IsNullOrEmpty(token))
            {
                if (!Guid.TryParse(token, out Guid id))
                    throw new ArgumentException("invalid", nameof(token));
                fileId = id;
            }
            if (fileId == null)
                throw new InvalidOperationException("Token not provided");

            EntityModel fileTicketModel 
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_FILE_TICKET, Constants.Level.NoJoins);
            DynamicEntity qnnFileTicket = await fileTicketModel.NewAsync();

            if(createdBy == null)
            {
                Clover.Core.Security.User currentUser = await CloverRuntime.Security.GetCurrentUserAsync(); //May be null
                createdBy = currentUser?.Id;
            }

            qnnFileTicket[Constants.FieldName.FileId] = fileId;
            qnnFileTicket[Constants.FieldName.Purpose] = purpose.ToString();
            qnnFileTicket[Constants.FieldName.IsEnabled] = isEnabled;
            qnnFileTicket[Constants.FieldName.RestrictedToUserId] = userId;
            qnnFileTicket[Constants.FieldName.RestrictedToRoles] = string.Join(',', roles);
            qnnFileTicket[Constants.FieldName.ExpiryDate] = expiryDate;
            qnnFileTicket[Constants.FieldName.IsDeleteFileOnExpiry] = isDeleteFileOnExpiry;            
            qnnFileTicket[Constants.FieldName.CreatedDate] = DateTime.Now;
            qnnFileTicket[Constants.FieldName.CreatedBy] = createdBy;
            qnnFileTicket[Constants.FieldName.StructDivisionId] = structDivisionId;
            return qnnFileTicket;
        }
    }

    public static class FileTicketApplication
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(FileTicketApplication));

        /// <summary>
        /// Get a file ticket using its Id.
        /// WARNING: QNN_FILE_TICKET has a foreign key to dwUploadedFiles to facilitate cascade delete, but this means
        ///          that if you use a model with join level 1 or above then Clover will try to fetch the columns for the
        ///          dwUploadedFiles and this includes the Data column which can be HUGE. Recommended use NoJoins 
        ///          (maxLevel=0) only.
        /// </summary>
        public static async Task<DynamicEntity> GetQnnFileTicketById(Guid id, EntityModel qnnFileTicketModel = null)
        {
            return await ORMUtils.GetEntityById(id, Constants.ModelName.QNN_FILE_TICKET, qnnFileTicketModel);
        }

        /// <summary>
        /// Syntactic sugar to get the QNN_FILE_TICKET model and use it to save/update the entity
        /// </summary>
        /// <param name="qnnFileTicket"></param>
        /// <returns></returns>
        /// <exception cref="ArgumentNullException"></exception>
        public static async Task<Guid> SaveFileTicket(DynamicEntity qnnFileTicket, EntityModel qnnFileTicketModel = null)
        {
            if (qnnFileTicket == null) throw new ArgumentNullException(nameof(qnnFileTicket));
            if(qnnFileTicketModel == null)
            {
                qnnFileTicketModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_FILE_TICKET, Constants.Level.NoJoins);
            }
            else
            {
                if (!Constants.ModelName.QNN_FILE_TICKET.Equals(qnnFileTicketModel.Name))
                    throw new ArgumentException($"Wrong model reference {qnnFileTicketModel.Name}", nameof(qnnFileTicketModel));
            }
            await qnnFileTicketModel.UpdateSingleAsync(qnnFileTicket);
            return (Guid)qnnFileTicket[Constants.FieldName.Id];
        }

        public static string GetToken(DynamicEntity qnnFileTicket)
        {
            if (qnnFileTicket == null) throw new ArgumentNullException(nameof(qnnFileTicket));
            Guid fileId = (Guid)qnnFileTicket[Constants.FieldName.FileId];
            return fileId.ToString("N");  //following example from ContentDbProvider
        }

        /// <summary>
        /// Returns the value of the Purpose attribute of the QNN_FILE_TICKET as a FileTicketPurpose
        /// (Converting it from the string that is stored in the Entity)
        /// </summary>
        /// <param name="qnnFileTicket">the QNN_FILE_TICKET entity</param>
        /// <returns>purpose</returns>
        /// <exception cref="InvalidOperationException">if the column value is not a valid FileTicketPurpose</exception>
        public static FileTicketPurpose GetPurpose(DynamicEntity qnnFileTicket)
        {
            if (qnnFileTicket == null) throw new ArgumentNullException(nameof(qnnFileTicket));
            string purposeString = (string)qnnFileTicket[Constants.FieldName.Purpose];
            if (!Enum.TryParse(purposeString, out FileTicketPurpose purpose))
                throw new InvalidOperationException($"Invalid {Constants.FieldName.Purpose} value:{purposeString}");
            return purpose;
        }

        public static bool IsEnabled(DynamicEntity qnnFileTicket)
        {
            if (qnnFileTicket == null) throw new ArgumentNullException(nameof(qnnFileTicket));
            return (bool)qnnFileTicket[Constants.FieldName.IsEnabled];
        }

        public enum TicketValidity { Valid, Unauthorised, Expired, Disabled }

        /// <summary>
        /// Will verify if the ticket is valid for the specified user at the current time. 
        /// (First reason found for invalidity will be logged at debug level).
        /// This does not check the 'Purpose' (caller should do that themselves if required)
        /// </summary>
        /// <param name="qnnFileTicket">the file ticket entity</param>
        /// <param name="checkForUser">user to check validity for</param>
        /// <returns>true if valid for that user, false if not</returns>
        public static async Task<TicketValidity> IsTicketValidForUser(
            DynamicEntity qnnFileTicket, 
            Clover.Core.Security.User checkForUser)
        {
            if (qnnFileTicket == null) throw new ArgumentNullException(nameof(qnnFileTicket));
            if (checkForUser == null) throw new ArgumentNullException(nameof(checkForUser));

            Guid ticketId = (Guid)qnnFileTicket[Constants.FieldName.Id];
            bool debugLoggingEnabled = logger.IsEnabled(LogLevel.Debug);

            //Reject if the user is not enabled
            if(checkForUser.IsLocked)
            {
                if (debugLoggingEnabled)
                    logger.LogDebug(nameof(IsTicketValidForUser) + " - ticket {0} is invalid for {1} ({2}) because this user is locked", ticketId, checkForUser.Id, checkForUser.Name);
                return TicketValidity.Unauthorised;
            }

            //Reject tickets that are not enabled 
            bool isEnabled = (bool)qnnFileTicket[Constants.FieldName.IsEnabled];
            if (!isEnabled)
            {
                if (debugLoggingEnabled)
                    logger.LogDebug(nameof(IsTicketValidForUser) + " - ticket {0} is invalid for {1} ({2}) because it is not enabled", ticketId, checkForUser.Id, checkForUser.Name);
                return TicketValidity.Disabled;
            }

            //Reject expired tickets
            DateTime? expiryDate = (DateTime?)qnnFileTicket[Constants.FieldName.ExpiryDate];
            if (expiryDate != null && expiryDate < DateTime.Now)
            {
                if (debugLoggingEnabled)
                    logger.LogDebug(nameof(IsTicketValidForUser) + " - ticket {0} is invalid for {1} ({2}) because it expired on {3}", ticketId, checkForUser.Id, checkForUser.Name, expiryDate);
                return TicketValidity.Expired;
            }                

            //Reject if ticket is for another user
            Guid? restrictedToUserId = (Guid?)qnnFileTicket[Constants.FieldName.RestrictedToUserId];
            if (restrictedToUserId != null && restrictedToUserId != checkForUser.Id)
            {
                if (debugLoggingEnabled)
                    logger.LogDebug(nameof(IsTicketValidForUser) + " - ticket {0} is invalid for {1} ({2}) because it is restricted to user {3}", ticketId, checkForUser.Id, checkForUser.Name, restrictedToUserId);
                return TicketValidity.Unauthorised;
            }
                
            //Reject if user doesn't have any of the permitted roles listed on the ticket
            string restrictedToRolesCommaDelimited = (string)qnnFileTicket[Constants.FieldName.RestrictedToRoles];
            if(!string.IsNullOrEmpty(restrictedToRolesCommaDelimited))
            {
                IEnumerable<string> restrictedToRoles = restrictedToRolesCommaDelimited.Split(',');
                if (!restrictedToRoles.Any(restrictedToRole => checkForUser.IsInRole(restrictedToRole)))
                {
                    if (debugLoggingEnabled)
                        logger.LogDebug(nameof(IsTicketValidForUser) + " - ticket {0} is invalid for {1} ({2}) because it is restricted to roles {1}", ticketId, checkForUser.Id, checkForUser.Name, restrictedToRolesCommaDelimited);
                    return TicketValidity.Unauthorised;
                }
            }

            //Reject if the ticket is for an organisation the user doesn't have access to
            Guid? structDivisionId = (Guid?)qnnFileTicket[Constants.FieldName.StructDivisionId];
            if(structDivisionId != null)
            {
                HashSet<Guid> usersStructDivisions = await StructDivision.SelectChildrenAndThisIdSetAsync(checkForUser);
                if (!usersStructDivisions.Contains(structDivisionId.Value))
                {
                    if (debugLoggingEnabled)
                        logger.LogDebug(nameof(IsTicketValidForUser) + " - ticket {0} is invalid for {1} ({2}) because it is restricted to StructDivisionId {1}", ticketId, checkForUser.Id, checkForUser.Name, structDivisionId);
                    return TicketValidity.Unauthorised;
                }
            }

            //Success!
            if (debugLoggingEnabled)
                logger.LogDebug(nameof(IsTicketValidForUser) + " - ticket {0} referring to file {1} is valid for user {2} ({3})", ticketId, (Guid)qnnFileTicket[Constants.FieldName.FileId], checkForUser.Id, checkForUser.Name);
            return TicketValidity.Valid;
        }

        /// <summary>
        /// Return a download link URL for the file ticket.
        /// (Note that the ticket must have been saved already as it needs to have an Id assigned to build the link)
        /// </summary>
        /// <param name="ticket">the QNN_FILE_TICKET</param>
        /// <returns>url</returns>
        public static async Task<string> GetLink(DynamicEntity ticket)
        {
            if (ticket == null) throw new ArgumentNullException(nameof(ticket));
            return await GetLink((Guid)ticket[Constants.FieldName.Id]);
        }

        /// <summary>
        /// Return a download link URL for the file ticket.
        /// </summary>
        /// <param name="ticketId">Id of the QNN_FILE_TICKET (not validated)</param>
        /// <returns>url</returns>
        public static async Task<string> GetLink(Guid ticketId)
        {
            string intranetDomainAuthority
                = await SettingsHelper.Common.GetIntranetDomainAuthority();
            if (string.IsNullOrEmpty(intranetDomainAuthority))
                throw new InvalidOperationException("IntranetDomainAuthority is not configured");
            //TicketId is a Guid so it doesn't need url encoding
            string url = $"{Constants.MailLinksProtocol}{intranetDomainAuthority}{Constants.IntranetRoutes.FileTicketDownload}"
                .Replace("{ticket}", ticketId.ToString());
            return url;
        }

        /// <summary>
        /// Find expired tickets and delete them, will also delete the associated file if IsDeleteFileOnExpiry set
        /// (This would typically be called by the hangfire job BusinessProcess.CleanupExpiredFileTickets)
        /// </summary>
        public static async Task CleanupExpiredTickets()
        {
            try
            {
                DateTime now = DateTime.Now;
                if (logger.IsEnabled(LogLevel.Trace))
                    logger.LogTrace(nameof(CleanupExpiredTickets) + " - checking for file tickets expiring <= {0}", now);

                EntityModel qnnFileTicketModel
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_FILE_TICKET, Constants.Level.NoJoins);
                Filter byExpired = Filter.And.LessOrEqual(now, Constants.FieldName.ExpiryDate);
                Order orderByExpiryDate = Order.StartAsc(Constants.FieldName.ExpiryDate);
                List<DynamicEntity> expiredTickets
                    = await qnnFileTicketModel.GetAsync(byExpired, orderByExpiryDate, Paging.Empty);
                if(expiredTickets.Any())
                {
                    logger.LogInformation(nameof(CleanupExpiredTickets) + " - cleaning up {0} expired tickets", expiredTickets.Count);
                    //We will loop the list of tickets and handle each individually so that we can catch and log on an individual basis.
                    foreach (DynamicEntity ticket in expiredTickets)
                    {
                        Guid ticketId = (Guid)ticket[Constants.FieldName.Id];
                        try
                        {
                            
                            if(logger.IsEnabled(LogLevel.Debug))
                            {
                                logger.LogDebug(nameof(CleanupExpiredTickets) + " - cleaning up ticket, Id={0}, CreatedDate={1}, ExpiryDate={2}, IsDeleteFileOnExpiry={3}, FileId={4}", ticketId, (DateTime)ticket[Constants.FieldName.CreatedDate] , (DateTime?)ticket[Constants.FieldName.ExpiryDate], (bool)ticket[Constants.FieldName.IsDeleteFileOnExpiry], (Guid)ticket[Constants.FieldName.FileId]);
                            }
                                
                            bool isDeleteFile = (bool)ticket[Constants.FieldName.IsDeleteFileOnExpiry];
                            if (isDeleteFile)
                            {
                                string token = FileTicketApplication.GetToken(ticket);
                                bool success = await CloverRuntime.ContentProvider.RemoveAsync(token);
                                if (!success) throw new InternalException($"IContentProvider.RemoveAsync returned false for token {token}");
                            }
                            else
                            {
                                long count = await qnnFileTicketModel.DeleteAsync(new object[] { ticket[Constants.FieldName.Id] });
                                if(count != 1) throw new InternalException($"EntityModel.DeleteAsync returned {count} for ticket {ticketId}");
                            }
                        }
                        catch (Exception e)
                        {
                            //Log any error and continue on with the next ticket without exit
                            logger.LogError(e, nameof(CleanupExpiredTickets) + " - caught exception cleaning up expired ticket {0}", ticketId);
                        }
                    } //end foreach ticket
                }
                else
                {
                    if (logger.IsEnabled(LogLevel.Trace))
                        logger.LogTrace(nameof(CleanupExpiredTickets) + " - no expired tickets to clean up");
                }
            }
            catch(Exception e)
            {
                logger.LogDebug(e, nameof(CleanupExpiredTickets) + " - caught unexpected exception");
                throw new Exception("Unexpected exception cleaning up expired tickets", e);
            }
        }

        /// <summary>
        /// Copy the specified file to the database and then delete it from the file system. Issue a file ticket for the file
        /// based on the supplied builder. (The token will be specified for you when the ticket is built).
        /// The content type for the file will be guessed from its extension using some simple heuristics.
        /// </summary>
        public static async Task<DynamicEntity> MoveFileToDatabaseAndIssueTicket(FileInfo file, FileTicketBuilder ticketBuilder)
        {
            if (file == null) throw new ArgumentNullException("required", nameof(file));
            if (ticketBuilder == null) throw new ArgumentNullException("required", nameof(ticketBuilder));
            if (!file.Exists) throw new NotFoundException(file.FullName);
            string fileContentType = FileUtils.GuessContentType(file.Name);
            using (SharedTransaction shared = new SharedTransaction())
            {
                try
                {
                    long size = file.Length; //grab now so can use after deleting file
                    if (logger.IsEnabled(LogLevel.Trace))
                    {
                        logger.LogTrace(nameof(MoveFileToDatabaseAndIssueTicket) + " - FullName={0}, size={1}", file.FullName, size);
                    }

                    shared.BeginTransactionAsync().Wait();
                    Dictionary<string, string> properties = new Dictionary<string, string>();
                    properties.Add(Constants.FileProperties.Name, file.Name); //Don't use fullname here, just the filename
                    properties.Add(Constants.FileProperties.ContentType, fileContentType);

                    Guid ticketId;
                    DynamicEntity ticket;                    
                    using (Stream stream = file.OpenRead())
                    {
                        string token = await CloverRuntime.ContentProvider.AddAsync(stream, properties);
                        ticket = await ticketBuilder.Build(token);
                        ticketId = await FileTicketApplication.SaveFileTicket(ticket);
                    }
                    file.Delete();
                    shared.Commit();
                    if (logger.IsEnabled(LogLevel.Information))
                    {
                        logger.LogInformation(nameof(MoveFileToDatabaseAndIssueTicket) + " - moved {0} to database with token {1} and issued ticket {2}, size={3}", file.FullName, (Guid)ticket[Constants.FieldName.FileId], ticketId, size);
                    }                        
                    return ticket;
                }
                catch (Exception e)
                {
                    await shared.RollbackAsync().ConfigureAwait(false);
                    throw new InternalException($"Error moving file to database and creating ticket, FullName={file.FullName}", e);
                }
            } //end using tx
        }
    }
}
