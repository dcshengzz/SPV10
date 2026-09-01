using System;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.ORM
{
    /// <summary>
    /// The base class for Primary key generation logic
    /// </summary>
    public class PrimaryKeyGenerator
    {
        protected internal IDbProvider Provider { get; internal set; }

        public PrimaryKeyGenerator(IDbProvider provider)
        {
            Provider = provider;
        }

        public PrimaryKeyGenerator()
        {
        }

        public virtual object Generate(EntityModel model, DynamicEntity entity)
        {
            if (!model.HasPrimaryKey)
                return null;

            if (model.PrimaryKeyAttribute.IsCalculated)
                return null;

            if (model.PrimaryKeyAttribute.Type.OriginalCLRType == typeof(Guid))
            {
                return Provider.GenerateGuid();
            }

#pragma warning disable 618
            return CloverRuntime.GeneratePrimaryKey(model.PrimaryKeyAttribute);
#pragma warning restore 618
        }
            
    }
}