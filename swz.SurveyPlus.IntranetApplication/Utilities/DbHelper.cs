using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using swz.SurveyPlus.Application;

namespace swz.SurveyPlus.IntranetApplication.Utilities
{
    public static class DbHelper
    {
        private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(DbHelper));

        /// <summary>
        /// This global flag is a kludge that should only be set at startup and not modified after that.
        /// It will be checked in BulkCopyDataTable (and potentially other places that use SqlBulkCopy) to
        /// determine whether or not to override the default behaviour of SqlBulkCopy which is *not* to
        /// enforce constraints. See issue #267 for more details.
        /// </summary>
        public static bool Global_IsSqlBulkCopy_CheckConstraints = false; //default to false to match legacy behaviour (for now)

        /// <summary>
        /// Bulk insert using Clover ORM
        /// Caller is responsible for audit logging
        /// nb: exceptions are logged at debug level and rethrown as the caller is responsible for their handling
        /// </summary>
        public static async Task<(long updated, long inserted)> BulkDataUpdate(
            List<DynamicEntity> data,
            EntityModel model)
        {
            //TODO - need a way to pass the ORM our EventBatch for audit when we update these
            //       I believe it does have them share an eventbatch for all the audit entries that
            //       result from the same call to UpdateAsync(), but this is usually part of a larger 'event'

            if (data == null) throw new ArgumentNullException(nameof(data));
            if (model == null) throw new ArgumentNullException(nameof(model));
            
            if (!data.Any())
            {
                if (Logger.IsEnabled(LogLevel.Debug)) Logger.LogTrace(nameof(BulkDataUpdate) + " - no data to update for modelName={0}", model?.Name);
                return (0, 0);
            }
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                long totalUpdated = 0, totalInserted = 0;
                if (Logger.IsEnabled(LogLevel.Debug))
                {
                    Logger.LogDebug(nameof(BulkDataUpdate) + " - updating {0} entities in {1}", data?.Count, model?.Name);
                }
                const int take = 500; //number to process in one go
                if (data.Count > int.MaxValue - take) throw new Exception("data is too large"); //TODO - think can lose this line yeah?
                for (int skip = 0; skip < data.Count; skip = skip + take)
                {
                    List<dynamic> entities = data.Skip(skip).Take(take).Cast<dynamic>().ToList();
                    if (Logger.IsEnabled(LogLevel.Trace))
                    {
                        Logger.LogTrace(nameof(BulkDataUpdate) + " - calling update for skip={0}, entities.Count={1}, totalInserted={2}, totalUpdated={3}", skip, entities?.Count, totalInserted, totalInserted);
                    }
                    (long inserted, long updated) result = await model.UpdateAsync(entities);
                    totalInserted += result.inserted;
                    totalUpdated += result.updated;
                }
                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                if(Logger.IsEnabled(LogLevel.Debug))
                {
                    Logger.LogDebug(nameof(BulkDataUpdate) + " - completed for {0} entities in {1}, totalInserted={2}, totalUpdated={3}, duration={4} ms", data?.Count, model?.Name, totalInserted, totalUpdated, duration);
                }
                return (totalUpdated, totalInserted);
            }
            catch (Exception e)
            {
                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                Logger.LogDebug(e, nameof(BulkDataUpdate) + " - caught an unexpected exception, modelName={0}, duration={1}", model?.Name, duration);
                throw; //preserve original exception rather than wrapping with a new type
            }
        }

        /// <summary>
        /// Marshalls troubleshooting information about an error doing a bulk copy.
        /// </summary>
        public class BulkCopyException : Exception
        {
            private static string Details(int count, DataTable table, Exception innerException)
            {
                StringBuilder detailsBuffer = new StringBuilder();
                try
                {                    
                    detailsBuffer.Append($"Bulk copy failed for TableName={table?.TableName}, data.Count={count}, ");
                    if (table == null)
                    {
                        detailsBuffer.Append("table is null, ");
                    }
                    else
                    {
                        detailsBuffer.Append("Columns=[");
                        for (int i = 0; i < table.Columns.Count; i++)
                        {
                            detailsBuffer.Append(table.Columns[i].ColumnName);
                            detailsBuffer.Append(" (");
                            detailsBuffer.Append(table.Columns[i].DataType.Name);
                            detailsBuffer.Append(")");
                            if (i + 1 < table.Columns.Count)
                                detailsBuffer.Append(", ");
                        }
                        detailsBuffer.Append("], ");
                    }
                    detailsBuffer.Append("Message=");
                    detailsBuffer.Append(innerException?.Message);
                    return detailsBuffer.ToString();
                }
                catch (Exception e)
                {
                    Logger.LogError(e, nameof(Details) + " - caught unexpected exception collating error details for use in " + nameof(BulkCopyException) + ", detailsBuffer={0}", detailsBuffer?.ToString());
                    if(innerException != null)
                    {
                        Logger.LogInformation(innerException, nameof(Details) + " - innerException that was passed");
                    }
                    return "(Error collating error details)";
                }
            }

            public BulkCopyException(List<IDictionary<string, object>> data, DataTable table, Exception innerException)
                : base(Details(data.Count, table, innerException), innerException) { }

            public BulkCopyException(DataTable table, Exception innerException)
                : base(Details(table?.Rows?.Count ?? -1, table, innerException), innerException) { }
        }

        /// <summary>
        /// Bulk insert using SqlBulkCopy. 
        /// This method uses the connection taken from the specified SharedTransaction object.
        /// The data in the table is expected to be added to the table already and WILL set KeepNulls.
        /// Caller is responsible for any audit logging required (you may wish to use 
        /// SurveyPlusAuditHelper.SerialiseDataTableToJson + SurveyPlusAuditHelper.BatchImport to 
        /// assist with this).
        /// 
        /// Any exceptions caught are logged at debug level and rethrown wrapped in a BulkCopyException
        /// 
        /// Note: It is not necessary to begin the transaction (but its connection must be opened), 
        ///       but if the transaction is started it will be used. 
        ///       To use SharedTransaction to open a connection without starting a transaction 
        ///       you can use the following syntax: 
        ///       
        ///         using (SharedTransaction forConnection = new SharedTransaction())
        ///         {
        ///             await forConnection.OpenConnectionAsync();
        ///             DbHelper.BulkCopyDataTable(myTable, forConnection, timeoutSeconds: 120);
        ///         }
        /// </summary>
        public static void BulkCopyDataTable(
            DataTable table,
            SharedTransaction transaction,
            int timeoutSeconds=90)
        {
            if (table == null) throw new ArgumentNullException(nameof(table));
            if (transaction == null) throw new ArgumentNullException(nameof(transaction));
            if (string.IsNullOrEmpty(table.TableName)) throw new ArgumentException("TableName not specified", nameof(table)); 
            //Transaction does not need to be started, but its connection does need to be open
            SqlConnection sqlConnection 
                = transaction.Connection as SqlConnection
                ?? throw new ArgumentException($"Connection property is null in {nameof(SharedTransaction)}", nameof(transaction));

            //If a transaction has not actually been started then the below may be null. If not null then the bulk
            //copy will be performed in the context of the transaction. Be careful with using transactions for huge
            //operations as the lock escalation involved can block everything else until it is done which can have very
            //bad effects on the system useability.
            SqlTransaction sqlTransaction = (SqlTransaction)transaction.Transaction; 

            int count = table.Rows.Count;
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            try
            {
                int batchSize = (count <= 7500) ? count : 5000;
                List<string> columnNames = ColumnNames(table);
                if (Logger.IsEnabled(LogLevel.Trace))
                {
                    Logger.LogTrace(nameof(BulkCopyDataTable) + " - copying {0} rows to {1} with columns {2}, using batchSize={3}",
                        count, table.TableName, columnNames, batchSize);
                }

                if (table.Rows.Count == 0)
                {
                    if (Logger.IsEnabled(LogLevel.Debug))
                    {
                        Logger.LogDebug(nameof(BulkCopyDataTable) + " - no data to copy to {0}", table.TableName);
                    }
                    return;
                }

                SqlBulkCopyOptions copyOptions
                    = Global_IsSqlBulkCopy_CheckConstraints
                    ? SqlBulkCopyOptions.KeepNulls | SqlBulkCopyOptions.CheckConstraints //10
                    : SqlBulkCopyOptions.KeepNulls; //8

                using (SqlBulkCopy sqlCopy = new SqlBulkCopy(
                    connection: sqlConnection,
                    copyOptions: copyOptions, 
                    externalTransaction: sqlTransaction))
                {
                    foreach (string name in columnNames)
                    {
                        sqlCopy.ColumnMappings.Add(name, name);
                    }
                    sqlCopy.DestinationTableName = table.TableName;
                    sqlCopy.BatchSize = batchSize;
                    sqlCopy.BulkCopyTimeout = timeoutSeconds;
                    sqlCopy.WriteToServer(table);
                }
                if (Logger.IsEnabled(LogLevel.Debug))
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    Logger.LogDebug(nameof(BulkCopyDataTable) + " - copied {0} rows to {1} with columns {2} and copyOptions={3} in {4} milliseconds", count, table.TableName, columnNames, copyOptions, duration);
                }
            }
            catch (Exception e)
            {
                if (Logger.IsEnabled(LogLevel.Debug))
                {
                    long duration = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start;
                    Logger.LogDebug(e, nameof(BulkCopyDataTable) + " caught an unexpected exception for TableName={0}, data.Count={1}, duration={2}",
                    table?.TableName, count, duration);
                }
                throw new BulkCopyException(table, e);
            }
        }

        /// <summary>
        /// Create a new row for the specified table and copy column values from the dictionary.
        /// Will use DBNull for null or missing values in the dictionary.
        /// (Does not add the row to the table, caller is responsible for that)
        /// </summary>
        /// <param name="table"></param>
        /// <param name="row"></param>
        /// <returns></returns>
        public static DataRow CreateRow(DataTable table, IDictionary<string,object> row)
        {
            DataRow newRow = table.NewRow();
            foreach (string columnName in row.Keys)
            {
                if (table.Columns.Contains(columnName))
                {
                    newRow[columnName] = row.ContainsKey(columnName) 
                        ? row[columnName]??DBNull.Value
                        : DBNull.Value;
                }
            }
            return newRow;
        }

        /// <summary>
        /// Syntactic sugar to get the column names from a DataTable
        /// </summary>
        /// <param name="table"></param>
        /// <returns>column names</returns>
        public static List<string> ColumnNames(DataTable table)
        {
            if (table == null) throw new ArgumentNullException(nameof(table));
            //see: https://stackoverflow.com/questions/237201/querying-datacolumncollection-with-linq
            return table.Columns.Cast<DataColumn>().Select(column => column.ColumnName).ToList();
        }

        /// <summary>
        /// Examines the exception and inner exceptions and will use some heuristics to decide if its worth
        /// retrying the transaction (unit of work) that failed. Be sure that the original transaction is rolled
        /// back properly before retrying and that all relevent non-database state has been rolled back appropriately.
        /// </summary>
        public static bool IsTransactionRetryable(Exception e)
        {
            if (e == null) return false;
            if (e is SqlException sqlEx)
            {
                //A note on CommandTimeout
                //it isn't simply the duration we wait for it to finish. 
                //i.e. basically if sql server is actually doing stuff it can take longer.
                //  "This property is the cumulative time-out (for all network packets that are read during the invocation of a method)
                //  for all network reads during command execution or processing of the results.
                //  A time-out can still occur after the first row is returned, and does not include user processing time,
                //  only network read time."
                //see: https://learn.microsoft.com/en-us/dotnet/api/microsoft.data.sqlclient.sqlcommand.commandtimeout
                //see also: https://github.com/dotnet/SqlClient/issues/1764

                switch (sqlEx.Number)
                {
                    //see: https://stackoverflow.com/questions/29664/how-to-catch-sqlserver-timeout-exceptions
                    case -2:    //timeout
                    case 1:     //network error              
                        return true;

                    case 1205:  //deadlock (here sql server will have rolled back the transaction already)                    
                        return true;

                    case 50000: //raiserror
                        return (e.Message != null) && e.Message.StartsWith(Constants.Message.Prefix.ClientRetryable);

                    default:
                        return false; //stop now instead of trying inner exceptions since this is an sql exception already
                }
            }
            if (e.InnerException != null)
                return IsTransactionRetryable(e.InnerException); //recurse the exception chain
            else
                return false;
        }

        /// <summary>
        /// Don't use IsStatementRetryable any more. TODO - remove any existing uses 
        /// and refactor the affected code to do transaction level retries instead
        /// </summary>
        [Obsolete("Retry should be performed at transaction level")]
        public static bool IsStatementRetryable(Exception e)
        {
            if (e == null) return false;
            if (e is SqlException sqlEx)
            {
                switch (sqlEx.Number)
                {
                    case -2:    //timeout
                    case 1:     //network error              
                        return true;

                    //We won't support the client retryable message here, nor deadlocks

                    default:
                        return false; //stop now instead of trying inner exceptions since this is an sql exception already
                }
            }
            if (e.InnerException != null)
                return IsStatementRetryable(e.InnerException); //recurse the exception chain
            else
                return false;
        }

        /// <summary>
        /// If value is DBNull or null return null (otherwise return it unchanged)
        /// </summary>
        /// <param name="value">value (which might or might not be a DBNull object)</param>
        /// <returns>value or null</returns>
        public static object DBNullToNull(object value)
        {
            return (DBNull.Value.Equals(value) || value == null) ? null : value;
        }

        public class UnexpectedTransactionFoundException : Exception
        {
            public SharedTransaction Shared { get; private set; }

            public UnexpectedTransactionFoundException(SharedTransaction shared, string message) 
                : base(message)
            {
                this.Shared = shared;
            }
        }

        //TODO - consider making this an instance method of SharedTransaction (implies change to core)
        public static void AssertTransactionNotStartedYet(SharedTransaction shared, string messageIfPresent)
        {
            if (messageIfPresent == null) throw new ArgumentNullException(nameof(messageIfPresent));
            if (shared == null) throw new ArgumentNullException(nameof(shared));
            //Its internal tx reference is set in BeginTransactionAsync and cleared in RollbackAsync
            //so we will use this to check. We DON't try to check the validity of the transaction object
            //if it is present. We will just assume its presence indicates the transaction has already begun.
            bool isTransactionAlreadyPresent = shared.ConnectionAndTransaction?.Transaction != null;
            if (isTransactionAlreadyPresent)
            {
                throw new UnexpectedTransactionFoundException(shared, messageIfPresent);
            }
        }

        public class UnexpectedTransactionAbsenceException : Exception
        {
            public SharedTransaction Shared { get; private set; }

            public UnexpectedTransactionAbsenceException(SharedTransaction shared) 
                : base("A transaction was expected but not found")
            {
                this.Shared = shared;
            }
        }

        public static void AssertTransactionStartedAlready(SharedTransaction shared)
        {
            if (shared == null) throw new ArgumentNullException(nameof(shared));
            //Its internal tx reference is set in BeginTransactionAsync and cleared in RollbackAsync
            //so we will use this to check. We DON't try to check the validity of the transaction object
            //if it is present. We will just assume its presence indicates the transaction has already begun.
            bool isTransactionAbsent = shared.ConnectionAndTransaction?.Transaction == null;
            if (isTransactionAbsent)
            {
                throw new UnexpectedTransactionAbsenceException(shared);
            }
        }
    }
}
