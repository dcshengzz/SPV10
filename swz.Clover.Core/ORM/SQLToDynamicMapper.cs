using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core.ORM
{
 
   /// <summary>
    /// Transform SQL query result into dynamic entity
    /// </summary>
    /// 
    /// 
    public sealed class SQLToDynamicMapper
    {
        private readonly ILogger logger = DefaultApplicationLogging.CreateLogger<SQLToDynamicMapper>();

        private readonly EntityModel _model;

        public SQLToDynamicMapper(EntityModel model)
        {
            _model = model;
        }

        private readonly Dictionary<Type, Func<IDataReader, int, object>> _mapActions = new Dictionary
            <Type, Func<IDataReader, int, object>>
            {
                {
                    typeof(Int32),
                    (r, i) => r.GetInt32(i)
                },
                {
                    typeof(Int64),
                    (r, i) => r.GetInt64(i)
                },
                {
                    typeof(Int16),
                    (r, i) => r.GetInt16(i)
                },
                {
                    typeof(byte),
                    (r, i) => r.GetByte(i)
                },
                {
                    typeof(byte[]),
                    GetBytes
                },
                {
                    typeof(string),
                    (r, i) => r.GetString(i)
                },
                {
                    typeof(float),
                    (r, i) => r.GetFloat(i)
                },
                {
                    typeof(double),
                    (r, i) => r.GetDouble(i)
                },
                {
                    typeof(decimal),
                    (r, i) => r.GetDecimal(i)
                },
                {
                    typeof(DateTime),
                    (r, i) =>
                    {
                        var date = r.GetDateTime(i);
                        return new DateTime(date.Ticks, DateTimeKind.Local);
                    }

                },
                {
                    typeof(Guid),
                    (r, i) => r.GetGuid(i)
                },
            };

        /// <summary>
        /// Thrown by GetBytes() when transforming SQL query result to dynamic entity.
        /// You can refer to the inner exceptions for finer details on the cause.
        /// </summary>
        public class GetBytesException : Exception
        {
            public GetBytesException(string message, Exception innerException) : base(message, innerException) { }
        }

        private static byte [] GetBytes (IDataReader reader, int index)
        {
            //Fixed for SVP-06 for MPA SCR 2022-04-29
            try
            {
                var buffer = new byte[1024];

                using (var memoryStream = new MemoryStream())
                {
                    using (var writer = new BinaryWriter(memoryStream))
                    {
                        long startIndex = 0;
                        long count = reader.GetBytes(index, startIndex, buffer, 0, buffer.Length);

                        while (count == buffer.Length)
                        {
                            writer.Write(buffer);
                            writer.Flush();
                            startIndex += buffer.Length;
                            count = reader.GetBytes(index, startIndex, buffer, 0, buffer.Length);
                        }
                        writer.Write(buffer, 0, (int)count);
                        writer.Flush();

                        return memoryStream.ToArray();
                    }
                }
            }
            catch (IOException ioEx)
            {
                throw new GetBytesException("Failed to write bytes to stream from sql query result", ioEx);
            }
            catch (Exception e)
            {
                throw new GetBytesException("Unable to perform getbytes action to transform sql query result into dynamic entity.", e);
            }
        }

        public async Task<List<DynamicEntity>> Map(DbCommand command, bool useMetadataTypeForMapping = true, bool addMissingProperties = true)
        {
#if DEBUG
            StringBuilder sb = new StringBuilder();
            command.Parameters.Cast<DbParameter>()
                .ToList()
                .ForEach(p => sb.Append(
                    $"{p.ParameterName} = {p.Value}{Environment.NewLine}"));

            string sbString = sb.ToString();
            Debug.WriteLine("SQLToDynamicMapper.cs: " + sbString);

            if (logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace("Map: commandText={0}, parameters={1}", command?.CommandText, sbString);
            }
#endif
            var returnValue = new List<DynamicEntity>();

            try
            {
                using (var reader = await command.ExecuteReaderAsync(CommandBehavior.SequentialAccess).ConfigureAwait(false))
                {
                    while (await reader.ReadAsync().ConfigureAwait(false))
                    {
                        returnValue.Add(MapEntity(reader, useMetadataTypeForMapping, addMissingProperties));
                    }
                }
                return returnValue;
            }
            catch (Exception e)
            {
                throw new Exception($"Exception \"{e.Message}\" caught in SQLToDynamicMapper.cs for {command.CommandText}", e);
            }

        }



        private DynamicEntity MapEntity(IDataReader reader, bool useMetadataTypesForMapping,  bool addMissingProperties)
        {
            var returnItem = new DynamicEntity();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                var name = reader.GetName(i);

                if (name.Equals(Constants.PagingColumnName, StringComparison.OrdinalIgnoreCase))
                    continue;

                var attribute = CloverRuntime.DbProvider.GetAttributeByColumName(name, _model);

                var isMainPrimaryKey = attribute != null && attribute.IsMainPrimaryKey;

                //in a case when we haven't attributes we are using the name 
                var propertyName = attribute != null ? attribute.PropertyName : name;

                if (reader.IsDBNull(i))
                {
                    returnItem.TrySetMember(new CustomBinder(propertyName), null, isMainPrimaryKey);
                }
                else
                {
                    Func<IDataReader, int, object> action;

                    object value;

                    try
                    {
                        value = _mapActions.TryGetValue(reader.GetFieldType(i), out action) ? action.Invoke(reader, i) : reader.GetValue(i);
                    }
                    catch (InvalidCastException) // fix for Oracle casting issues
                    {
                        if (attribute != null)
                        {
                            value = _mapActions.TryGetValue(attribute.Type.OriginalCLRType, out action) ? action.Invoke(reader, i) : reader.GetValue(i);
                        }
                        else throw;
                    }

                    //in a case when we haven't attributes we are using the name 
                    if (attribute != null)
                    {
                        try
                        {

                            returnItem.TrySetMember(new CustomBinder(propertyName), useMetadataTypesForMapping ? attribute.Type.CastToCLRType(value)
                                    : value, isMainPrimaryKey);
                        }
                        catch (Exception ex)
                        {
                            throw new DynamicEntitiesMapException(_model?.Name ?? "Unknown", attribute.Name, ex.Message, ex);
                        }
                    }
                }
            }

            if (addMissingProperties)
                _model?.AddMissingProperties(returnItem,true);

            return returnItem;
        }
    }

}
