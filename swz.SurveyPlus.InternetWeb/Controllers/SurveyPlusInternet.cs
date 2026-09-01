using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.View;
using swz.SurveyPlus.ApiSupport;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.InternetApplication;
using System;
using System.Collections.Generic;
using System.Net.Mime;
using System.Threading.Tasks;

namespace swz.SurveyPlus.InternetWeb.Controllers
{
    /// <summary>
    /// Utility & common methods for use by controllers in the SurveyPlus internet application
    /// </summary>
    public static class SurveyPlusInternet
    {
        public const string ApplicationName = "SPInternet"; //for internal use, not UI facing

        /// <summary>
        /// Name of internet application .NET session cookie
        /// </summary>
        public const string InternetSessionCookie = $".AspNetCore.Session.{ApplicationName}";

        /// <summary>
        /// Name of internet session stamp cookie and value variable in the session
        /// </summary>
        public const string InternetSessionStamp = $"{InternetSessionCookie}.Info";

        /// <summary>
        /// Get the uId from the session or null if the user is not logged in.
        /// Nb: this method differs from GetUserId as it just returns the raw uId attribute from the session.
        /// (It doesn't get and decrypt the encrUserID attribute)
        /// Note: If you want to check if the user is logged in then use IsLogged in for better code readability.
        /// There is now a variant of the method that will return the uid as an out parameter.
        /// </summary>
        /// <param name="session">The http session. This MAY be null</param>
        /// <returns>uid or null if not set or no session</returns>
        public static string GetUid(ISession session)
        {
            //ApiSupport can't see SurveyPlusInternet so I had to copy the method to UAppUtils
            //and here I now refer to that to make the duplication explicit for future maintainers.
            //(Non-u@app code should continue referring to SurveyPlusInternet.GetUid and not call
            //ApiSupport methods directly.)
            return UAppUtils.GetUidFromSession(session); 
        }

        //TODO - what is the point of this behaviour? (obsolete?) Can we remove it and just use GetUid already?
        /// <summary>
        /// Get the (decrypted) uid of the current respondent user from the session.
        /// This method differs from GetUid as it instead gets the encrUserID attribute from the session and decrypts it.
        /// Also it doesn't allow session to be null.
        /// </summary>
        /// <param name="session">the http session, this MAY NOT be null</param>
        /// <returns>userId</returns>
        public static string GetUserId(ISession session)
        {
            if (session == null) throw new ArgumentNullException(nameof(session));
            string encrUserId = session.GetString(Constants.RespondentHttpSession.encrUserID);
            string userId = EncryptionHelper.DecryptStr(encrUserId, Constants.LoginKey, Constants.LoginIv);
            return userId;
        }

        /// <summary>
        /// Stamp the session (sets a cookie in response) and update session attributes 
        /// based on the login result to record uId etc
        /// nb: doesn't log out any existing intranet session. Caller should do that themselves.
        /// </summary>
        /// <param name="result">successful login result</param>
        /// <param name="session"></param>
        /// <returns></returns>
        public static void RecordRespondentLogin(LoginResult result, HttpContext context)
        {
            if (result == null) throw new ArgumentNullException(nameof(result));
            if (context==null) throw new ArgumentNullException(nameof(context));

            if (!result.IsSuccess) throw new ArgumentException(nameof(result), "Not successful");

            StampRespondentSession(context);

            LoginResult.LoginInformation information = result.Information;
            context.Session.SetString(Constants.RespondentHttpSession.uId, information.UserId);
            context.Session.SetString(Constants.RespondentHttpSession.sampleId, information.SampleId);
            context.Session.SetString(Constants.RespondentHttpSession.encrUserID, information.EncrUserID);
            context.Session.SetString(Constants.RespondentHttpSession.lastLoginDate, information.LastLoginDate.ToString(Constants.QnnDatetimeFormat));

            //20250518 - u@app api tokens are now set via the InternetApiTokenManager
        }

        public static async Task Logoff(ILogger logger, HttpContext context, IRespondentService respondentService)
        {
            try
            {
                //Tell intranet internet user go bye bye
                await respondentService.LogoffAsync();
            }
            catch (PermissionException)
            {
                //If the session expired then the access token is not there to pass to the server
                logger.LogDebug("No permission to invoke service logoff");
            }
            catch (RespondentServiceException e)
            {
                //Log the error returned by the service but proceed anyway
                logger.LogError(e, nameof(Logoff) + " - caught unexpected error");
            }
            finally
            {
                ClearRespondentLogin(context);
            }
        }

