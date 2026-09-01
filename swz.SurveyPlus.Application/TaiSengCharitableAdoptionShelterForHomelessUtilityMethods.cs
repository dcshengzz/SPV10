using CsvHelper;
using CsvHelper.TypeConversion;
using Microsoft.Extensions.Logging;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Security;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;
using System.Threading.Tasks;

namespace swz.SurveyPlus.Application
{
    

    /// <summary>
    /// A place to TEMPORARILY house random utility methods that have been moved along from places they don't belong
    /// until they can find their Forever Home. Unprofessional class name is quite deliberate. 
    /// I don't want stuff hanging around in here permanently thank you!
    /// 
    /// Where to find them now:
    ///     EncryptionHelper:
    ///         RandomAlphanumericString (f.k.a. randomString)
    ///     ConversionUtils:
    ///         IsTrueYN
    ///         IsValidTrueYN
    ///         TryParseCommaDelimitedGuids
    ///     SettingsHelper.Common:
    ///         GetIntranetDomainAuthority
    ///         GetInternetDomainAuthority
    ///         GetApplicationName
    ///     FileUtils:
    ///         CombineWithPath
    ///         GuessContentType
    /// 
    /// </summary>
    public static class TaiSengCharitableAdoptionShelterForHomelessUtilityMethods
    {
        //n.b don't give this class its own logger, let's have callers pass their own to methods that log
        //and when methods here find their forever-home they can be changed to use the logger there

        /// <summary>
        /// Returns true if the provided sample UID is swzanonymous
        /// (case insensitive)
        /// </summary>
        public static bool IsAnonymousSample(string uid)
        {
            return Constants.SwzAnonymous.Uid.Equals(uid, StringComparison.OrdinalIgnoreCase);
        }

        //For INTRANET application use only!
        /// <summary>
        /// Applies some basic heuristics against a CSV file uploaded by an intranet user for processing.
        /// (i.e. sample lists, pre-pop or response uploads, etc)
        /// This is basically to check that the token provided really does refer to a CSV type file uploaded by the
        /// specified user. These checks are expected to pass, if they fail then an exception is thrown.
        /// Type checks will throw InvalidUploadedFileException, caller can probably assume token is legit (and choose to
        /// delete the file).
        /// Checks that suggest token refers to a file that was not uploaded by the user will throw a PermissionException.
        /// Note that these checks cannot be comprehensive wrt to that.
        /// Calling code should not reveal the exception message to clientside unless it has the Client_Reportable prefix.
        /// Note that this method does not open and examine the actual content of the file.
        /// </summary>
        public static async Task AssertUploadedCsvAttributes(ILogger logger, string token, User uploader)
        {
            //Code in this method moved and adapted for general-purpose use
            //from ListController.ParseAndDeleteSampleListCsv 20240720

            if (logger == null)
                throw new ArgumentNullException(nameof(logger));
            if (!Guid.TryParse(token, out Guid dwUploadedFileId))
                throw new ArgumentException("Invalid token (token format)", nameof(token));
            if (uploader == null)
                throw new ArgumentNullException(nameof(uploader));

            //Fetch it outside the try/catch in case it fails as the catch expects an exception because of invalidity
            UploadedFilesPoor uploadedFile = await UploadedFilesPoor.SelectByKey(dwUploadedFileId);
            if (uploadedFile == null)
                throw new NotFoundException($"Failed to find file via {nameof(UploadedFilesPoor)} with Id={dwUploadedFileId}", dwUploadedFileId);

            try
            {
                //1. Heuristics to rule out tokens that clearly arent something uploaded by the current user:

                string createdBy = (uploadedFile.CreatedBy?.Trim()) ?? ""; //dwUploadedFiles.CreatedBy was nchar(1024) so had 1kb of garbage whitespace in there last time, now trimming is not so important

                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(AssertUploadedCsvAttributes) + " - token={0}, uploader={1}, uploader.Id={2}, contentType={3}, length={4}, name={5}, createdBy={6} (trimmed), createdDate={7}", token, uploader.Name, uploader.Id, uploadedFile.ContentType, uploadedFile.AttachmentLength, uploadedFile.Name, createdBy, uploadedFile.CreatedDate);
                }

                if (!uploader.Name.Equals(createdBy))
                {
                    throw new PermissionException($"File {dwUploadedFileId} was uploaded by \"{createdBy}\" and not by \"{uploader.Name}\")");
                }

                if (!uploadedFile.StructDivisionId.Equals(uploader.StructDivisionId))
                    throw new PermissionException($"File {dwUploadedFileId} structDivisionId={uploadedFile.StructDivisionId} but uploader structDivisionId={uploader.StructDivisionId}");

                //20240720 - have removed the time check here since this code is now being made more general-purpose so file could
                //           sit around a long time waiting for a scheduled job

                //Heuristic to rule out tokens that aren't legit. CSV uploads for processing won't be marked local storage.
                if (uploadedFile.IsLocalStorage)
                    throw new PermissionException("File is marked as IsLocalStorage");


                //2. Checks for legitimate file type:

                //(TODO make the type passed in so we can use for other things)

                //We expect the file to have the following properties and consider it an error if it does not
                if (string.IsNullOrWhiteSpace(uploadedFile.Name))
                    throw new InvalidUploadedFileException($"{Constants.Message.Prefix.ClientReportable}File has no filename", token);

