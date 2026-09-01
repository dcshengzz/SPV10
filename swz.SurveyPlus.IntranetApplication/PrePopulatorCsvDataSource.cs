using CsvHelper;
using CsvHelper.Configuration;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Implementation of pre-populater data source to use when populating from a CSV file
    /// </summary>
    public class PrePopulatorCsvDataSource : PrePopulator.IDataSource
    {
        public static readonly string UID_COLUMN = "UID";

        /// <summary>
        /// Returns a new instance with an initialised logger. 
        /// You must pass a stream to the CSV file. Note that closing stream is callers responsibility.
        /// </summary>
        /// <param name="csvStream">closure of the stream is CALLER's responsibiliy</param>
        /// <returns>pre-pop datasource instance</returns>
        public static async Task<PrePopulatorCsvDataSource> NewInstance(Stream csvStream)
        {
            ILogger<PrePopulatorCsvDataSource> logger = (ILogger<PrePopulatorCsvDataSource>)DefaultApplicationLogging.CreateLogger<PrePopulatorCsvDataSource>();
            PrePopulatorCsvDataSource instance = new PrePopulatorCsvDataSource(logger, csvStream);
            await instance.Initialise();
            return instance;
        }

        private readonly ILogger<PrePopulatorCsvDataSource> logger;
        private readonly Stream csvStream;

        private bool disposedValue;
        private bool initialised = false;
        private int uidColumnIndex;
        private string uid = null;
        private int missingUidCount = 0;

        //The following are set in Initialise
        private CsvReader csv = null;
        private ImmutableList<string> headerRowColumns = null;
        private IDictionary<string, string> headerRowColumnLookup = null;

        /// <summary>
        /// Private constructor, please use factory method to create a properly initialised instance
        /// </summary>
        private PrePopulatorCsvDataSource(
            ILogger<PrePopulatorCsvDataSource> logger,
            Stream csvStream)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.csvStream = csvStream ?? throw new ArgumentNullException(nameof(csvStream));
        }

        public string GetAnsVal(string alias)
        {
            if (string.IsNullOrEmpty(alias)) throw new ArgumentException("may not be null or empty", nameof(alias));
            if ((uid != null) && headerRowColumnLookup.TryGetValue(alias, out string columnName))
            {
                //TODO - we should build our own (case-insensitive) map of column indices and use index here to  save a lookup.
                return csv.GetField(columnName);
            }
            else
            {
                return null;
            }
        }

        public string GetUid()
        {
            return uid;
        }

        public bool HasAlias(string alias)
        {
            if (string.IsNullOrEmpty(alias)) throw new ArgumentException("may not be null or empty", nameof(alias));
            return headerRowColumnLookup.ContainsKey(alias);
        }

        public async Task<bool> Next()
        {
            if (!initialised) await Initialise();
            if (disposedValue) throw new InvalidOperationException("This instance has been disposed");

            bool isMoreRecords = await csv.ReadAsync();
            if (isMoreRecords)
            {
                uid = csv.GetField(uidColumnIndex);
                //Skip along to the next CSV row with a UID value
                while (isMoreRecords && string.IsNullOrEmpty(uid))
                {
                    missingUidCount++;
                    isMoreRecords = await csv.ReadAsync();
                    uid = isMoreRecords ? csv.GetField(uidColumnIndex) : null;
                }
            }
            if (!isMoreRecords) uid = null;
            return isMoreRecords;
        }

        public void Dispose()
        {
            // Do not change this code. Put cleanup code in 'Dispose(bool disposing)' method
            Dispose(disposing: true);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(Dispose) + " - disposing={0}", disposing);
            }

            if (!disposedValue)
            {
                if (disposing)
                {
                    if (csv != null)
                    {
                        csv.Dispose();
                        csv = null;
                    }
                    //note that we don't dispose csvStream - that's caller's problem
                }
                disposedValue = true;
            }
        }

        private async Task Initialise()
        {
            try
            {
                CsvConfiguration csvConfiguration = new CsvConfiguration(CultureInfo.InvariantCulture)
                {
                    HasHeaderRecord = true,
                    PrepareHeaderForMatch = (args) => args.Header.Trim(), //strip spaces around columnNames     
                };
                csv = new CsvReader(
                    new StreamReader(csvStream, leaveOpen: true),
                    csvConfiguration,
                    leaveOpen: false);

                bool hasContent = csv.Read();
                if (!hasContent) 
                    throw new InvalidOperationException("CSV is empty");

                csv.ReadHeader();

                //List of the columns in order, using case as per CSV header row
                headerRowColumns
                    = csv.HeaderRecord
                    .Select(header => header.Trim())
                    .ToImmutableList();

                uidColumnIndex = headerRowColumns.FindIndex(
                    columnName => Constants.Comparers.AliasCaseInsensitive.Equals(columnName, UID_COLUMN) );
                if (uidColumnIndex == -1)
                    throw new InvalidOperationException("CSV lacks a UID column");

                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(nameof(Initialise) + " - CSV column count={0}", headerRowColumns.Count);
                }
                if (logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(Initialise) + " - headerRowColumns={0}", string.Join(", ", headerRowColumns));
                }

                //For checking presence and normalising case
                headerRowColumnLookup
                    = headerRowColumns
                    .ToImmutableDictionary(
                        columnName => columnName,
                        columnName => columnName,
                        Constants.Comparers.AliasCaseInsensitive);

                initialised = true;
            }
            catch (Exception e)
            {
                throw new InternalException($"Failed to initialise {nameof(PrePopulatorCsvDataSource)}", e);
            }
        }
    }
}
