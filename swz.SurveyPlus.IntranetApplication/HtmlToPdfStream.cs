using swz.SurveyPlus.Application;
using System.IO;
using Winnovative;

namespace swz.SurveyPlus.IntranetApplication
{
    public static class HtmlToPdfStream
    {
        public static MemoryStream CreateLandscapeDocument(string html)
        {
            return CreateDocument(html,PdfPageOrientation.Landscape);
        }

        /// <summary>
        /// Create a pdf document from the specified html using reasonable settings
        /// and write it to a memory stream which is then reset to position 0 and returned.
        /// </summary>
        /// <param name="html"></param>
        /// <returns></returns>
        public static MemoryStream CreateDocument(string html , PdfPageOrientation orientation = PdfPageOrientation.Portrait)
        {
            var oPdfConverter = NewConverterInstance(orientation);
            var ms = new MemoryStream();
            oPdfConverter.SavePdfFromHtmlStringToStream(html, ms);
            ms.Seek(0, SeekOrigin.Begin);
            return ms;
        }

        /// <summary>
        /// Return a new instance of the winnovate pdf converter configured with reasonable settings.
        /// (Useful when you are doing multiple conversions or already have a stream to write to, or
        /// want to tweak the settings before use)
        /// </summary>
        /// <returns>PdfConverter</returns>
        public static PdfConverter NewConverterInstance(PdfPageOrientation orientation = PdfPageOrientation.Portrait)
        {
            var oPdfConverter = new PdfConverter { LicenseKey = Constants.WINNOVATIVE_LICENSE_KEY };
            oPdfConverter.PdfDocumentOptions.PdfPageOrientation = orientation;
            oPdfConverter.PdfDocumentOptions.PdfPageSize = PdfPageSize.A4;
            oPdfConverter.PdfDocumentOptions.BottomMargin = 5;
            oPdfConverter.PdfDocumentOptions.TopMargin = 5;
            oPdfConverter.PdfDocumentOptions.LeftMargin = 5;
            oPdfConverter.PdfDocumentOptions.RightMargin = 5;
            oPdfConverter.PdfDocumentOptions.StretchToFit = true;
            oPdfConverter.PdfDocumentOptions.PdfCompressionLevel = PdfCompressionLevel.Best;
            oPdfConverter.JavaScriptEnabled = false;
            return oPdfConverter;
        }
    }
}