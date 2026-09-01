using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.IO.Pipes;
using System.Linq;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.ORM
{
    public abstract class ModifyingQueryObject : SQLQueryObject
    {
        protected string TableName;
        protected string SchemaName;
        protected IEnumerable<ChangePart> Changes;
        protected IEnumerable<AttributeModel> AttributesForUpdate;
        protected internal readonly EntityModel Model;

        protected ModifyingQueryObject(SQLProvider sqlProvider, EntityModel model, string modelForUpdateName, IEnumerable<ChangePart> changes) : base(sqlProvider)
        {
            AttributesForUpdate = model.Attributes.Where(a => !a.IsVirtual && !a.IsCalculated && a.DataModel.Name.Equals(modelForUpdateName, StringComparison.Ordinal))
                .ToList();
            TableName = model.TableName;
            SchemaName = model.SchemaName;

            var changeParts = changes as IList<ChangePart> ?? changes.ToList();
            if (changeParts.Count() != changeParts.Select(c => c.PropertyName).Distinct().Count())
                throw new InvalidOperationException();

            Changes = changeParts;
            Model = model;
        }

        protected override void AddCommandParameters(DbCommand command)
        {
            foreach (var change in Changes)
            {
                var attribute = AttributesForUpdate.SingleOrDefault(a => a.PropertyName.Equals(change.PropertyName, StringComparison.OrdinalIgnoreCase));
                if (attribute == null || attribute.IsExtensionsContainer)
                    continue;
                object newValue = DBNull.Value;
                if (change.NewValue is string && attribute.Type.CLRType != typeof(string))
                {
                    newValue = attribute.Type.ParseToCLRType(change.NewValue);
                }
                else if (change.NewValue != null)
                {
                    newValue = change.NewValue;
                }

                SQLProvider.DbCommunication.AddParameter(command, GetValueParameterName(attribute), newValue, attribute.Type);
            }

            //Here we need to add output parameters 
            if (CalculatedColumnsReturnType == CalculatedColumnsReturnType.AsParameters)
            {
                foreach (var plainCalculatedAttribute in Model.GetPlainCalculatedAttributes())
                {
                    SQLProvider.DbCommunication.AddOutputParameter(command, GetCalculatedParameterName(plainCalculatedAttribute), plainCalculatedAttribute.Type);
                }
            }

        }

        private const string ValueParameterPostfix = "__value";

        protected string GetValueParameterName(AttributeModel attribute)
        {
            return $"{attribute.PropertyName}{ValueParameterPostfix}";
        }

        // ReSharper disable once StringLiteralTypo
        private const string RetValueParameterPostfix = "__retvalue";

        protected string GetCalculatedParameterName(AttributeModel attribute)
        {

            return $"{attribute.PropertyName}{RetValueParameterPostfix}";
        }

        protected bool IsOutputParameter(DbParameter parameter)
        {
            return parameter.Direction != ParameterDirection.Input && parameter.ParameterName.EndsWith(RetValueParameterPostfix);
        }


        protected (string name, object value) GetPropertyNameAndValue(DbParameter parameter)
        {
            if (!parameter.ParameterName.EndsWith(RetValueParameterPostfix))
                throw new ArgumentException($"Wrong parameter {parameter.ParameterName} for getting value");
            var name = parameter.ParameterName.Substring(0, parameter.ParameterName.Length - RetValueParameterPostfix.Length);
            var attribute = Model.GetAttributeByName(name);
            var parameterValue = GetValueFromParameter(parameter);
            var value = parameterValue != DBNull.Value ? attribute.Type.CastToCLRType(parameterValue) : null;

            return (name, value);
        }

        protected virtual object GetValueFromParameter(DbParameter parameter)
        {
            return parameter.Value;
        }


        public Dictionary<string, object> GetOutputParameters(DbCommand command)
        {
            var res = new Dictionary<string, object>();
            foreach (DbParameter parameter in command.Parameters)
            {
                if (!IsOutputParameter(parameter))
                    continue;
                var propertyAndValue = GetPropertyNameAndValue(parameter);
                res.Add(propertyAndValue.name, propertyAndValue.value);
            }

            return res;
        }

      

        protected virtual CalculatedColumnsReturnType BaseCalculatedColumnsReturnType => CalculatedColumnsReturnType.None;

        public CalculatedColumnsReturnType CalculatedColumnsReturnType => Model.HasPlainCalculatedAttributes ? BaseCalculatedColumnsReturnType : CalculatedColumnsReturnType.None;
    }

}
