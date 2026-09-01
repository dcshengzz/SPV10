using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Security;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication
{
    public static class StyleApplication
    {
        //private static readonly ILogger Logger = DefaultApplicationLogging.CreateLogger(typeof(StyleApplication));

        public static async Task<int> ValidateQnnStyleForm(DynamicEntity data, User user)
        {
            ArgumentNullException.ThrowIfNull(data, nameof(data));
            ArgumentNullException.ThrowIfNull(user, nameof(user));

            //Verify user has rights for this organisation
            Guid structDivisionId = (Guid)data[Constants.FieldName.StructDivisionId];
            HashSet<Guid> allowedOrganisations
                = await StructDivision.SelectChildrenAndThisIdSetAsync(user.StructDivisionId.Value);
            if (!allowedOrganisations.Contains(structDivisionId)) return 2;

            //Required field checks (note that data is based on the component id in the form)
            string name = (string)data[Constants.FieldName.Name];
            if (string.IsNullOrWhiteSpace(name) || name.Length > 100) return 101;
            return 0;
        }
    }
}
