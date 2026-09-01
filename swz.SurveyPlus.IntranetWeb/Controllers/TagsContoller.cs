using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using System;
using swz.Clover.Core.View;
using swz.Clover.Core;
using Constants = swz.SurveyPlus.Application.Constants;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Security;

namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    public class TagsController : Controller
    {
        private readonly ILogger logger;

        public TagsController(ILogger<TagsController> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        /// <summary>
        /// check is current user has access to tags function
        /// </summary>
        /// <returns></returns>
        private async Task<bool> IsCurrentUserHasAccess()
        {
            User user = await CloverRuntime.Security.GetCurrentUserAsync();

            if (!user.IsInRole(Constants.Role.SurveyAdmin))
                return false;

            if (user.StructDivisionId == null)
                return false;

            return true;
        }

        /// <summary>
		/// Get active tags to show on screen
		/// </summary>
		/// <param name="number">Number of tag to return</param>
		/// <returns></returns>
        [HttpGet]
        [Authorize]
        [Route("tags/getActiveTags")]
        public async Task<ActionResult> GetActiveTags(int number)
        {
            try
            {
                if (string.IsNullOrEmpty(number.ToString()))
                    return BadRequest();

                if (await IsCurrentUserHasAccess() == false)
                    return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));
                    
                Guid userStructDivisionId = CloverRuntime.Security.CurrentUser.StructDivisionId.Value;
                List <Dictionary<string, object>> result = await spSP_GetActiveTagsByStruct.GetActiveTagsByStruct(userStructDivisionId, number);
                if(result != null)
                {
                    List<string> listTags = new List<string>();
                    foreach (Dictionary<string, object> tag in result)
                    {
                        listTags.Add(tag[Constants.FieldName.Tags].ToString());
                    }

                    return Json(new ItemSuccessResponse<List<string>>(listTags));
                }

                return Json(new FailResponse("TAGS_NOT_FOUND"));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(GetActiveTags) + " - caught unexpected exception, number={0}", number);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }

        /// <summary>
		/// Search tags and display result to grid
		/// </summary>
		/// <param name="tagsSelectedName">array of serialize tags</param>
		/// <returns></returns>
        [HttpGet]
        [Authorize]
        [Route("tags/tagsPanelSearch")]
        public async Task<ActionResult> TagsPanelSearch(string tagsSelectedName)
        {
            try
            {
                if (string.IsNullOrEmpty(tagsSelectedName))
                    return BadRequest();

                if (await IsCurrentUserHasAccess() == false)
                    return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));

                List<Guid> userStructDivisionIds
                    = await StructDivision.SelectChildrenAndThisIdListAsync(CloverRuntime.Security.CurrentUser.StructDivisionId.Value);
                List<string> listTag = JsonConvert.DeserializeObject<List<string>>(tagsSelectedName);

                List<vSP_TagsSearch> result = await vSP_TagsSearch.SearchTags(userStructDivisionIds,listTag);
                if(result != null)
                {
                    return Json(new ItemSuccessResponse<List<vSP_TagsSearch>>(result));
                }
                
                return Json(new FailResponse("TAGS_NOT_FOUND"));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(TagsPanelSearch) + " - caught unexpected exception, tagsSelectedName={0}", tagsSelectedName);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }

        }

        /// <summary>
		/// Search for a list of active tags that match the search string
		/// </summary>
		/// <param name="search">string to search</param>
		/// <returns></returns>
        [HttpGet]
        [Authorize]
        [Route("tags/searchTags")]
        public async Task<ActionResult> SearchTags(string search)
        {
            try
            {
                if (string.IsNullOrEmpty(search))
                    return BadRequest();

                if (await IsCurrentUserHasAccess() == false)
                    return Json(new FailResponse(Constants.Message.YouDontHaveThePermission));

                List<Guid> userStructDivisionIds
                    = await StructDivision.SelectChildrenAndThisIdListAsync(CloverRuntime.Security.CurrentUser.StructDivisionId.Value);
                string strSearch = JsonConvert.DeserializeObject<string>(search);
                List<vSP_TagsWithStructDivisionId> result = await vSP_TagsWithStructDivisionId.SearchTags(userStructDivisionIds, strSearch);
                if(result != null)
                {
                    List<string> listTags = result.Select(x => x.Tags).ToList();
                    return Json(new ItemSuccessResponse<List<string>>(listTags));
                }
                
                return Json(new FailResponse("TAGS_NOT_FOUND"));
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(SearchTags) + " - caught unexpected exception, search={0}", search);
                return Json(new FailResponse(Constants.Message.InternalErrorException));
            }
        }
    }
}
