using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.Common;
using System.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.ORM
{
    public static class DbCommandExecutor
    {
        public static async Task<List<DynamicEntity>> ExecuteSelectAsync(string query, Dictionary<string, object> parameters = null, string connectionString = null)
        {
            using (var shared = new SharedTransaction(connectionString))
            {
                await shared.OpenConnectionAsync().ConfigureAwait(false);
                var connectionAndTransaction = shared.ConnectionAndTransaction;
                var connection = connectionAndTransaction.Connection;
                var transaction = connectionAndTransaction.Transaction;
                var command = CloverRuntime.DbProvider.ConfigureCommand(connection.CreateCommand());
                if (transaction != null)
                    command.Transaction = transaction;
                command.CommandText = query;

                if (parameters != null)
                {
                    foreach (var parameter in parameters)
                    {
                        var p = command.CreateParameter();
                        p.ParameterName = parameter.Key;
                        p.Value = parameter.Value;
                        command.Parameters.Add(p);
                    }
                }
                // commit is not required because we didn't open transaction explicitly
                return await command.MapAsync(null).ConfigureAwait(false);
            }
        }

        public static async Task<List<DynamicEntity>> ExecuteSelectAsync(EntityModel model, SelectValuesQueryObject select, string connectionString)
        {
            using (var shared = new SharedTransaction(connectionString))
            {
                await shared.OpenConnectionAsync().ConfigureAwait(false);
                var connectionAndTransaction = shared.ConnectionAndTransaction;
                var returnValue = await ExecuteSelectAsync(model, select, connectionAndTransaction.Connection, connectionAndTransaction.Transaction).ConfigureAwait(false);
                // commit is not required because we didn't open transaction explicitly
                return returnValue;
            }
        }

        public static async Task<long> ExecuteSelectCountAsync(SelectValuesQueryObject select, string connectionString)
        {
            using (var shared = new SharedTransaction(connectionString))
            {
                await shared.OpenConnectionAsync().ConfigureAwait(false);
                var connectionAndTransaction = shared.ConnectionAndTransaction;
                var count = await ExecuteSelectCountAsync(select, connectionAndTransaction.Connection, connectionAndTransaction.Transaction).ConfigureAwait(false);
                // commit is not required because we didn't open transaction explicitly
                return Convert.ToInt64(count);
            }
        }

        public static Task<ModifyingQueryResult> ExecuteUpdateAsync(Dictionary<object,ModifyingQueryObject> update, string connectionString)
        {
            var modifyingAction =
                new Func<DbConnection, DbTransaction, Task<ModifyingQueryResult>>(((connection, transaction) => ExecuteUpdateAsync(update, connection, transaction)));
            return ModifyDataAsync(modifyingAction, connectionString);
        }

        public static Task<ModifyingQueryResult> ExecuteInsertAsync(Dictionary<object,ModifyingQueryObject> insert, string connectionString)
        {
            var modifyingAction = new Func<DbConnection, DbTransaction, Task<ModifyingQueryResult>>(((connection, transaction) => ExecuteInsertAsync(insert, connection, transaction)));
            return ModifyDataAsync(modifyingAction, connectionString);
        }

        public static  Task<ModifyingQueryResult> ExecuteDeleteAsync(IEnumerable<ModifyingQueryObject> delete, string connectionString)
        {
            var modifyingAction = new Func<DbConnection, DbTransaction, Task<ModifyingQueryResult>>(((connection, transaction) => ExecuteDeleteAsync(delete, connection, transaction)));
            return ModifyDataAsync(modifyingAction, connectionString);
        }

        private static async Task<ModifyingQueryResult> ModifyDataAsync(Func<DbConnection, DbTransaction, Task<ModifyingQueryResult>> modifyingAction, string connectionString)
        {
            using (var shared = new SharedTransaction(connectionString))
            {
                await shared.BeginTransactionAsync().ConfigureAwait(false);

                var connectionAndTransaction = shared.ConnectionAndTransaction;
                var result = await modifyingAction.Invoke(connectionAndTransaction.Connection, connectionAndTransaction.Transaction).ConfigureAwait(false);

                await shared.CommitAsync().ConfigureAwait(false);

                return result;

                #region unused code

//                try
//                {
//                    var connectionAndTransaction = shared.ConnectionAndTransaction;
//                    return await modifyingAction.Invoke(connectionAndTransaction.Connection, connectionAndTransaction.Transaction).ConfigureAwait(false);
//                }
//                catch (DynamicEntitiesConcurrencyException)
//                {
//                    await shared.RollbackAsync().ConfigureAwait(false);
//                    throw;
//                }
//                catch
//                {
//                    await shared.RollbackAsync(true).ConfigureAwait(false);
//                    ;
//                    throw;
//                }

                #endregion

            }
        }

        private static Task<List<DynamicEntity>> ExecuteSelectAsync(EntityModel model, SelectValuesQueryObject select, DbConnection connection, DbTransaction transaction = null)
        {
            if (transaction != null)
                return CloverRuntime.DbProvider.ConfigureCommand(connection.CreateCommand()).AssignTransaction(transaction).BuildCommand(select).MapAsync(model);
            return CloverRuntime.DbProvider.ConfigureCommand(connection.CreateCommand()).BuildCommand(select).MapAsync(model);
        }


        private static Task<object> ExecuteSelectCountAsync(SelectValuesQueryObject select, DbConnection connection, DbTransaction transaction = null)
        {
            if (transaction != null)
                return CloverRuntime.DbProvider.ConfigureCommand(connection.CreateCommand()).AssignTransaction(transaction).BuildCommand(select).ExecuteScalarAsync();
            return CloverRuntime.DbProvider.ConfigureCommand(connection.CreateCommand()).BuildCommand(select).ExecuteScalarAsync();
        }

        private static async Task<ModifyingQueryResult> ExecuteUpdateAsync(Dictionary<object, ModifyingQueryObject> update, DbConnection connection, DbTransaction transaction)
        {
            long affectedRows = 0;
            var outValues = new Dictionary<object, Dictionary<string, object>>();
            foreach (var updateData in update)
            {
                var updateQueryObject = updateData.Value;
                var pk = updateData.Key;
                long affected = 0;
                var command = CloverRuntime.DbProvider.ConfigureCommand(connection.CreateCommand()).AssignTransaction(transaction).BuildCommand(updateQueryObject);
                
                if (updateQueryObject.CalculatedColumnsReturnType == CalculatedColumnsReturnType.None)
                {
                    affected = await command.ExecuteNonQueryAsync().ConfigureAwait(false);
                }
                else if (updateQueryObject.CalculatedColumnsReturnType == CalculatedColumnsReturnType.AsParameters)
                {
                    affected = await command.ExecuteNonQueryAsync().ConfigureAwait(false);
                    //reading parameters
                    var outCommandValues = updateQueryObject.GetOutputParameters(command);
                    outValues.Add(pk, outCommandValues);
                }
                else if (updateQueryObject.CalculatedColumnsReturnType == CalculatedColumnsReturnType.AsTableRow)
                {
                    var data = await command.MapWithoutAddMissingPropertiesAsync(updateQueryObject.Model);

                    if (data.Count > 1)
                        throw new DynamicEntitiesException($"The update must affect 1 or 0 rows");

                    if (data.Count == 1)
                    {
                        var row = data.Single();
                        outValues.Add(pk, row.Dictionary.ToDictionary(kvp => kvp.Key, kvp => kvp.Value));
                        affected++;
                    }
                }
                else
                {
                    throw new NotSupportedException($"Unknown CalculatedColumnsReturnType {updateQueryObject.CalculatedColumnsReturnType:G}");
                }
                
                
                if (affected < 1)
                {
                    throw new DynamicEntitiesConcurrencyException("Row not found or changed");
                }

                affectedRows += affected;
            }

            return new ModifyingQueryResult(affectedRows, outValues);
        }

        private static async Task<ModifyingQueryResult> ExecuteInsertAsync(Dictionary<object, ModifyingQueryObject> insert, DbConnection connection, DbTransaction transaction)
        {
            long affectedRows = 0;
            var outValues = new Dictionary<object, Dictionary<string, object>>();
            foreach (var insertData in insert)
            {
                var insertQueryObject = insertData.Value;
                var pk = insertData.Key;

                var command = CloverRuntime.DbProvider.ConfigureCommand(connection.CreateCommand()).AssignTransaction(transaction).BuildCommand(insertQueryObject);

                if (insertQueryObject.CalculatedColumnsReturnType == CalculatedColumnsReturnType.None)
                {
                    affectedRows += await command.ExecuteNonQueryAsync().ConfigureAwait(false);
                }
                else if (insertQueryObject.CalculatedColumnsReturnType == CalculatedColumnsReturnType.AsParameters)
                {
                    affectedRows += await command.ExecuteNonQueryAsync().ConfigureAwait(false);
                    //reading parameters
                    var outCommandValues = insertQueryObject.GetOutputParameters(command);
                    outValues.Add(pk, outCommandValues);
                }
                else if (insertQueryObject.CalculatedColumnsReturnType == CalculatedColumnsReturnType.AsTableRow)
                {
                    var data =  await command.MapWithoutAddMissingPropertiesAsync(insertQueryObject.Model);

                    if (data.Count > 1)
                        throw new DynamicEntitiesException($"The insert must affect 1 or 0 rows");

                    if (data.Count == 1)
                    {
                        affectedRows++;
                        var row = data.Single();
                        outValues.Add(pk, row.Dictionary.ToDictionary(kvp => kvp.Key, kvp => kvp.Value));
                    }
                }
                else
                {
                    throw new NotSupportedException($"Unknown CalculatedColumnsReturnType {insertQueryObject.CalculatedColumnsReturnType:G}");
                }

            }

            return new ModifyingQueryResult(affectedRows, outValues);
        }

        private static async Task<ModifyingQueryResult> ExecuteDeleteAsync(IEnumerable<ModifyingQueryObject> delete, DbConnection connection, DbTransaction transaction)
        {
            long affectedRows = 0;
            foreach (var deleteQueryObject in delete)
            {
                var affected = await CloverRuntime.DbProvider.ConfigureCommand(connection.CreateCommand()).AssignTransaction(transaction).BuildCommand(deleteQueryObject).ExecuteNonQueryAsync().ConfigureAwait(false);
                if (affected < 1)
                {
                    throw new DynamicEntitiesConcurrencyException("Row not found or changed");
                }

                affectedRows += affected;
            }
            return new ModifyingQueryResult(affectedRows);
        }
    }
}
