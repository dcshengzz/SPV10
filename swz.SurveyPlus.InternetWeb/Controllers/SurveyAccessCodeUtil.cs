using Microsoft.AspNetCore.Http;
using System;
using System.Linq;

namespace swz.SurveyPlus.InternetWeb.Controllers
{
    /// <summary>
    /// Utility methods to assist with managing flags in the session that record whether 
    /// a survey access code has been entered yet.
    /// </summary>
    public static class SurveyAccessCodeUtil
    {
        private const string VALIDATED_ACCESSCODE_KEY_PREFIX = "Validated_AccessCode_";

        private static string Key(Guid qnnDplySampleInfoId)
        {
            return VALIDATED_ACCESSCODE_KEY_PREFIX + qnnDplySampleInfoId;
        }

        /// <summary>
        /// Returns true if the password for the specified dlsi has already been validated
        /// </summary>
        /// <param name="session"></param>
        /// <param name="qnnDplySampleInfoId"></param>
        /// <returns></returns>
        public static bool AccessCodePreviouslyValidated(ISession session, Guid qnnDplySampleInfoId)
        {
            string key = Key(qnnDplySampleInfoId);
            int? validated = session.GetInt32( key );
            return validated != null && validated > 0;
        }

        /// <summary>
        /// Sets the flag to indicate that password was validated for the specified dlsi
        /// </summary>
        /// <param name="session"></param>
        /// <param name="qnnDplySampleInfoId"></param>
        public static void NoteAccessCodeValidated(ISession session, Guid qnnDplySampleInfoId)
        {
            string key = VALIDATED_ACCESSCODE_KEY_PREFIX + qnnDplySampleInfoId;
            session.SetInt32(key, 1);
        }

        /// <summary>
        /// Removes the flags for all validated passwords from the session
        /// </summary>
        /// <param name="session"></param>
        public static void ClearValidatedAccessCodes(ISession session)
        {
            var validatedPasswords = session.Keys.Where((key) => key.StartsWith(VALIDATED_ACCESSCODE_KEY_PREFIX)).ToList();
            foreach(var key in validatedPasswords)
            {
                session.Remove(key);
            }
        }
    }
}
