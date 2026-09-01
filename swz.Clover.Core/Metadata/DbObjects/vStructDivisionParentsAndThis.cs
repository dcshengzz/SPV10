using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public class vStructDivisionParentsAndThis : DbObject<vStructDivisionParentsAndThis>
    {
        public vStructDivisionParentsAndThis() : base(true)
        {
        }

        [DbObjectModel]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

        [DbObjectModel]
        public Guid? ParentId
        {
            get => _entity.ParentId;
            set => _entity.ParentId = value;
        }

        /// <summary>
        /// Get all child struct division id by user sturct division id (parent)
        /// </summary>
        /// <param name="userStuctDivisionId">user struct division id</param>
        /// <returns>List of child sturct division id</returns>
        public static async Task<List<Guid>> GetByParentStructId(Guid userStuctDivisionId)
        {
            var filter = Filter.And.Equal(userStuctDivisionId, "ParentId");
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result.Select(p => p.Id).Distinct().ToList() : null;
        }

        /// <summary>
        /// Get all parent struct id from a child struct id
        /// </summary>
        /// <param name="stuctDivisionId"></param>
        /// <returns></returns>
        public static async Task<List<Guid>> GetByChildStructId(Guid stuctDivisionId)
        {
            var filter = Filter.And.Equal(stuctDivisionId, "Id");
            var result = await SelectAsync(filter).ConfigureAwait(false);
            var listGuid = result.Where(x => x.ParentId != null).ToList();
            return listGuid.Count > 0 ? listGuid.Select(p => p.ParentId.Value).Distinct().ToList() : null;
        }

    }
}