        /// <summary>
        /// Clear session attributes that maintain the login in the internet side (i.e. 'stamp' and uid etc)
        /// Note: this does NOT inform the internet side of the logoff in the case of u@app
        /// </summary>
        public static void ClearRespondentLogin(HttpContext context)
        {
            context.Response.Cookies.Delete(InternetSessionStamp);
            ISession session = context.Session;
            //nb: we are specific about what keys we remove when logging out instead of just wiping the session
            //    (but I am not sure why - legacy behaviour?) 
            //    (20231009 - may be because session is used to pass error message to login page in some cases?)
            //    TODO - consider whether it would be better to wipe everything except error message from session
            //           (e.g. retain stuff specifically rather than wipe stuff specifically on logout)

            //clear session
            session.Remove(InternetSessionStamp);
            session.Remove(Constants.RespondentHttpSession.uId);
            session.Remove(Constants.RespondentHttpSession.sampleId);

            //20250518 - u@app api tokens are now cleared via the InternetApiTokenManager

            SurveyAccessCodeUtil.ClearValidatedAccessCodes(session);

            //TODO - WOGAA session info?
        }

        //Kludge to pass the setting to StampRespondentSession, will be set in StartupInternet
        //from value in appsettings.json for AspSameSite. Everything else should treat this as
        //read-only and should use the DI settings object instead if practical
        public static SameSiteMode Kludge_AspSameSite_Setting = SameSiteMode.Unspecified;

        //Kludge to pass the setting to StampRespondentSession. Other than StartupInternet, code
        //should treat this as read only and prefer to use the settings object from DI if practical.
        public static CookieSecurePolicy Kludge_SecurePolicy = CookieSecurePolicy.SameAsRequest;

        /// <summary>
        /// Generate a session 'stamp' and record it both in session and as a response cookie.
        /// The stamp is a shared secret that will be compared to verify that login details
        /// recorded in the session are still considered valid for the client currently using 
        /// this session.
        /// </summary>
        public static void StampRespondentSession(HttpContext context)
        {
            string stamp = Convert.ToBase64String(EncryptionHelper.GenerateBytes(32));
            //cookie is only submitted by browser for subseqent requests
            context.Session.SetString(InternetSessionStamp, stamp);
            //also set a request item lest aught need check now in same request
            context.Items[InternetSessionStamp] = stamp; 
            bool isSetSecure
                = (Kludge_SecurePolicy == CookieSecurePolicy.Always)
                || (Kludge_SecurePolicy == CookieSecurePolicy.SameAsRequest && context.Request.IsHttps);
            context.Response.Cookies.Append(
                InternetSessionStamp, 
                stamp,
                new CookieOptions()
                {
                    HttpOnly = true,
                    SameSite = Kludge_AspSameSite_Setting,
                    Secure = isSetSecure,
                });
        }

        /// <summary>
        /// Compare the session 'stamp' in the cookie with the 'stamp' in the session 
        /// and return true if they match.
        /// </summary>
        public static bool IsRespondentSessionStamped(HttpContext context)
        {
            bool isStampedCorrectly;
            string expectedStamp = context.Session.GetString(InternetSessionStamp);
            bool isLoginActiveInSession = !string.IsNullOrWhiteSpace(expectedStamp);
            if (isLoginActiveInSession) 
            {
                string presentedStamp;
                if (context.Items.TryGetValue(InternetSessionStamp, out object stampInContextItems))
                {
                    //Edge case (must check first):
                    //On the initial request when they login and the stamp was just added as a response
                    //cookie its not yet available in the request cookies. So we have also
                    //added it as a context item (that will only be available during the same request)
                    //so that this method can work when called from within that initial request
                    //(one place known to currently do this is in
                    //SurveyPlusInternet.IsLoggedInAsAnonymousSample, and there may be others
                    //now or in the future).
                    //n.b. we need to check this case first to cover the edge-edge-case of where a user
                    //     who is already logged in with a different stamp does a fresh login that would
                    //     override that stamp (e.g. maybe they were still logged in as a normal respondent
                    //     and then begin a session as swzanonymous). In such a case the new stamp cookie we
                    //     set would overwrite the old one, but during that initial request the old (and now
                    //     incorrect) one is available in a cookie. 
                    presentedStamp = (string)stampInContextItems;
                }
                else if (context.Request.Cookies.TryGetValue(InternetSessionStamp, out string stampInCookie))
                {
                    //This is the usual case, there's a stamp in the request cookie, but is it the correct stamp?
                    //We will check soon...
                    presentedStamp = stampInCookie;
                }
                else
                {
                    //No stamp presented. This is not an expected scenarion because there is an expected stamp
                    //recorded in the session, and we did get the session, and we did already check for the
                    //first request edge case, so then ... where is stamp cookie?
                    presentedStamp = null;
                }

                //Here is where we verify that the presented stamp is indeed the one we expect
                isStampedCorrectly = string.IsNullOrWhiteSpace(presentedStamp)
                    ? false
                    : expectedStamp.Equals(presentedStamp, StringComparison.Ordinal);
            }
            else
            {
                //No active login for the session, they haven't authenticated yet, or the
                //session timed out and cleared the stamp and other session data already
                isStampedCorrectly = false;
            }
            return isStampedCorrectly;
        }

