using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.ORM;

//TODO - why is this SurveyPlus-specific class here in core?
namespace swz.Clover.Core.Metadata.DbObjects
{
    public class QNN_RULE : DbObject<QNN_RULE>
    {
        public QNN_RULE() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public Guid? StructDivisionId { get => _entity.StructDivisionId; set => _entity.StructDivisionId = value; }

        [DbObjectModel]
        public int NumberId { get => _entity.NumberId; set => _entity.NumberId = value; }

        [DbObjectModel]
        public string Name { get => _entity.Name; set => _entity.Name = value; }

        [DbObjectModel]
        public string Description { get => _entity.Description; set => _entity.Description = value; }

        [DbObjectModel]
        public string Validation { get => _entity.Validation; set => _entity.Validation = value; }
        
        [DbObjectModel]
        public Guid? CreatedBy { get => _entity.CreatedBy; set => _entity.CreatedBy = value; }

        [DbObjectModel]
        public DateTime? CreatedDate { get => _entity.CreatedDate; set => _entity.CreatedDate = value; }

        [DbObjectModel]
        public Guid? UpdatedBy { get => _entity.UpdatedBy; set => _entity.UpdatedBy = value; }

        [DbObjectModel]
        public DateTime? UpdatedDate { get => _entity.UpdatedDate; set => _entity.UpdatedDate = value; }

        [Obsolete]
        [DbObjectModel]
        public bool IsDeleted { get => _entity.IsDeleted; set => _entity.IsDeleted = value; }

        [Obsolete]
        [DbObjectModel]
        public Guid? DeletedBy { get => _entity.DeletedBy; set => _entity.DeletedBy = value; }

        [Obsolete]
        [DbObjectModel]
        public DateTime? DeletedDate { get => _entity.DeletedDate; set => _entity.DeletedDate = value; }

        [DbObjectModel]
        public string Comments { get => _entity.Comments; set => _entity.Comments = value; }

    }

    public static class QNN_RULE_CACHE
    {
        private static readonly ConcurrentDictionary<string, List<QNN_RULE>> CachedDisplayData = new ConcurrentDictionary<string, List<QNN_RULE>>();

        public static List<QNN_RULE> GetCacheDisplayData(Guid? structDivisionId)
        {
            if (structDivisionId != null && CachedDisplayData.ContainsKey(structDivisionId.ToString()))
            {
                if (CachedDisplayData.TryGetValue(structDivisionId.ToString(), out List<QNN_RULE> cachedData))
                    return cachedData;
            }

            return new List<QNN_RULE>();
        }

        public static void SetCacheDisplayData(List<QNN_RULE> data, Guid? structDivisionId)
        {
            if (structDivisionId != null)
            {
                CachedDisplayData.AddOrUpdate(structDivisionId.ToString(), data, (s, model) => model);
            }
        }

        /// <summary>
        /// Use this to clear the cache (DO NOT use the ConcurrentDictionary.Clear() method of the Cache object)
        /// </summary>
        public static void ClearCacheDisplayData()
        {
            CachedDisplayData.Clear();
        }

        /// <summary>
        /// Fetch the rules for the current user (uses an internal cache)
        /// </summary>
        /// <returns></returns>
        public static async Task<List<QNN_RULE>> GetRuleList()
        {
            Guid? structDivisionId = CloverRuntime.Security.CurrentUser?.StructDivisionId;
            List<QNN_RULE> result = GetCacheDisplayData(structDivisionId);
            if (result.Any()) return result;

            List<Guid> structDivisionIdList = (structDivisionId==null) //can it really be null though?
                ? new List<Guid>()
                : await StructDivision.SelectChildrenAndThisIdListAsync((Guid)structDivisionId);

            //Only include rules from user's related struct divisions
            Filter rulesFilter = Filter.And.In(structDivisionIdList, "StructDivisionId");
            result = await QNN_RULE.SelectAsync(rulesFilter, Order.StartAsc("Name"));

            SetCacheDisplayData(result, structDivisionId);

            return result;
        }
    }
}
