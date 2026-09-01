using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.ORM;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    /// <summary>
    /// Respondent Participation Report grid filter
    /// </summary>
    public class vSP_RespParticipation : DbObject<vSP_RespParticipation>
    {
        public vSP_RespParticipation() : base(true)
        {
        }

        [DbObjectModel]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public Guid StructDivisionId { get => _entity.StructDivisionId; set => _entity.StructDivisionId = value; }

        [DbObjectModel]
        public string Name { get => _entity.Name; set => _entity.Name = value; }

        [DbObjectModel]
        public string UID { get => _entity.UID; set => _entity.UID = value; }

        [DbObjectModel]
        public string RespondentName { get => _entity.RespondentName; set => _entity.RespondentName = value; }

        [DbObjectModel]
        public Guid StatusId { get => _entity.StatusId; set => _entity.StatusId = value; }

        [DbObjectModel]
        public string Status { get => _entity.Status; set => _entity.Status = value; }

        [DbObjectModel]
        public DateTime StatusDate { get => _entity.StatusDate; set => _entity.StatusDate = value; }

        [DbObjectModel]
        public Guid? RespId { get => _entity.RespId; set => _entity.RespId = value; }

        private static readonly ILogger _logger = DefaultApplicationLogging.CreateLogger(typeof(vSP_RespParticipation));

        public static async Task<List<vSP_RespParticipation>> GridFilter(string uid, string respName, List<Guid> statusIds, List<Guid> dplyIds, Clover.Core.Security.User user)
        {
            try
            {
                Filter filter = Filter.Empty;

                if (!string.IsNullOrEmpty(uid))
                    filter = filter.Merge(Filter.And.LikeRightLeft(uid, Constants.FieldName.UID));

                if (!string.IsNullOrEmpty(respName))
                    filter = filter.Merge(Filter.And.LikeRightLeft(respName, Constants.FieldName.RespondentName));

                if (statusIds != null && statusIds.Any())
                    filter = filter.Merge(Filter.And.In(statusIds, Constants.FieldName.StatusId));

                if (dplyIds != null && dplyIds.Any())
                    filter = filter.Merge(Filter.And.In(dplyIds, Constants.FieldName.Id));

                Guid? userId = user?.Id;
                if (userId == null || userId == Guid.Empty)
                    throw new AccessViolationException("Unable to identify current login user. Please contact system administrator");

                List<Guid> structDivisionIdList = await SecurityUser.GetStructIdWithChildStructIdByUserId((Guid)userId);

                //Must have, if not user might access any other division data.
                if (structDivisionIdList != null && structDivisionIdList.Any())
                    filter = filter.Merge(Filter.And.In(structDivisionIdList, Constants.FieldName.StructDivisionId));
                else
                    throw new AccessViolationException("Unable to identify current login user. Please contact system administrator");

                List<vSP_RespParticipation> result = await SelectAsync(filter).ConfigureAwait(false);
                return result.Count > 0 ? result : null;
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(GridFilter) + " - caught unexpected exception");
            }
            return null;
        }
    }
}
