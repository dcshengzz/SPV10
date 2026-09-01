/*using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using swz.Clover.AuthServices.Jwt.Components.Common.Controllers;
using swz.Clover.AuthServices.Jwt.Components.Entity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using swz.Clover.Core.View;
using swz.Clover.AuthServices.Jwt.Services;*/

namespace swz.Clover.AuthServices.Jwt.Services
{

    //20250503 MobileController is not used in SurveyPlus (3PA has its own endpoints) and not really maintained,
    //commenting it out because we want to do more refactoring of JwtController on which it has a dependency.
    //Will likely remove this file entirely later.

    //[Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    //public class MobileController : Controller
    //{
    //    #region API methods

    //    /// <summary>
    //    /// Clients that used JWT login should use this API call to logout and invalidate the tokens.
    //    /// </summary>
    //    [HttpGet]
    //    public async Task<ActionResult> Logout()
    //    {
    //        if (await JwtController.Instance.GetUser(Request) == null) return Json(new FailResponse("Unauthorized"));

    //        return await JwtController.Instance.InvalidateUserToken(Request) ? Json(new SuccessResponse()) : Json(new FailResponse("Unauthorized"));
    //    }

    //    /// <summary>
    //    /// Clients that want to go cookie-less should call this API to login and receive
    //    /// a Json Web Token (JWT) that allows them to authenticate the users to other
    //    /// secure API endpoints afterwards.
    //    /// </summary>
    //    /// <remarks>AllowAnonymous attribute must stay in this call even though the
    //    /// Authorize attribute is present at a class level.</remarks>
    //    [HttpPost]
    //    [AllowAnonymous]
    //    public async Task<ActionResult> Login([FromBody] TokenLoginHelper.LoginData loginData)
    //    {
    //        LoginResultData result = await TokenLoginHelper.LoginUser(Request, loginData);
    //        return ReplyWith(result);
    //    }

    //    /// <summary>
    //    /// Extends the token expiry. A new JWT is returned to the caller which must be used in
    //    /// new API requests. The caller must pass the renewal token received at the login time.
    //    /// The header still needs to pass the current token for validation even when it is expired.
    //    /// </summary>
    //    /// <remarks>The access token is allowed to get renewed one time only.<br />
    //    /// AllowAnonymous attribute must stay in this call even though the
    //    /// Authorize attribute is present at a class level.
    //    /// </remarks>
    //    [HttpPost]
    //    [AllowAnonymous]
    //    public async Task<ActionResult> ExtendToken([FromBody] RenewalDto rtoken)
    //    {
    //        var result = await JwtController.Instance.RenewUserToken(Request, rtoken.RenewalToken);
    //        return ReplyWith(result);
    //    }

    //    #endregion

    //    #region helpers

    //    private ActionResult ReplyWith(LoginResultData result)
    //    {
    //        if (result == null)
    //        {
    //            return Json(new FailResponse("Unauthorized"));
    //        }

    //        if (!string.IsNullOrEmpty(result.Error))
    //        {
    //            return Json(new FailResponse(result.Error));
    //        }

    //        return Json(result);
    //    }

    //    #endregion

    //    #region Testing APIs

    //    // Test API Method 1
    //    [HttpGet]
    //    public async Task<ActionResult> TestGet()
    //    {
    //        if (await JwtController.Instance.GetUser(Request) == null) return Json(new FailResponse("Unauthorized"));

    //        var identity = User.Identity;
    //        var reply = $"Hello {identity.Name}! You are authenticated through {identity.AuthenticationType}.";
    //        return Json(new { reply });
    //        //User.IsInRole("SiteAdmin")
    //    }

    //    // Test API Method 2
    //    [HttpPost]
    //    [ValidateAntiForgeryToken]
    //    public async Task<ActionResult> TestPost(TestPostData something)
    //    {
    //        if (await JwtController.Instance.GetUser(Request) == null) return Json(new FailResponse("Unauthorized"));

    //        var identity = User.Identity;
    //        var reply = $"Hello {identity.Name}! You are authenticated through {identity.AuthenticationType}." +
    //                    $" You said: ({something.Text})";
    //        return Json(new { reply });
    //    }

    //    [JsonObject]
    //    public class TestPostData
    //    {
    //        [JsonProperty("text")]
    //        public string Text;
    //    }

    //    #endregion
    //}
}
