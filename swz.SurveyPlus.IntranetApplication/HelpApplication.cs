using swz.Clover.Core;
using swz.Clover.Core.Security;
using swz.SurveyPlus.Application;
using System;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication
{
    public static class HelpApplication
    {
        public static async Task<int> ValidateQnnRespAdminForm(DynamicEntity data, User user)
        {
            ArgumentNullException.ThrowIfNull(data, nameof(data));
            ArgumentNullException.ThrowIfNull(user, nameof(user));

            string name = (string)data[Constants.FieldName.Name];
            if (string.IsNullOrWhiteSpace(name) || name.Length > 50) return 101;

            string type = (string)data[Constants.FieldName.Type];
            if (!("RespLogin" == type || "RespDashboard" == type)) return 102;

            DateTime? startDate = (DateTime?)data[Constants.FieldName.StartDate];
            if (startDate == null) return 103;

            DateTime? endDate = (DateTime?)data[Constants.FieldName.EndDate];
            if (endDate == null) return 104;

            if (endDate.Value < startDate.Value) return 105;

            return 0;
        }

        public static async Task<int> ValidateQnnHelpForm(DynamicEntity data, User user)
        {
            ArgumentNullException.ThrowIfNull(data, nameof(data));
            ArgumentNullException.ThrowIfNull(user, nameof(user));

            string topic = (string)data[Constants.FieldName.Topic];
            if (string.IsNullOrWhiteSpace(topic) || topic.Length > 200) return 101;

            string heading = (string)data[Constants.FieldName.Heading];
            if (string.IsNullOrWhiteSpace(heading) || heading.Length > 200) return 101;

            string type = (string)data[Constants.FieldName.Type];
            if (!("admin" == type || "resp" == type)) return 102;

            return 0;
        }
    }
}
