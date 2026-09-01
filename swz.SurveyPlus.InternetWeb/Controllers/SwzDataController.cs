using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.SurveyPlus.InternetWeb.ActionFilters;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.InternetWeb.Controllers
{
    public class SwzDataController : Controller
    {
        private readonly ILogger logger;

        public SwzDataController(ILogger<SwzDataController> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

		[CheckSessionFilter]
        [Route("SwzData/getServerDateTime")]
		[HttpPost]
		public JsonResult GetServerDateTime(string datetimeformat)
		{
			try
			{
				var dateTime = DateTime.Now;
				string dateTimeFormatted;
				if (string.IsNullOrWhiteSpace(datetimeformat) || datetimeformat == "undefined")
				{
					dateTimeFormatted = dateTime.ToString(Constants.QnnDatetimeFormat);
				}
				else
				{
					dateTimeFormatted = dateTime.ToString(datetimeformat);
				}


				return Json(new
				{
					Success = true,
					Data = dateTimeFormatted,
					Message = "Load server time success"
				});
			}
			catch (Exception e)
			{
                logger.LogError(e, nameof(GetServerDateTime) + " - caught unexpected exception");

				return Json(new
				{
					Success = false,
					Message = "Unable to get server time"
				});
			}
		} //end of GetServerDateTime

    } //end of SwzDataController
}
