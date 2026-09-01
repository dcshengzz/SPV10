using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core.ORM
{
    public abstract class SQLQueryObject
    {
        protected readonly SQLProvider SQLProvider;

        protected virtual FilterPurpose FilterPurpose => FilterPurpose.Other;

        protected SQLQueryObject(SQLProvider sqlProvider)
        {
            SQLProvider = sqlProvider;
        }

        public DbCommand BuildCommand(DbCommand command)
        {
            command.CommandText = BuildCommandText();
            AddCommandParameters(command);
            return command;
        }

        public abstract string BuildCommandText();

        protected abstract void AddCommandParameters(DbCommand command);

        protected void AddFilterCommandParameters(DbCommand command, EntityModel model, Filter filter)
        {
            var properties = filter.GetParametersWithValues();
            foreach (var property in properties)
            {
                var columnAndValue = property.Value;
                object dbType;
                var typeOfValue = columnAndValue.value.GetType();
                var value = columnAndValue.value;
                var attribute = property.Value.attribute ?? model.GetAttributeByName(property.Value.propertyName);

                if (attribute != null)
                {
                    var isString = typeOfValue == typeof(string);
                    var isEnumerable = typeOfValue.IsEnumerable() && !isString && typeOfValue != typeof(byte[]);

                    dbType = SQLProvider.DbCommunication.ConvertToDbType(attribute.Type.CLRType, isEnumerable);
                }
                else
                {
                    dbType = SQLProvider.DbCommunication.ConvertToDbType(typeOfValue);

                }

                SQLProvider.DbCommunication.AddParameter(command, property.Key, value, dbType);
            }
        }



        protected virtual StringBuilder BuildWhereClause(Filter filter, EntityModel model, StringBuilder query)
        {
            string filterString = filter.Prepare(model).ToStringAsParameters((FilterPurpose,null));
            if (!string.IsNullOrEmpty(filterString))
                query.AppendFormat("WHERE {0} ", filterString);

            return query;
        }
    }
}
