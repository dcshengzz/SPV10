using System;
using swz.Clover.Core.Exceptions;

namespace swz.Clover.Core.Model
{
    public class JoinedAttributeModel : AttributeModel
    {
        internal bool UseNameAsPropertyName { get; set; }
        
        public string TableAlias => string.Format("{0}_table", Parent.PropertyName);

        public override string PropertyName => UseNameAsPropertyName ? Name : $"{Parent.PropertyName}_{Name}";

        public AttributeModel Parent { get; internal set; }

        public int Level
        {
            get
            {
                if (Parent is JoinedAttributeModel model)
                    return model.Level + 1;
                return 1;
            }
        }

        public PlainAttributeModel Root
        {
            get
            {
                if (Parent == null)
                    return null;
                if (Parent is PlainAttributeModel plain)
                    return plain;
                var joined = Parent as JoinedAttributeModel;
                return joined?.Root;
            }
        }

    }
}