                //We now do check for the csv extension (previously did not)
                string extension = Path.GetExtension(uploadedFile.Name);
                if (!Constants.Comparers.ObjectNameCaseInsensitive.Equals(extension,".csv"))
                {
                    logger.LogError(nameof(AssertUploadedCsvAttributes) + " - found invalid name extension for token={1}, filename={2}", token, uploadedFile.Name);
                    throw new InvalidUploadedFileException($"{Constants.Message.Prefix.ClientReportable}Not a CSV file (does not have .csv extension)", token);
                }
                    
                if (!"text/csv".Equals(uploadedFile.ContentType)
                    && !"text/plain".Equals(uploadedFile.ContentType)
                    && !("application/octet-stream").Equals(uploadedFile.ContentType))
                {
                    logger.LogError(nameof(AssertUploadedCsvAttributes) + " - found content-type {0} for token={1}, filename={2}", uploadedFile.ContentType, token, uploadedFile.Name);
                    throw new InvalidUploadedFileException($"{Constants.Message.Prefix.ClientReportable}Not a CSV file (invalid content-type)", token);
                }
            }
            catch(Exception e)
            {
                logger.LogError(nameof(AssertUploadedCsvAttributes) + " - failed for token={0}, uploader={1} ({2}), message={3}", token, uploader?.Id, uploader?.Name, e?.Message);
                throw;
            }
        }

        /// <summary>
        /// If the message is client reportable will return the reportable part of the message, otherwise returns
        /// the specified fallbackMessage
        /// </summary>
        /// <param name="message">the message to check (null is allowed)</param>
        /// <param name="fallBackMessage">the message to return if not client reportable (null is allowed)</param>
        /// <returns>reportable message or null</returns>
        public static string ClientReportableMessage(string message, string fallbackMessage)
        {
            return 
                (!string.IsNullOrWhiteSpace(message) && message.StartsWith(Constants.Message.Prefix.ClientReportable))
                ? message.Substring(Constants.Message.Prefix.ClientReportable.Length)
                : fallbackMessage;
        }

        //TODO - this would ideally belong in ResponseApplication but I need to call it from ListSampleInfo
        //       which is shared by both internet and intranet
        /// <summary>
        /// True if the completionDate meets the DaysUpdate constraint.
        /// Pass in the timestamp indicating the point of time the comparison is being performed for (i.e. DateTime.Now)
        /// If there is no completionDate (response not completed) then will return false.
        /// </summary>
        public static bool IsWithinDaysUpdateAfterCompletion(DateTime timestamp, int? daysUpdate, DateTime? completionDate)
        {
            if (completionDate == null) return false;
            bool isDaysUpdateUnlimited = (Constants.Unlimited == (daysUpdate ?? Constants.Unlimited));
            if (isDaysUpdateUnlimited)
            {
                return true;
            }
            else
            {
                //nb: we don't round away the hours, so one day will be 24 hours for this calculation
                //adjust the completion date for the comparison
                DateTime effectiveTimestamp = timestamp.AddDays(0 - daysUpdate.Value);
                bool result = effectiveTimestamp < completionDate;
                return result;
            }
        }

        /// <summary>
        /// Render the data to a new MemoryStream in CSV format (using InvariantCulture but with 
        /// Constants.QnnDatetimeFormat for DateTimes (an iso-like format that includes seconds)).
        /// The MemoryStream is rewound to the start before being returned.
        /// Although a moot point for MemoryStream, it is considered the caller's responsibility to close it.
        /// </summary>
        public static MemoryStream CsvMemoryStream(List<Dictionary<string, object>> data, IEnumerable<string> columns)
        {
            ArgumentNullException.ThrowIfNull(data, nameof(data));
            ArgumentNullException.ThrowIfNull(columns, nameof(columns));
            try
            {
                Encoding encoding = new UTF8Encoding(encoderShouldEmitUTF8Identifier: false);
                MemoryStream ms = new MemoryStream();
                using (StreamWriter writer = new StreamWriter(ms, encoding, bufferSize: 8192, leaveOpen: true))
                {

                    using (CsvWriter csv = new CsvWriter(writer, CultureInfo.InvariantCulture, leaveOpen: true))
                    {
                        //Use consistent date format
                        TypeConverterOptions options = new TypeConverterOptions { Formats = new[] { Constants.QnnDatetimeFormat } };
                        csv.Context.TypeConverterOptionsCache.AddOptions<DateTime>(options);
                        csv.Context.TypeConverterOptionsCache.AddOptions<DateTime?>(options);

                        //header row
                        foreach (string columnName in columns)
                            csv.WriteField(columnName);
                        //data rows
                        csv.NextRecord();
                        foreach (var row in data)
                        {
                            foreach (string columnName in columns)
                                csv.WriteField(row[columnName]);
                            csv.NextRecord();
                        }
                        csv.Flush();
                    }//end using CsvWriter
                    writer.Flush();
                }//end using StreamWriter
                ms.Seek(0, SeekOrigin.Begin);
                return ms;
            }
            catch (Exception e)
            {
                throw new InternalException($"Failed to generate CSV, columns={string.Join(',',columns)}", e);
            }
        }
    }
}
