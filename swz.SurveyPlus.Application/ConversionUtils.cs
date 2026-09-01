using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;

namespace swz.SurveyPlus.Application
{
    public static class ConversionUtils
    {
        /// <summary>
        /// Checks a value (such as from a csv column) to see if it is true or Y (as per constants in Constants.ConstYesNo)
        /// Other valid values (false, n) return false. 
        /// Case insensitive.
        /// Null and invalid values are not permitted and will result in a FormatException.
        /// </summary>
        public static bool IsTrueYN(string value)
        {
            if (value == null) throw new ArgumentNullException(nameof(value));
            if (!IsValidTrueYN(value)) throw new FormatException("Invalid value (must be one of TRUE, FALSE, Y, N) (case-insensitive)");
            return value.Equals(Constants.ConstYesNo.True, StringComparison.OrdinalIgnoreCase)
                || value.Equals(Constants.ConstYesNo.Yes, StringComparison.OrdinalIgnoreCase);
        }

        /// <summary>
        /// Id the value a valid value for use with the IsValidTrueYN method
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static bool IsValidTrueYN(string value)
        {
            if (value == null) return false;
            return value.Equals(Constants.ConstYesNo.True, StringComparison.OrdinalIgnoreCase)
                || value.Equals(Constants.ConstYesNo.Yes, StringComparison.OrdinalIgnoreCase)
                || value.Equals(Constants.ConstYesNo.False, StringComparison.OrdinalIgnoreCase)
                || value.Equals(Constants.ConstYesNo.No, StringComparison.OrdinalIgnoreCase);
        }

        /// <summary>
        /// Convenience method to split string and parse as a list of comma delimited Guids.
        /// Guid.Parse is used so the format is not strict and may have surrounding whitespace.
        /// See: https://learn.microsoft.com/en-us/dotnet/api/system.guid.parse?view=net-8.0
        /// On failure the out variable guids will be an empty list of Guid and false will be returned.
        /// On success will return true and a parsed List of Guid in same order as was passed in. 
        /// Note that an empty (or all whitespace) input string will be considered successful and result 
        /// in an empty output list. Null input will be considered unsuccessful and result in an
        /// empty list and false being returned.
        /// Missing elements in the list are not ok.
        /// The returned list is not shared with other callers. You are free to modify it.
        /// </summary>
        /// <param name="commaDelimitedGuidStrings">comma delimited string</param>
        /// <param name="guids">on success a list of 0 or more parsed Guids, on failure is always empty guid list</param>
        /// <returns>true on success, false otherwise</returns>
        public static bool TryParseCommaDelimitedGuids(string commaDelimitedGuidStrings, out List<Guid> guids)
        {
            if (commaDelimitedGuidStrings == null)
            {   //Special case, null is not ok, but doesn't throw error as returns fail result
                //(following the example of Guid.TryParse which returns false and Guid.Empty)
                guids = new List<Guid>();
                return false;
            }
            try
            {
                string[] items = commaDelimitedGuidStrings.Trim().Split(',');
                if (items.Length == 1 && "".Equals(items[0]))
                {   //Special case, empty list of guids is ok
                    guids = new List<Guid>();
                }
                else
                {   //Normal case, one or more guids to parse. Each item must be parseable as a guid (so empty items will fail)
                    guids = items
                        .Select(item => Guid.Parse(item))
                        .ToList();
                }
                return true;
            }
            catch (FormatException)
            {   //Parsing errors will reach here and give a fail result
                guids = new List<Guid>();
                return false;
            }
        }

        /// <summary>
        /// Round millisconds up to the next minute 
        /// (Useful for rough duration reports for long jobs etc)
        /// </summary>
        public static int ToMinutesRoundedUp(long milliseconds)
        {
            if (milliseconds < 0) throw new ArgumentException("may not be negative", nameof(milliseconds));
            double minutes = (double)milliseconds / 1000d / 60d;
            return (int)Math.Round(minutes, MidpointRounding.ToPositiveInfinity);
        }

