using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices.ComTypes;
using swz.Clover.Core.Exceptions;

namespace swz.Clover.Core.Model
{
    public abstract class AttributeModel
    {
        public DataModel DataModel { get; protected set; }

        public DataModel ReferencedDataModel { get; internal set; }

        public bool IsReference => ReferencedDataModel != null;

        public bool IsExtension { get; internal set; }

        public bool IsExtensionsContainer =>
            DataModel.ExtensionsContainerAttributeName != null && DataModel.ExtensionsContainerAttributeName.Equals(ColumnName, StringComparison.Ordinal);

//        public bool HasChildren => _children.Count > 0;
//
//        public byte GetChildLevel()
//        {
//            if (!HasChildren)
//                return 1;
//
//            byte maxDepth = 1;
//
//            foreach (var child in Children)
//            {
//                var depth = child.GetChildLevel();
//
//                if (maxDepth < depth)
//                    maxDepth = depth;
//            }
//
//            return (byte) (maxDepth + 1);
//        }

//        public List<JoinedAttributeDescription> GetChildrenRecursive
//        {
//            get { var result = new List<JoinedAttributeDescription>();
//            
//                AddChildsRecursive(result);
//
//                return result;
//            }
//        }
//
//        private void AddChildsRecursive(List<JoinedAttributeDescription> childs)
//        {
//                childs.AddRange(_children);
//
//                foreach (var child in Children)
//                {
//                    if (child.HasChildren)
//                        child.AddChildsRecursive(childs);
//                }
//        }


        public IEnumerable<JoinedAttributeModel> Children => _children;

        private readonly List<JoinedAttributeModel> _children = new List<JoinedAttributeModel>();

        internal void AddChild(JoinedAttributeModel attribute)
        {
            if (!_children.Contains(attribute))
                _children.Add(attribute);
        }

        public AttributeType Type { get; internal set; }

        public string ColumnName { get; private set; }

        public string Name { get; private set; }
        public bool IsVirtual { get; internal set; }
        public bool IsCalculated { get; internal set; }

        public bool IsPrimaryKey => DataModel.PrimaryKeyAttributeName != null && DataModel.PrimaryKeyAttributeName.Equals(ColumnName, StringComparison.Ordinal);

        public bool IsMainPrimaryKey => this is PlainAttributeModel && IsPrimaryKey;

        public bool IsVersion => DataModel.VersionAttributeName != null && DataModel.VersionAttributeName.Equals(ColumnName, StringComparison.Ordinal);

       // public bool IsParentId => DataModel.ParentIdAttributeName != null && DataModel.ParentIdAttributeName.Equals(ColumnName, StringComparison.Ordinal);

        public bool IsLogicalDelete => DataModel.LogicalDeleteAttributeName != null && DataModel.LogicalDeleteAttributeName.Equals(ColumnName, StringComparison.Ordinal);


        public abstract string PropertyName { get; }


        public static PlainAttributeModel CreatePlainAttribute(string name, DataModel dataModel, AttributeType type, string columnName = null, bool isVirtual = false,
            bool isCalculated = false, bool isExtension = false)
        {
            var attr = new PlainAttributeModel
            {
                ColumnName = columnName ?? name,
                Name = name,
                DataModel = dataModel,
                Type = type,
                IsCalculated = isCalculated,
                IsVirtual = isVirtual,
                IsExtension = isExtension
            };

            return attr;
        }


        public static PlainAttributeModel CreatePlainReferenceAttribute(string name, DataModel dataModel, DataModel referencedModelModel, AttributeType type,
            string columnName = null, bool isVirtual = false, bool isCalculated = false, bool isExtension = false)
        {
            var attr = CreatePlainAttribute(name, dataModel, type, columnName, isVirtual, isCalculated, isExtension);
            attr.ReferencedDataModel = referencedModelModel;
            return attr;
        }


        public static JoinedAttributeModel CreateJoinedAttribute(string name, AttributeModel parent, AttributeType type,
            string columnName = null, bool isVirtual = false, bool isCalculated = false, bool isExtension = false)
        {
            if (parent == null) throw new ArgumentNullException(nameof(parent));
            if (string.IsNullOrEmpty(name)) throw new ArgumentException("Value cannot be null or empty.", nameof(name));
            if (!parent.IsReference)
                throw new DynamicEntitiesException($"Attribute {parent.PropertyName} can't be a parent attribute");

            var attr = new JoinedAttributeModel()
            {
                ColumnName = columnName ?? name,
                Name = name,
                DataModel = parent.ReferencedDataModel,
                Parent = parent,
                Type = type,
                IsCalculated = isCalculated,
                IsVirtual = isVirtual,
                IsExtension = isExtension
            };

            parent.AddChild(attr);
            return attr;
        }
        
        public static JoinedAttributeModel CreateJoinedAttribute(string name, DataModel dataModel, AttributeType type,
            string columnName = null, bool isVirtual = false, bool isCalculated = false, bool isExtension = false)
        {
           if (string.IsNullOrEmpty(name)) throw new ArgumentException("Value cannot be null or empty.", nameof(name));
          
            var attr = new JoinedAttributeModel()
            {
                ColumnName = columnName ?? name,
                Name = name,
                DataModel = dataModel,
                Type = type,
                IsCalculated = isCalculated,
                IsVirtual = isVirtual,
                IsExtension = isExtension
            };

             return attr;
        }

     
        public static JoinedAttributeModel CreateJoinedReferenceAttribute(string name, AttributeModel parent, DataModel referencedModelModel, AttributeType type,
            string columnName = null, bool isVirtual = false, bool isCalculated = false, bool isExtension = false)
        {
            var attr = CreateJoinedAttribute(name, parent, type, columnName, isVirtual, isCalculated, isExtension);
            attr.ReferencedDataModel = referencedModelModel;
            return attr;
        }
        
        public static JoinedAttributeModel CreateJoinedReferenceAttribute(string name, DataModel dataModel, DataModel referencedModelModel, AttributeType type,
            string columnName = null, bool isVirtual = false, bool isCalculated = false, bool isExtension = false)
        {
            var attr = CreateJoinedAttribute(name, dataModel, type, columnName, isVirtual, isCalculated, isExtension);
            attr.ReferencedDataModel = referencedModelModel;
            return attr;
        }
    }
}
