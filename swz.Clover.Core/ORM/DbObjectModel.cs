using System;

namespace swz.Clover.Core.ORM
{
    public class DbObjectModelAttribute : Attribute
    {
        public bool IsKey = false;
        public bool IsLogicalDelete = false;
        public Type TableType = null;
        public string ParentPropertyName;
        public string ColumnName;
    }
}
