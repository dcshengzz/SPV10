using System;
using System.Collections.Generic;

namespace swz.Clover.Core.Metadata
{
    public class Module : IMetadataItem
    {
        public Guid Id;
        public string Name;
        public string Comment;
        public List<string> Forms;
        public List<Guid> Entities;
        public List<string> Schemes;
        public List<string> BusinessFlows;
        public List<string> Roles;
        public Dictionary<string, string> Parameters;
        
        public int FindInCollectionByKey<T>(List<T> coll) where T : IMetadataItem 
            => coll.FindIndex(c => (c as Module)?.Id == Id);
    }
}