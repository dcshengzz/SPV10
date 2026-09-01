using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace swz.SurveyPlus.Application
{
    /// <summary>
    /// Business logic and support methods related to the File Storage (annex) feature
    /// </summary>
    public static class FileStorageApplication
    {
        public const string FILE_UPLOAD_DISABLED_MSG = "Failed to upload, file upload operation has been disabled.";
        public const string FILE_BLACKLISTED_MSG = "Failed to upload, system detect unauthorised file type.";

        /// <summary>
        /// Check is the Filename is valid
        /// Contains _ and - and .(dot) is valid and all other special character is not valid
        /// </summary>
        /// <param name="fileName">filename</param>
        /// <returns>true for valid filename and false for invalid</returns>
        public static bool IsValidFileName(string fileName)
        {
            char[] specialChar = @"\|!#$%&/()=?@{};'<>, ".ToCharArray(); //Not allow special characters
            return !string.IsNullOrEmpty(fileName) &&
              fileName.IndexOfAny(Path.GetInvalidFileNameChars()) < 0 &&
              fileName.IndexOfAny(Path.GetInvalidPathChars()) < 0 &&
              fileName.IndexOfAny(specialChar) < 0;

        }

        ///Reference 
        ///https://docs.microsoft.com/en-us/aspnet/core/mvc/models/file-uploads?view=aspnetcore-3.1#file-signature-validation-1
        ///https://filesignatures.net/
        ///https://github.com/rocketRobin/myrmec/blob/master/src/Myrmec/FileTypes.cs
        ///https://onlinestringtools.com/split-string to manipulate the string byte with 0x
        public static readonly Dictionary<string, List<byte[]>> BlacklistedFileSignature =
            new Dictionary<string, List<byte[]>>
            {
                { "exe", new List<byte[]>
                    {
                    new byte[] { 0x4D, 0x5A },
                    }
                },
                //{ "zip", new List<byte[]>
                //    {
                //    //new byte[] { 0x50, 0x4B, 0x03, 0x04 }, this clashes with docx, pptx, xlsx
                //    new byte[] { 0x50, 0x4B, 0x4C, 0x49, 0x54, 0x45 },
                //    new byte[] { 0x50, 0x4B, 0x53, 0x70, 0x58 },
                //    new byte[] { 0x50, 0x4B, 0x05, 0x06 },
                //    new byte[] { 0x50, 0x4B, 0x07, 0x08 },
                //    new byte[] { 0x57, 0x69, 0x6E, 0x5A, 0x69, 0x70 },
                //    new byte[] { 0x50, 0x4B, 0x03, 0x04, 0x14, 0x00, 0x01, 0x00 },
                //    }
                //},
                { "tar", new List<byte[]>
                    {
                    new byte[] { 0x75, 0x73, 0x74, 0x61, 0x72 },
                    }
                },
                { "7z", new List<byte[]>
                    {
                    new byte[] { 0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C },
                    }
                },
                { "rar", new List<byte[]>
                    {
                    new byte[] { 0x52, 0x61, 0x72, 0x21, 0x1A, 0x07, 0x00 },
                    new byte[] { 0x52, 0x61, 0x72, 0x21, 0x1a, 0x07, 0x01, 0x00 },
                    }
                }
            };



        public static bool IsFileWhitelisted(HashSet<string> whitelisting, string fileName)
        {
            string ext = Path.GetExtension(fileName);
            if (string.IsNullOrEmpty(ext))
                return false;

            if (ext.Contains('.'))
                ext = ext.Split('.')[ext.Split('.').Length - 1];

            return whitelisting.Contains(ext);
        }

        /// <summary>
        /// (Caller is responsible to manage the rewind or disposal of stream)
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        public static (bool,string) IsFileBlacklisted(StreamWithName file)
        {
            bool isMatch = false;
            string matchSign = string.Empty;
            List<byte[]> signatures = null;
            byte[] headerBytes = null;
            foreach (KeyValuePair<string, List<byte[]>> sign in BlacklistedFileSignature)
            {
                signatures = sign.Value;
                using (BinaryReader reader = new BinaryReader(file.Stream, System.Text.Encoding.UTF8, leaveOpen: true))
                {
                    headerBytes = reader.ReadBytes(signatures.Max(m => m.Length));

                    isMatch = signatures.Any(signature => headerBytes.Take(signature.Length).SequenceEqual(signature));
                    if (isMatch)
                    {
                        matchSign = sign.Key;
                        break;
                    }
                }
            }
            return (isMatch, matchSign);
        }


    } //end of FileStorageApplication
}