        /// <summary>
        /// ConvertToDateTime will try these in order until it succeeds or runs out of formats to try.
        /// Only for use in ConvertToDateTime but not declared inside it to avoid reallocating on every call
        /// I find myself nodding along to this comment: https://stackoverflow.com/a/2616903
        /// </summary>
        private static string[] ConvertToDateTimeUsingHeuristics_expectedDateTimeFormats =
        {
            // current surveyplus exports in this format: 2022-11-12 15:48:50
            // older Clover SIMS uses 28/9/2023 2:40:37 pm <-- but is this based on machine settings?
            // Format Codes Reference:
            //  https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings

            "yyyy-MM-dd HH:mm:ss", //e.g. "2022-11-12 15:48:50" (as per export from modern SurveyPlus) <-- to check that
            "yyyy-MM-dd HH:mm", //e.g. "2022-11-12 15:48" <-- why does my test data have this now? <-- because Excel :-(
            "yyyy-MM-dd",
            "d/M/yyyy h:m:s tt", //e.g. "28/9/2023 2:40:37 pm" (as per export from older (GPC) Clover SIMS)
            "d/M/yyyy H:m", //e.g. "10/1/2023 16:57" (after being mangled by Excel on a GSIB laptop (assuming they all have same date format there by policy (which is not confirmed)))
            "d/M/yyyy",
        };

        //20240728 - Moved here from ResponseImporter for more general use
        //TODO - for things like response import this gets called a lot, see if can improve the performance
        /// <summary>
        /// Tries to convert the value to a DateTime using a variety of probable formats and allowing for whitespace.
        /// such as the current or the legacy response export format. Note that US format dates are not supported
        /// as we try normally formatted dates first, and there's no sure-fire way to tell which is which for many
        /// values, so better to fail-fast than be inconsistent. If it can't parse then an exception is raised.
        /// Returns null if the value is absent. 
        /// </summary>
        public static DateTime? ConvertToDateTimeUsingHeuristics(string value)
        {
            if (string.IsNullOrWhiteSpace(value)) return null;

            try
            {
                foreach (string expectedFormat in ConvertToDateTimeUsingHeuristics_expectedDateTimeFormats)
                {
                    DateTimeStyles styles = DateTimeStyles.AllowWhiteSpaces | DateTimeStyles.NoCurrentDateDefault;
                    //TODO - added NoCurrentDateDefault with the idea of parsing times as well, but have decided
                    //       not to go with that at present time. Note that for time-only we'd get year 0001 rather than
                    //       1970!
                    if (DateTime.TryParseExact(value, expectedFormat, CultureInfo.InvariantCulture, styles, out DateTime parsedValue))
                    {
                        return parsedValue;
                    }
                }
                //no generic fallbacks here, if it is not in one of those few formats we actually expect then reject it
                throw new NotImplementedException($"Unsupported format for {nameof(ConvertToDateTimeUsingHeuristics)}");
            }
            catch (Exception e)
            {   //Unexpected exception
                throw new FormatException($"Failed to parse \"{value}\" as a DateTime", e);
            }
        }

        /// <summary>
        /// Reformats a file Id guid as a file token string
        /// An exception is raised if the guid is Empty.
        /// </summary>
        public static string ToFileToken(Guid dwUploadedFilesId)
        {
            if (Guid.Empty.Equals(dwUploadedFilesId)) 
                throw new ArgumentException("May not be empty", nameof(dwUploadedFilesId));
            return dwUploadedFilesId.ToString().ToLowerInvariant().Replace("-", "");
        }

        /// <summary>
        /// Use the DEFLATE algorithm to compress the input text (which is treated as UTF-8)
        /// and return it encoded as Base64. 
        /// (Use of this returned value in a URL still needs URI encoding because Base64 is not
        /// naturally uri-safe)
        /// </summary>
        /// <param name="utf8Text">input data</param>
        /// <returns>deflated and encoded result</returns>
        public static string DeflateAndBase64Encode(string utf8Text)
        {
            byte[] xmlBytes = Encoding.UTF8.GetBytes(utf8Text);
            using (MemoryStream outputStream = new MemoryStream())
            {
                using (DeflateStream deflateStream = new DeflateStream(
                    outputStream,
                    CompressionLevel.Optimal,
                    leaveOpen: true))
                {
                    deflateStream.Write(xmlBytes, 0, xmlBytes.Length);
                }
                byte[] deflated = outputStream.ToArray();
                string base64Encoded = Convert.ToBase64String(deflated);
                return base64Encoded;
            }
            ;
        }

        /// <summary>
        /// Convert the base 64 to deflated bytes and then INFLATE them back to a UTF-8 string.
        /// </summary>
        /// <param name="base64">DEFLATE compressed data encoded as Base64</param>
        /// <returns>The UTF-8 string after INFLATE</returns>
        public static string Base64DecodeAndInflate(string base64)
        {
            byte[] compressedBytes = Convert.FromBase64String(base64);
            using (var compressedStream = new MemoryStream(compressedBytes))
            {
                using (DeflateStream deflateStream = new DeflateStream(compressedStream, CompressionMode.Decompress))
                {
                    using (StreamReader reader = new StreamReader(deflateStream, Encoding.UTF8))
                    {
                        return reader.ReadToEnd();
                    }
                }
            }
        }
    }
}
