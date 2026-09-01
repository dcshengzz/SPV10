using System.Collections.Generic;
using System.Linq;

namespace swz.Clover.Core.ORM
{
    /// <summary>
    /// Represents the result of any modifying query
    /// </summary>
    public sealed class ModifyingQueryResult
    {
        /// <summary>
        /// Number of changed rows by the query
        /// </summary>
        public long AffectedRowsCount { get; }

        private Dictionary<object, Dictionary<string, object>> _calculatedColumns;

        public ModifyingQueryResult(long affectedRowsCount) : this (affectedRowsCount,new Dictionary<object, Dictionary<string, object>>())
        {
        }

        public ModifyingQueryResult(long affectedRowsCount, Dictionary<object, Dictionary<string, object>> calculatedColumns)
        {
            AffectedRowsCount = affectedRowsCount;
            _calculatedColumns = calculatedColumns;
        }

        public bool ContainsCalculatedColumnValues => _calculatedColumns.Any();

        public bool ContainsCalculateColumnsValuesForId(object id)
        {
            return _calculatedColumns.ContainsKey(id);
        }
        
        public Dictionary<string, object> GetCalculateColumnsValuesById(object id)
        {
            return _calculatedColumns[id];
        }
    }
}