using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Additional non-core email related utility functions.
    /// Generally you can work directly with the methods in swz.Clover.Core.Utils.Email, however the methods here can
    /// sometimes save some time. 
    /// </summary>
    public static class EmailHelper
    {
        //TODO - don't mutate the pars dictionary, but first we need to check all calling code to see if anything depends on this side-effect

        /// <summary>
        /// Send an email to the specified user based on content template in a form.
        /// If the specified user is not found no error is raised, likewise if they somehow don't have an email address.
        /// Name of the current user will be included in substitution parameters under the key "Name".
        /// If you need to send more than one mail then don't use this method. Get the mail settings yourself and work directly with
        /// the FormSendAsync method in swz.Clover.Core.Utils.Email please.
        /// </summary>
        /// <param name="userId">Id of recipient user in dwSecurity user</param>
        /// <param name="pars">Substitution parameters (may be null)</param>
        /// <param name="templateName">Name of the Form that provides the content template</param>
        /// <returns></returns>
        public static async Task SendUserEmailByFormTemplate(
            Guid userId,  
            Dictionary<string, string> pars,
            string templateName) 
        {
            EntityModel dwSecurityUserModel 
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.dwSecurityUser, Constants.Level.NoJoins);
            DynamicEntity user = (await dwSecurityUserModel.GetAsync(Filter.And.Equal(userId, Constants.FieldName.Id))).FirstOrDefault();
            string email = (string)user?[Constants.FieldName.Email];
            if (email != null)
            {
                pars = (pars==null) ? new Dictionary<string,string>() : new Dictionary<string, string>(pars); //copy so we don't mutate original
                pars?.Add("Name", (string)user[Constants.FieldName.Name]);
                MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                string appName = await SettingsHelper.Common.GetApplicationName();
                await Email.FormSendAsync(
                    mailSettings: mailSettings,
                    new string[] { email },
                    mailCc: null,
                    mailBcc: null,
                    formName: templateName,
                    parameters: pars,
                    senderDisplayName: appName);
            }
        }

        /// <summary>
        /// Send an email to the specified user based on content template in a form.
        /// It is safe to pass a null user. No action will be taken. 
        /// Name of the current user will be included in substitution parameters under the key "Name".
        /// If you need to send more than one mail then don't use this method. Get the mail settings yourself and work directly with
        /// the FormSendAsync method in swz.Clover.Core.Utils.Email please.
        /// </summary>
        /// <param name="user">Recipient Security.User (may be null in which case no email is sent)</param>
        /// <param name="pars">Substitution parameters (may be null)</param>
        /// <param name="templateName">Name of the Form that provides the content template</param>
        /// <returns></returns>
        public static async Task SendUserEmailByFormTemplate(
            swz.Clover.Core.Security.User user,
            Dictionary<string, string> pars,
            string templateName)
        {
            if (user?.Email != null)
            {
                pars = (pars == null) ? new Dictionary<string, string>() : new Dictionary<string, string>(pars); //copy so we don't mutate original
                pars?.Add("Name", user.Name);
                MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
                string appName = await SettingsHelper.Common.GetApplicationName();
                await Email.FormSendAsync(
                    mailSettings: mailSettings,
                    new string[] { user.Email },
                    mailCc: null,
                    mailBcc: null,
                    formName: templateName,
                    parameters: pars,
                    senderDisplayName: appName);
            }
        }
    }
}
