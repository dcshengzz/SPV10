using System;
using System.Collections.Generic;
using System.Net.Mime;
using Microsoft.AspNetCore.Mvc;
using System.IO;

namespace swz.SurveyPlus.Application
{
    public enum FileResultAction { View, Download }

    public enum FileResultAllow { LocalStorageOnly, AnyDownloadableFile }

    public static class ControllerFileHelper
    {
        //TODO - the logic here is a result of a number of rounds of refactoring and additions to the original somewhat simple code
        //       but could be improved now as we are doing the access checks around IsDownloadable and IsLocalStorage here and we only get
        //       to here AFTER the file stream has been obtained (and the default impl of that just pulls the whole thing into a memory stream!)
        //       So for example, repeatedly asking for a huge file can still use up resources even though that file might not even be
        //       available for view/download and gets blocked here. Ideally we should refactor in both intranet and internet DataController
        //       to check the file properties and SDI at the same time before trying to get the stream for it.
        //       For internet side it would need some changes to the respondent service

        /// <summary>
        /// Will check the properties and return either a FileResult, or if this file isnt allowed to be sent a NotFoundResult instead.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="properties"></param>
        /// <param name="action"></param>
        /// <param name="allow"></param>
        /// <returns></returns>
        public static (ActionResult, ContentDisposition) FileResult(Stream stream, Dictionary<string, string> properties, FileResultAction action, FileResultAllow allow)
        {
            if (stream == null) throw new ArgumentNullException(nameof(stream));
            if (properties == null) throw new ArgumentNullException(nameof(properties));

            string filename = "unknown";
            string contentType = Constants.ContentTypes.UnknownApplicationType;

            bool isDownloadable
                    = !properties.ContainsKey(Constants.FileProperties.IsDownloadable)
                    || (properties.ContainsKey(Constants.FileProperties.IsDownloadable) && Convert.ToBoolean(properties[Constants.FileProperties.IsDownloadable]));

            if (!isDownloadable)
            {
                return (new NotFoundResult(), null);
            }

            bool isLocalStorage
                = properties.ContainsKey(Constants.FileProperties.IsLocalStorage) && Convert.ToBoolean(properties[Constants.FileProperties.IsLocalStorage]);

            if (allow == FileResultAllow.LocalStorageOnly && isLocalStorage == false)
            {
                return (new NotFoundResult(), null);
            }

            switch (allow)
            {
                case FileResultAllow.LocalStorageOnly:
                    if (!isLocalStorage) return (new NotFoundResult(), null);
                    break;

                case FileResultAllow.AnyDownloadableFile:
                    break; //dont block it

                default:
                    throw new NotImplementedException(allow.ToString());
            }


            if (properties.ContainsKey(Constants.FileProperties.Name) && properties[Constants.FileProperties.Name] != null)
            {
                filename = properties[Constants.FileProperties.Name];
            }

            //note: in SIMS this was: if (properties.ContainsKey("ContentType") && properties["ContentType"] == null)
            if (properties.ContainsKey(Constants.FileProperties.ContentType) && properties[Constants.FileProperties.ContentType] != null)
            {
                contentType = properties[Constants.FileProperties.ContentType];
            }

            ContentDisposition disposition = new ContentDisposition();
            disposition.FileName = filename;
            switch (action)
            {
                case FileResultAction.View:
                    disposition.Inline = true;
                    break;

                case FileResultAction.Download:
                    disposition.Inline = false;
                    break;

                default:
                    throw new NotImplementedException(action.ToString());
            }
            return (new FileStreamResult(stream, contentType), disposition);
        } // end of FileResult
    }
}
