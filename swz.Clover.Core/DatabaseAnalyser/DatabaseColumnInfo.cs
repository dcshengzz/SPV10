namespace swz.Clover.Core.DatabaseAnalyser
{
    public class DatabaseColumnInfo
    {
        public string TableSchema { get; set; }
        public string TableName { get; set; }
        public string ColumnName { get; set; }
        public string Default { get; set; }
        public bool IsNullable { get; set; }
        public string DataType { get; set; }
        public string CharacterMaxLength { get; set; }
        public string ConstraintName { get; set; }
        public string RefConstraintName { get; set; }
        public string RefTableSchema { get; set; }
        public string RefTableName { get; set; }
        public bool IsUpdateCascade { get; set; }
        public bool IsDeleteCascade { get; set; }
    }
}
