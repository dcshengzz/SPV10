using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.View;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication;
using System;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    public class ShortLinkController : Controller
    {
        private readonly ILogger logger;

        public ShortLinkController(ILogger<ShortLinkController> logger)
        {
            this.logger = logger 
                ?? throw new ArgumentNullException(nameof(logger));
        }

        //nb: the endpoint to process shortlink requests as part of u@app api has moved to IntegrationApiController

        /// <summary>
        /// Get the target URL and its QR code image data for the specified shortlink
        /// (UI uses this to display the QR code on the intranet ShortLink form)
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Authorize]
        [HttpGet]
        [Route("/shortlink/info")]
        public async Task<ActionResult> GetShortLinkInfo(Guid id)
        {
            try
            {
                if(!CloverRuntime.Security.CheckPermission(
                    Constants.PermissionGroup.ShortLink, 
                    Constants.PermissionGroup.Permission.View))
                {
                    return Unauthorized(Constants.Message.YouDontHaveThePermission);
                }

                DynamicEntity qnnShortLink = await ShortLinkApplication.GetQnnShortLinkById(id);
                if(qnnShortLink == null)
                {
                    return BadRequest("Specified ShortLink does not exist");
                }

                if(false==await ShortLinkApplication.CheckShortLinkStructDivisionAccessAsync(qnnShortLink))
                {
                    return Unauthorized(Constants.Message.YouDontHaveThePermission);
                }

                ShortLinkUrlAndQrCode qrCode = await ShortLinkApplication.ShortLinkQrCode(qnnShortLink);
                return Json(new ItemSuccessResponse<ShortLinkUrlAndQrCode>(qrCode));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetShortLinkInfo) + " - caught unexpected exception, id={0}", id);
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }
    }
}
