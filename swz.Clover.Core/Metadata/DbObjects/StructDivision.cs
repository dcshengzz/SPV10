using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.ORM;

namespace swz.Clover.Core.Metadata.DbObjects
{
    /// <summary>
    /// SurveyPlus UI would refer to the StructDivision as "Organisation".
    /// For the hosted solution it is used to silo individual customers. 
    /// Agency deployments use it to model departments and maybe certain third parties.
    /// </summary>
    public class StructDivision : DbObject<StructDivision>
    {
        public const string Column_Id = "Id";
        public const string Column_Name = "Name";
        public const string Column_ParentId = "ParentId";

        public StructDivision() : base(true)
        {
        }

        [DbObjectModel(IsKey = true)]
        public Guid Id { get => _entity.Id; set => _entity.Id = value; }

        [DbObjectModel]
        public string Name { get => _entity.Name; set => _entity.Name = value; }

        [DbObjectModel]
        public Guid? ParentId { get => _entity.ParentId; set => _entity.ParentId = value; }

        /// <summary>
        /// Get a list of StructDivision objects including and under specified StructDivision.
        /// </summary>
        /// <param name="selectedStructDivisionId">root of subtree</param>
        /// <returns>List of StructDivision appicable to specified parent StructDivision ordered by Name</returns>
        public static async Task<List<StructDivision>> SelectChildrenAndThisAsync(Guid structDivisionId)
        {
            List<Guid> childrenStructDivisionIds = await SelectChildrenAndThisIdListAsync(structDivisionId);
            Filter byChildrenStructDivisionIds = Filter.And.In(childrenStructDivisionIds, Column_Id);
            Order orderByName = Order.StartAsc(Column_Name);
            return await SelectAsync(byChildrenStructDivisionIds, orderByName);
        }

        /// <summary>
        /// Return a list (in no specific order) of StructDivision Id Guids for the struct divisions of the specified 
        /// struct division subtree. This method is mostly useful when you need the ids in List form to use with an In filter.
        /// </summary>
        /// <param name="selectedStructDivisionId">root of subtree</param>
        /// <returns>list of struct division id guids</returns>
        public static async Task<List<Guid>> SelectChildrenAndThisIdListAsync(Guid structDivisionId)
        {
            List<Guid> childrenStructDivisionIds
                = (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(structDivisionId, Column_ParentId)))
                    .Select(p => p.Id)
                    .Distinct()
                    .ToList();
            return childrenStructDivisionIds;
        }

        /// <summary>
        /// Return an unordered set of StructDivision Id Guids for the sub-tree of the specified 
        /// organisation. Use method when you just want to compare an id with this set.
        /// n.b. You may now prefer to work with the IsInStructDivision convenience method on Security.User 
        /// </summary>
        /// <param name="selectedStructDivisionId">root of organisation subtree (required)</param>
        /// <returns>set of struct division Id guids</returns>
        public static async Task<HashSet<Guid>> SelectChildrenAndThisIdSetAsync(Guid structDivisionId)
        {
            List<vStructDivisionParentsAndThis> subtree
                = (await vStructDivisionParentsAndThis.SelectAsync(Filter.And.Equal(structDivisionId, Column_ParentId)));
            //ToHashSet method isn't available in NetStandard2.0 so we'll do it ourselves
            HashSet<Guid> ids = new HashSet<Guid>();
            foreach (vStructDivisionParentsAndThis structDivision in subtree) ids.Add(structDivision.Id);
            return ids;
        }

        /// <summary>
        /// Convenience method to call SelectChildrenAndThisIdSetAsync with the StructDivisionId of the specified
        /// user. Note that if the user reference is null or it has a null StructDivisionId then 
        /// this method will always return an empty set
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        /// <exception cref="ArgumentNullException"></exception>
        public static async Task<HashSet<Guid>> SelectChildrenAndThisIdSetAsync(Security.User user)
        {
            if (user == null || user.StructDivisionId == null) return new HashSet<Guid>();
            return await SelectChildrenAndThisIdSetAsync((Guid)user.StructDivisionId);
        }

        /// <summary>
        /// Get the root organisation
        /// </summary>
        public static async Task<StructDivision> SelectRoot()
        {
            Filter filter = Filter.And
                .Equal((string)null, Column_ParentId) //ORM will use IS NULL in its SQL :-)
                .NotEqual(Guid.Empty, Column_Id); //ignore 00000000-0000-0000-0000-000000000000
            List<StructDivision> results = await StructDivision.SelectAsync(filter);
            if (!results.Any())
                throw new InvalidOperationException("No root organisation was found");
            else if (results.Count > 1)
                throw new InvalidOperationException($"Multiple root organisations were found: {String.Join(',', results.Select(r => r.Id).ToList())}");
            else
                return results.FirstOrDefault();
        }
    }
    
}