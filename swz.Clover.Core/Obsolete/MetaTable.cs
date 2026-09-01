using System;
using System.Collections.Generic;

namespace swz.Clover.Core.Base
{
    public class MetaTable //TODO Remove
    {

        public string SchemeName;
        public string TableName;
        public List<MetaColumn> Columns = new List<MetaColumn>();

    }

    public class MetaColumn //TODO Remove
    {
      
        public string Caption { get; set; }
        public string ColumnName { get; set; }
        public string DataType { get; set; }
        public string DefaultValue { get; set; }
        public bool IsNullable { get; set; }
        public bool IsPrimaryKey { get; set; }
        public string CharacterMaxLength { get; set; }
         public bool IsCreateConstraint { get; set; }
        public bool IsDeleteCascade { get; set; }
        public bool IsUpdateCascade { get; set; }

        public string RefSchemeName { get; set; }
        public string RefTableName { get; set; }

    }

 
}
