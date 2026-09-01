using System;
using System.Collections.Generic;

namespace swz.Clover.Core.Metadata
{
    public class DataModel : IMetadataItem 
    {
        public Guid Id;
        public string Name;
        public string DbObjectName;
        public string SchemaName;
        public List<CodeActionTriggers> Triggers;
        
        public List<MetadataAttribute> Attributes;
        
        public string PrimaryKeyAttribute;
        public string VersionAttribute;
        public string LogicalDeleteAttribute;
        public string ExtensionsContainerAttribute;
        
        public int FindInCollectionByKey<T>(List<T> coll) where T : IMetadataItem 
            => coll.FindIndex(c => (c as DataModel)?.Id == Id);
    }
}