        public static ActionResult InvalidateSessionAndReturnFailResponse(HttpContext context)
        {
            ClearRespondentLogin(context);
            return new JsonResult(new FailResponse(Constants.Message.SessionInvalid));
        }

        public static ActionResult InvalidateSessionAndReturn403(HttpContext context)
        {
            ClearRespondentLogin(context);
            return new ContentResult
            {
                StatusCode = StatusCodes.Status403Forbidden,
                Content = Constants.Message.SessionInvalid,
                ContentType = System.Net.Mime.MediaTypeNames.Text.Plain,
            };
        }

        public static ActionResult InvalidateSessionAndRedirectToLogin(HttpContext context)
        {
            ClearRespondentLogin(context);
            return new RedirectResult("/resp/login")
            {
                Permanent = false,
            };
        }

        /// <summary>
        /// Returns a dictionary intended for serialisation as Json to report a fail to clientside.
        /// Main difference with the a FailResponse is this has a 'details' with an empty entity and 'formIsReadOnly' (always true)
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="details"></param>
        /// <returns></returns>
        public static Dictionary<string, object> GenFailedDictionary(string msg, string details = null)
        {
            var failed = new DynamicEntity();
            failed.Dictionary.Add("success", false);
            failed.Dictionary.Add("message", msg);
            failed.Dictionary.Add("details", details);
            failed.Dictionary.Add("formIsReadOnly", true);
            return failed.ToDictionary();
        }

        /// <summary>
        /// Returns true if the current session is considered as logged in.
        /// (For the internet side this is indicated by the presense of a uId attribute in the asp session,
        /// holding the UID of the respondent)
        /// </summary>
        public static bool IsLoggedIn(HttpContext context)
        {
            return IsLoggedIn(context, out string _);
        }

        /// <summary>
        /// Returns true if the current session is considered as logged in and will write the respondent's uid to the
        /// uid output parameter (will be null if not considered logged in, even if not-logged-in session contains a uid).
        /// (For the internet side this is indicated by the presense of a uId attribute in the asp session,
        /// holding the UID of the respondent)
        /// </summary>
        public static bool IsLoggedIn(HttpContext context, out string uid)
        {
            bool isSessionStamped = IsRespondentSessionStamped(context);
            uid = isSessionStamped
                ? GetUid(context.Session)
                : null;
            return !string.IsNullOrEmpty(uid);
        }

        /// <summary>
        /// This check occurs often enough to get its own helper method :-)
        /// </summary>
        /// <param name="context"></param>
        /// <returns>true if logged in as swzAnonymous, false if not logged in or logged in as some other sample</returns>
        public static bool IsLoggedInAsAnonymousSample(HttpContext context)
        {
            return 
                IsLoggedIn(context, out string uid) 
                && TaiSengCharitableAdoptionShelterForHomelessUtilityMethods.IsAnonymousSample(uid);
        }

        /// <summary>
        /// Returns the Id of the current respondent. 
        /// An InvalidOperationException will be raised if this is called when there is no respondent
        /// sampleId recorded in the session, or ArgumentNullException if the session is null.
        /// Don't use this to check if a respondent is logged in, instead use IsLoggedIn or if you also
        /// need the UID use GetUid() which will return null when not logged in/ 
        /// </summary>
        /// <param name="session">http sesssion (required)</param>
        /// <returns>sampleId</returns>
        public static Guid GetSampleId(ISession session)
        {
            if (session == null) 
                throw new ArgumentNullException(nameof(session));
            string strSampleId = session?.GetString(Constants.RespondentHttpSession.sampleId);
            if (strSampleId == null) 
                throw new InvalidOperationException("There is no sampleId in the session");
            if (!Guid.TryParse(strSampleId, out var sampleId))
                throw new InvalidOperationException("The sampleId value in the session is invalid");
            return sampleId;
        }

        //TODO - summary must warn about laundering and need for checks
        public static ContentResult LoginInterstitial(string location)
        {
            string html = $@"
                <!DOCTYPE html>
                <html>
                    <head>
                        <title>Redirecting...</title>
                        <meta http-equiv='refresh' content='1;url={location}'>
                    </head>
                    <body>
                        Loading your survey dashboard... (If page does not start loading automatically after 5 seconds, please<a href='{location}'> click here</a>).                                  
                    </body>
                </html>";
            return new ContentResult()
            {
                Content = html,
                ContentType = MediaTypeNames.Text.Html,
            };
        }

    } //end of SurveyPlusInternet
}
