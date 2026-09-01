using System;
using System.IO;

namespace swz.SurveyPlus.Application
{
    public static class FileUtils
    {
        /// <summary>
        /// Combine a path with a filename. The big difference between this and Path.Combine is that this will
        /// fail-fast if the filename includes directory traversal or any relative or absolute path. This
        /// is important for security when the filename is under external control (i.e. from the clientside).
        /// Please note that no such check is applied to the path which is expected to be under application
        /// control.
        /// Note also that aside from pathing checks, no other checks are (currently) made on the validity of the 
        /// filename (e.g. characters and encodings, length, etc). 
        /// The path is actually optional, and if null/empty then the filename, if valid, will be returned unchanged.
        /// If the filename is not valid then an ArgumentException is raised.
        /// </summary>
        /// <param name="path">Path to combine with. This is optional</param>
        /// <param name="filename">Filename (or single directory name) only (no absolute or sub paths allowed)</param>
        /// <returns>combined path</returns>
        public static string CombineWithPath(string path, string filename)
        {
            //TODO - consider supporting  multiple path elements like Path.Combine does (but for now I'll keep it simple)

            if (string.IsNullOrWhiteSpace(filename))
                throw new ArgumentException("required", nameof(filename));

            //path may be null or empty, but all whitespace is likely an error so fail
            if (path?.Length > 0 && string.IsNullOrWhiteSpace(path)) //is it all whitespace?
                throw new ArgumentException("required", nameof(path));

            //See: https://www.praetorian.com/blog/pathcombine-security-issues-in-aspnet-applications/
            if (Path.GetFileName(filename) != filename)
                throw new ArgumentException($"invalid filename {filename}", nameof(filename));

            return string.IsNullOrEmpty(path)
                ? filename
                : Path.Combine(path, filename);
        }

        /// <summary>
        /// Guesses the content type from the extension for some of the common types we use.
        /// Returns application/unknown for anything else.
        /// </summary>
        /// <param name="filename"></param>
        /// <returns></returns>
        /// <exception cref="ArgumentException"></exception>
        public static string GuessContentType(string filename)
        {
            if ((string.IsNullOrEmpty(filename))) throw new ArgumentException("required", nameof(filename));
            int i = filename.LastIndexOf('.');
            if (i != -1 && i < (filename.Length - 1))
            {
                string extension = filename.Substring(i).ToLowerInvariant();
                switch (extension)
                {
                    case ".zip":
                        return Constants.ContentTypes.ZipFileType;

                    case ".7z":
                        return Constants.ContentTypes.SevenZipFileType;

                    case ".csv":
                        return Constants.ContentTypes.CsvFileType;

                    case ".txt":
                        return Constants.ContentTypes.TextFileType;

                    case ".pdf":
                        return Constants.ContentTypes.PdfFileType;

                    case ".xlsx":
                        return Constants.ContentTypes.XlsxFileType;

                    case ".html":
                    case ".htm":
                        return Constants.ContentTypes.HtmlFileType;

                }
            }
            return Constants.ContentTypes.UnknownApplicationType;
        }
    }
}
