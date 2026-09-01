using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;
using System.Linq;
using System.Reflection;
using swz.Clover.Core;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core.Model
{
    public sealed class AttributeType 
    {
        #region LightweightImplementation

        private class Key
        {
            private readonly Type _clrType;

            private readonly bool _isNullable;

            public Key(Type clrType, bool isNullable)
            {
                _clrType = clrType;
                _isNullable = isNullable;
            }

            public override bool Equals(object obj)
            {
                var key = obj as Key;
                if (key == null)
                    return false;
                return _clrType == key._clrType && _isNullable == key._isNullable;
            }

            public override int GetHashCode()
            {
                return _clrType.GetHashCode() ^ _isNullable.GetHashCode();
            }
        }

        private static readonly object Lock = new object();

        private static readonly   Dictionary<Key, AttributeType> Types = new Dictionary<Key, AttributeType>();


        public static AttributeType Get(Type clrType, bool nullable)
        {
            var trueType = clrType;
            if (clrType.IsNullable())   //required to get underlying type for nullable type
            {
                trueType = clrType.GetUnderlyingType();
            }

            var key = new Key(trueType, nullable);

            if (Types.ContainsKey(key))
                return Types[key];

            lock (Lock)
            {
                if (Types.ContainsKey(key))
                    return Types[key];
                var attributeDescriptionType = new AttributeType(trueType, nullable);
                Types.Add(key,attributeDescriptionType);
                return attributeDescriptionType;
            }
        }

        #endregion

        private readonly MethodInfo _parseMethodInfo;
        private readonly NullableConverter _nullableConverter;
        public object DefaultValue { get; private set; }

        private AttributeType(Type clrType, bool nullable)
        {
            OriginalCLRType = clrType;
            CLRType = !nullable ? clrType : clrType.ToNullableType();
            IsNullable = nullable;

            if (nullable && clrType.GetTypeInfo().IsValueType)
            {
                CLRType = clrType.ToNullableType();
                _nullableConverter = new NullableConverter(CLRType);
            }
            else
            {
                CLRType = clrType;
            }

            _parseMethodInfo = clrType.GetMethod("Parse", new[] {typeof(string), typeof(IFormatProvider)}) ?? clrType.GetMethod("Parse", new[] {typeof(string)});
            if (_parseMethodInfo == null && clrType.IsNullable() && clrType.GenericTypeArguments.Length > 0)
            {
                _parseMethodInfo = clrType.GenericTypeArguments[0].GetMethod("Parse", new[] {typeof(string), typeof(IFormatProvider)}) ??
                                   clrType.GenericTypeArguments[0].GetMethod("Parse", new[] {typeof(string)});
            }

            if (IsNullable)
            {
                DefaultValue = null;
            }
            else
            {
                if (clrType.GetTypeInfo().IsValueType)
                    DefaultValue = Activator.CreateInstance(clrType);
                else
                    DefaultValue = null;

            }

        }

        public Type CLRType { get; }
        public Type OriginalCLRType { get; }
        
        public bool IsNullable { get; }
       

        public static AttributeType GetDefaultType(Type type)
        {
            return Get(type, type.IsNullable());
        }

        public object ParseToCLRType(object value)
        {
            return ParseToCLRType(value, CultureInfo.InvariantCulture);
        }

        public object ParseToCLRType(object value, CultureInfo culture)
        {
            if (value == null)
            {
                if (CLRType.IsNullable() || CLRType == typeof(string))
                {
                    return null;
                }
                if (!CLRType.IsNullable() && CLRType == typeof(Guid))
                {
                    return Guid.Empty;
                }

                throw new DynamicEntitiesParseException("Can not parse null to not nullable type {0}",CLRType.FullName);
            }
            
            if (CLRType.IsInstanceOfType(value))
                return value;

            var stringToParse = value.ToString();

            if (string.IsNullOrEmpty(stringToParse))
            {
                if (CLRType.IsNullable())
                    return null;
                if (CLRType == typeof (string))
                    return stringToParse;
                if (!CLRType.IsNullable() && CLRType == typeof(Guid))
                {
                    return Guid.Empty;
                }
                throw new DynamicEntitiesParseException("Can not parse emptyvalue to not nullable type {0}", CLRType.FullName);
            }
 
            if ((CLRType == typeof(bool) || CLRType == typeof(bool?)) && (stringToParse == "0" || stringToParse == "1"))
            {
                return stringToParse == "1";
            }

            if (_parseMethodInfo == null)
            {
                if (CLRType == typeof(byte[]) && value is string)
                {
                    return Convert.FromBase64String(value.ToString());
                }
                if (CLRType == typeof(string) && value is byte[])
                {
                    return Convert.ToBase64String(value as byte[]);
                }

                if (CLRType == typeof(string))
                    return stringToParse;
                
                throw new DynamicEntitiesParseException("Can not parse value ('{2}') of type {0} to type {1}", value.GetType().FullName, CLRType.FullName, value);
            }
                

            try
            {
                var parametersCount = _parseMethodInfo.GetParameters().Count();
                if (parametersCount == 2)
                    return _parseMethodInfo.Invoke(null, new object[] {stringToParse, culture});
                if (parametersCount == 1)
                    return _parseMethodInfo.Invoke(null, new object[] {stringToParse});
            }
            catch (Exception ex)
            {
                throw new DynamicEntitiesParseException(ex, "Can not parse value ('{2}') of type {0} to type {1}", value.GetType().FullName, CLRType.FullName, value);
            }

            throw new DynamicEntitiesParseException("Can not parse value ('{2}') of type {0} to type {1}", value.GetType().FullName, CLRType.FullName, value);
        }

       
        public object CastToCLRType(object value)
        {
            return CastToCLRType(value, CultureInfo.CurrentCulture);
        }

        public object CastToCLRType(object value, CultureInfo culture)
        {
            if (CLRType.IsNullable())
            {
                return CastToNullableType(value, culture);
            }

            if (value == null)
                throw new DynamicEntitiesConvertException("Can not cast null value to not nullable type {0}", CLRType.FullName);

            try
            {
                var sourceType = value.GetType();

                if (sourceType == typeof (byte[]) && CLRType == typeof (Guid)) //typical case for Oracle or MySql
                {
                    return new Guid((byte[])value);
                }
                if (sourceType == typeof (string) && CLRType == typeof (bool))
                {
                    var stringValue = (string) value;
                    if (stringValue.Equals("1", StringComparison.OrdinalIgnoreCase))
                        return true;
                    if (stringValue.Equals("0", StringComparison.OrdinalIgnoreCase))
                        return false;
                    throw new DynamicEntitiesConvertException("Can not cast from {0} to {1}", value.GetType().FullName, CLRType.FullName);
                }
                return Convert.ChangeType(value, CLRType, culture);
            }
            catch (Exception ex)
            {
                throw new DynamicEntitiesConvertException(ex, "Can not cast from {0} to {1}", value.GetType().FullName, CLRType.FullName);
            }

        }

        private object CastToNullableType(object value, CultureInfo culture)
        {
            if (value == null)
                return null;

            var sourceType = value.GetType();

            if (sourceType == typeof(byte[]) && OriginalCLRType == typeof(Guid)) //typical case for Oracle or MySql
            {
                value = new Guid((byte[])value);
                sourceType = value.GetType();
            }
            else if (sourceType == typeof(string) && OriginalCLRType == typeof(bool))
            {
                var stringValue = (string)value;
                if (stringValue.Equals("1", StringComparison.OrdinalIgnoreCase))
                {
                    value = true;
                    sourceType = value.GetType();
                }
                else if (stringValue.Equals("0", StringComparison.OrdinalIgnoreCase))
                {
                    value = false;
                    sourceType = value.GetType();
                }
                else throw new DynamicEntitiesConvertException("Can not cast from {0} to {1}", value.GetType().FullName, OriginalCLRType.FullName);
            }

            if (_nullableConverter.CanConvertFrom(sourceType))
            {
                return _nullableConverter.ConvertFrom(value);
            }

            //Пытаемся преобразовать в ненуллябельный тип
            try
            {
                object newValue = Convert.ChangeType(value, OriginalCLRType, culture);
                
                var newType = newValue.GetType();
                if (_nullableConverter.CanConvertFrom(newType))
                {
                    return _nullableConverter.ConvertFrom(newValue);
                }
            }
            catch (Exception ex)
            {
                throw new DynamicEntitiesConvertException(ex, "Can not cast from {0} to {1}", value.GetType().FullName, CLRType.FullName);
            }
            throw new DynamicEntitiesConvertException("Can not cast from {0} to {1}", sourceType.FullName, CLRType.FullName);
        }
    }
}
