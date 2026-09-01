using System;
using System.Collections.Generic;

namespace swz.Clover.Core.Metadata
{
    public enum CodeActionType
    {
        Filter = 0,
        Action = 1,
        Trigger = 2
       
    }
    
    public class CodeAction : IMetadataItem
    {
        public Guid Id;
        public string Name;
        public string Comment;
        public bool DefinedOnServer;
        public CodeActionType Type;
        public string Source;
        public string Usings;
        public bool IsAsync;
        
        public int FindInCollectionByKey<T>(List<T> coll) where T : IMetadataItem 
            => coll.FindIndex(c => (c as CodeAction)?.Id == Id);
    }

    public static class CodeActionTriggerType
    {
        public const string Validate = "Validate";
        public const string AfterSelect = "AfterSelect";
        public const string BeforeInsert = "BeforeInsert";
        public const string AfterInsert = "AfterInsert";
        public const string BeforeUpdate = "BeforeUpdate";
        public const string AfterUpdate = "AfterUpdate";
        public const string BeforeDelete = "BeforeDelete";
        public const string AfterDelete = "AfterDelete";
        public const string AfterNew = "AfterNew";
    }
    
    
    public class CodeActionTriggers
    {
        public List<string> Triggers;
        public string CodeAction;
        public string Parameter;
    }
}