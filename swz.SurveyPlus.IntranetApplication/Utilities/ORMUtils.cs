using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Utilities
{
    public static class ORMUtils
    {
        /// <summary>
        /// Perform entity lookup and type verification of optional model
        /// Intended for use by utility methods for fetching specific entity,
        /// NOT suggested to use directly in your business logic code
        /// (You should use/implement a type specific method calling this instead)
        /// </summary>
        /// <param name="id">entity primary key, may not be empty</param>
        /// <param name="modelName">name of the entity model, required</param>
        /// <param name="model">optional model to use (type will be validated), uses a NoJoins fetch if not supplied</param>
        /// <returns>entity or null</returns>
        public static async Task<DynamicEntity> GetEntityById(Guid id, string modelName, EntityModel model = null)
        {
            if (Guid.Empty.Equals(id))
                throw new ArgumentException("may not be empty", nameof(id));
            if (String.IsNullOrWhiteSpace(modelName))
                throw new ArgumentException("must be specified", nameof(modelName));
            if (model == null)
            {
                model
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(modelName, Constants.Level.NoJoins);
            }
            else if (!modelName.Equals(model.Name))
            {
                //If model was passed, verify its the one expected
                throw new ArgumentException("Expected model for " + modelName, "model");
            }
            Filter byId = Filter.And.Equal(id, Constants.FieldName.Id);
            DynamicEntity entity = (await model.GetAsync(byId)).FirstOrDefault();
            return entity;
        } //end of GetEntityById

        /// <summary>
        /// Get multiple entities given a list of Id. 
        /// Will return in the same order of the ids passed in, and will
        /// batch the retrieval to avoid potential issue with too many IN arguments. 
        /// Ids whose record is missing will not result in an exception.
        /// </summary>
        /// <param name="ids"></param>
        /// <param name="modelName"></param>
        /// <param name="model"></param>
        /// <returns>List of entities as per the specified ids in that order. List may be empty but never null.</returns>
        public static async Task<List<DynamicEntity>> GetEntitiesByIds(List<Guid> ids, string modelName, EntityModel model=null)
        {
            if (ids == null) throw new ArgumentNullException(nameof(ids));
            if (String.IsNullOrWhiteSpace(modelName))
                throw new ArgumentException("must be specified", nameof(modelName));
            if (model == null)
            {
                model
                    = await MetadataToModelConverter.GetEntityModelByModelAsync(modelName, Constants.Level.NoJoins);
            }
            else if (!modelName.Equals(model.Name))
            {
                //If model was passed, verify its the one expected
                throw new ArgumentException("Expected model for " + modelName, "model");
            }

            List<DynamicEntity> entities = new List<DynamicEntity>();
            const int take = 500;
            for (int skip=0; skip < ids.Count; skip = skip + take)
            {
                List<Guid> subsetIds = ids.Skip(skip).Take(take).ToList();
                Dictionary<Guid, DynamicEntity> entitiesById
                    = (await model.GetAsync(Filter.And.In(subsetIds, Constants.FieldName.Id)))
                    .ToDictionary(e => (Guid)e[Constants.FieldName.Id], e => e);
                foreach(Guid id in subsetIds)
                {   //Add to the list in the order the ids were passed to us
                    entities.Add(entitiesById[id]);
                }
            }
            return entities;
        }

    }
}
