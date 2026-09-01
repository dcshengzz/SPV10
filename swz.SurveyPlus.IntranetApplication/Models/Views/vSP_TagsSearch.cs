using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.ORM;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class vSP_TagsSearch : DbObject<vSP_TagsSearch>
    {
        public vSP_TagsSearch() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public string Name { get => _entity.Name; set => _entity.Name = value; }

        [DbObjectModel]
        public Guid StructDivisionId { get => _entity.StructDivisionId; set => _entity.StructDivisionId = value; }

        [DbObjectModel]
        public string Tags { get => _entity.Tags; set => _entity.Tags = value; }

        [DbObjectModel]
        public string SourceTable { get => _entity.SourceTable; set => _entity.SourceTable = value; }

        private static readonly ILogger _logger = DefaultApplicationLogging.CreateLogger(typeof(vSP_TagsSearch));

        public static async Task<List<vSP_TagsSearch>> SearchTags(List<Guid> structDivisionIds,List<string> tagsToSearch)
        {
            try
            {
                Filter filter = Filter.And
                    .In(structDivisionIds, Constants.FieldName.StructDivisionId)
                    .NestAnd()
                    .NotEqual(Null.Value, Constants.FieldName.Tags);
                
                foreach(string tag in tagsToSearch)
                {
                    filter = filter.LikeRightLeft(tag, Constants.FieldName.Tags);
                }
                var result = await SelectAsync(filter).ConfigureAwait(false);
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
