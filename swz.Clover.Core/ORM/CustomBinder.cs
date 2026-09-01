using System;
using System.Dynamic;

namespace swz.Clover.Core.ORM
{
    public class CustomBinder : SetMemberBinder
    {
        public bool IsNotInitialization { get; set; }

        public CustomBinder(string name)
            : base(name, false)
        {
        }


        public override DynamicMetaObject FallbackSetMember(DynamicMetaObject target, DynamicMetaObject value, DynamicMetaObject errorSuggestion)
        {
            throw new NotImplementedException();
        }
    }
}
