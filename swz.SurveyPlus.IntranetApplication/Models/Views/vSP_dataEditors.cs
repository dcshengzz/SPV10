using swz.Clover.Core;
using swz.Clover.Core.ORM;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public class vSP_dataEditors : DbObject<vSP_dataEditors>
    {
        public vSP_dataEditors() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public string Name { get => _entity.Name; set => _entity.Name = value; }

        [DbObjectModel]
        public Guid StructDivisionId { get => _entity.StructDivisionId; set => _entity.StructDivisionId = value; }

        public static async Task<List<vSP_dataEditors>> GetByStructDivisionId(List<Guid> structDivisionIds)
        {
            Filter filter = Filter.And.In(structDivisionIds, Constants.FieldName.StructDivisionId);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result : null;
            
        }

    }
}
