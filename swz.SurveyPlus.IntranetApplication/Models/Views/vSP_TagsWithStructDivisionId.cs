using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.ORM;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class vSP_TagsWithStructDivisionId : DbObject<vSP_TagsWithStructDivisionId>
    {
        public vSP_TagsWithStructDivisionId() : base(true)
        {
        }

        [DbObjectModel]
        public string Tags { get => _entity.Tags; set => _entity.Tags = value; }

        [DbObjectModel]
        public Guid StructDivisionId { get => _entity.StructDivisionId; set => _entity.StructDivisionId = value; }

        private static readonly ILogger _logger = DefaultApplicationLogging.CreateLogger(typeof(vSP_TagsWithStructDivisionId));

        public static async Task<List<vSP_TagsWithStructDivisionId>> SearchTags(List<Guid> structDivisionIds, string search)
        {
            try
            {
                Filter filter = Filter.And
                    .In(structDivisionIds, Constants.FieldName.StructDivisionId)
                    .NestAnd()
                    .NotEqual(Null.Value, Constants.FieldName.Tags)
                    .LikeRightLeft(search, Constants.FieldName.Tags);
                List<vSP_TagsWithStructDivisionId> result = await SelectAsync(filter).ConfigureAwait(false);
                return result.Count > 0 ? result : null;
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(SearchTags) + " - caught unexpected exception");
            }
            return null;
        }
    }
}
