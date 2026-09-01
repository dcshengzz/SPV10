using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public static class spSP_GetDplyUploadedFiles
    {
        public class DbFile
        {
            public string Token { get; private set; }

            public string Filename { get; private set; }

            public DbFile(string token, string filename)
            {
                if (string.IsNullOrEmpty(token)) throw new ArgumentException(nameof(token));
                if (string.IsNullOrEmpty(filename)) throw new ArgumentException(nameof(filename));
                this.Token = token;
                this.Filename = filename;
            }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetDplyUploadedFiles));

        public static async Task<bool> HasAnyUploadedFiles(Guid dplyId)
        {
            try
            {
                List<Dictionary<string, object>> dbFiles = await Execute(dplyId);
                bool isAny = dbFiles.Any();
                return isAny;
            }
            catch(Exception e)
            {
                logger.LogDebug(e, nameof(HasAnyUploadedFiles) + " - caught unexpected exception for dplyId={0}", dplyId);
                throw;
            }            
        }

        public static async Task<List<DbFile>> GetUploadedFilenames(Guid dplyId)
        {
            List<Dictionary<string, object>> rows = await Execute(dplyId);
            List<DbFile> files 
                = rows.Select(row => new DbFile((string)row[Constants.FieldName.Token], (string)row[Constants.FieldName.Filename]))
                .ToList();
            return files;
        }

        public static async Task<List<Dictionary<string, object>>> Execute(Guid dplyId)
        {
            try
            {
                List<Dictionary<string, object>> rows =
                await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(  //TODO - does this really need Extended 3600s timeout?????
                    Constants.StoredProcedure.spSP_GetDplyUploadedFiles,
                    new Dictionary<string, object>()
                    {
                        {"DplyId", dplyId}
                    },
                    new Dictionary<string, object>());
                return rows;
            }
            catch (Exception e)
            {
                logger.LogDebug(e, nameof(Execute) + " - caught unexpected exception for dplyId={0}", dplyId);
                throw;
            }
        }
    }
}
