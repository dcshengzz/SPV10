using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Net.Http.Headers;
using swz.Clover.Core;
using swz.Clover.Core.Security;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Mime;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    public class FileTicketController : Controller
    {
        private readonly ILogger<FileTicketController> logger;

        public FileTicketController(ILogger<FileTicketController> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [HttpGet]
        [Authorize]
        [Route(Constants.IntranetRoutes.FileTicketDownload)]
        public async Task<ActionResult> FileTicketDownload(string ticket)
        {
            if (!Guid.TryParse(ticket, out Guid ticketId)) return BadRequest();
            try
            {
                DynamicEntity qnnFileTicket = await FileTicketApplication.GetQnnFileTicketById(ticketId);
                if (qnnFileTicket == null) return NotFound();

                string token = FileTicketApplication.GetToken(qnnFileTicket);

                User currentUser = await CloverRuntime.Security.GetCurrentUserAsync();
                FileTicketApplication.TicketValidity validity = await FileTicketApplication.IsTicketValidForUser(qnnFileTicket, currentUser);
                
                if(logger.IsEnabled(LogLevel.Trace))
                    logger.LogTrace(nameof(FileTicketDownload) + " - ticketId={0}, validity={1}", ticketId, validity);

                switch (validity)
                {
                    case FileTicketApplication.TicketValidity.Valid:
                        logger.LogInformation(nameof(FileTicketDownload) + " - returning file to user={0} ({1}), token={2}, ticketId={3} ", currentUser.Id, currentUser.Name, token, ticketId);

                        (Stream Stream, Dictionary<string, string> Properties) data
                            = await CloverRuntime.ContentProvider.GetAsync(token);

                        (ActionResult result, ContentDisposition disposition)
                            = ControllerFileHelper.FileResult(
                                data.Stream,
                                data.Properties,
                                FileResultAction.Download,
                                FileResultAllow.AnyDownloadableFile);  //any file, not limited to 'local storage'
                        if (disposition != null) Response.Headers.Append(HeaderNames.ContentDisposition, disposition.ToString());
                        return result;
                    
                    case FileTicketApplication.TicketValidity.Expired:
                    case FileTicketApplication.TicketValidity.Disabled:
                        throw new NotFoundException($"validity={validity}");

                    case FileTicketApplication.TicketValidity.Unauthorised:
                    default:
                        throw new PermissionException($"User {currentUser.Id} ({currentUser.Name}) does not meet the conditions to access file {token} via ticket {ticketId}");
                }
            }
            catch(NotFoundException nfe)
            {
                if(logger.IsEnabled(LogLevel.Debug)) 
                    logger.LogDebug(nameof(FileTicketDownload) + " - ticket={0}, nfe={1}", ticketId, nfe.Message);
                return new ContentResult
                {
                    StatusCode = StatusCodes.Status404NotFound,
                    Content = "This download link is not enabled or has already expired",
                    ContentType = System.Net.Mime.MediaTypeNames.Text.Plain,
                };
            }
            catch (PermissionException pex)
            {
                return ControllerUtilities.LogViolationAndDenyPermission(logger, HttpContext, pex);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(FileTicketDownload) + " - caught unexpected exception for ticketId={0}", ticketId);
                return StatusCode(500, Constants.Message.InternalErrorException);
            }
        }

    }
}
