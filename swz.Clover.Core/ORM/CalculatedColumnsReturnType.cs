namespace swz.Clover.Core.ORM
{
    public enum CalculatedColumnsReturnType
    {
        None, //Deletes for all relational DBs
        AsParameters, //Inserts and Updates for Postgres and Oracle
        AsTableRow //Inserts and Updates for Postgres and Oracle
    }
}