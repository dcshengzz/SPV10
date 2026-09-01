using System;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.ORM
{
    public abstract class BaseExpression
    {
        private string _propertyName;
        private AttributeModel _attribute;
        private string _customExpression;

        public string PropertyName
        {
            get => _propertyName;
            protected set
            {
                if (value == null)
                    return;
                
                _propertyName = value;
                _customExpression = null;
                if (_attribute != null && _propertyName != _attribute.PropertyName)
                    _attribute = null;
            }

        }

        public AttributeModel Attribute
        {
            get => _attribute;
            protected set
            {
                if (value == null)
                    return;
                    
                _propertyName = value.PropertyName;
                _attribute = value;
                _customExpression = null;
            }
        }

        public string CustomExpression
        {
            get => _customExpression;
            protected set
            {
                if (value == null)
                    return;
                
                _propertyName = null;
                _attribute = null;
                _customExpression = value;
            }
        }

        public bool IsCustomExpression => !string.IsNullOrEmpty(CustomExpression);

        public bool HasAttribute => Attribute != null;
        
        protected string GetTableAlias(string mainAlias = null)
        {
            return !string.IsNullOrEmpty(mainAlias) ? mainAlias : (Attribute is JoinedAttributeModel joined) ? joined.TableAlias : null;
        }

        public abstract BaseExpression Clone();
    }
}