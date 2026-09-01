using System;
using System.Collections.Concurrent;
using System.Data;
using System.Data.Common;
using System.Threading;
using System.Threading.Tasks;
using swz.Clover.Core.Exceptions;

#pragma warning disable 1591

namespace swz.Clover.Core
{
    public sealed class ConnectionAndTransaction
    {
        internal ConnectionAndTransaction(DbConnection connection)
        {
            Connection = connection;
        }

        public DbConnection Connection { get; }
        public DbTransaction Transaction { get; internal set; }
        public bool IsRolledBack { get; internal set; }
    }

    public sealed class SharedTransaction : IDisposable
    {
        private class CreationResult
        {
            internal ConnectionAndTransaction ConnectionAndTransaction { get; set; }
            public bool WasConnectionExistsBefore { get; protected internal set; }
            public bool WasTransactionExistsBefore { get; protected internal set; }

            public DbConnection Connection => ConnectionAndTransaction?.Connection;
            public DbTransaction Transaction => ConnectionAndTransaction?.Transaction;
        }
        
        private readonly string _connectionString;
        private readonly bool _ownsConnection;
        private readonly bool _ownsTransaction;
        private bool _wasCommittedLocally;
        private bool _wasTransactionUsedLocally;
        
        private static readonly AsyncLocal<Guid?> Id = new AsyncLocal<Guid?>();
        private static readonly ConcurrentDictionary<Guid, ConnectionAndTransaction> ConnectionAndTransactions = new ConcurrentDictionary<Guid, ConnectionAndTransaction>();
        private static readonly ConcurrentDictionary<Guid, ConcurrentBag<Delegate>> CommitActions = new ConcurrentDictionary<Guid, ConcurrentBag<Delegate>>();
        private static readonly ConcurrentDictionary<Guid, ConcurrentBag<Delegate>> RollbackActions = new ConcurrentDictionary<Guid, ConcurrentBag<Delegate>>();

        public SharedTransaction(string connectionString = null)
        {
            _connectionString = connectionString;
            GetId();
            var res = GetConnectionAndTransaction();
            _ownsConnection = !res.WasConnectionExistsBefore;
            _ownsTransaction = !res.WasTransactionExistsBefore;
        }

        #region IDisposable implementation

        private void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (!_wasCommittedLocally && _wasTransactionUsedLocally)
                {
                    RollbackTransactionIfStartedAsync().Wait();
                }
                if (_ownsConnection)
                    CloseConnection();
            }
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        ~SharedTransaction()
        {
            Dispose(false);
        }

        
        #endregion

        #region Public API

        public Task OpenConnectionAsync()
        {
            return CreateOrGetConnection(_connectionString);
        }

        public Task BeginTransactionAsync(IsolationLevel isolationLevel = IsolationLevel.ReadCommitted, Func<Task> onCommit = null, Func<Task> onRollback = null)
        {
            _wasTransactionUsedLocally = true;
            return BeginTransactionIfNotStarted(isolationLevel, onCommit, onRollback);
        }

        /// <summary>
        /// Rollback the transaction. It is not necessary to call this method explicitly
        /// </summary>
        public async Task RollbackAsync()
        {
//            if (rollbackOnlyIfOwner && !_ownsTransaction)
//                return;
            await RollbackTransactionIfStartedAsync().ConfigureAwait(false);
        }
        
        /// <summary>
        /// Rollback the transaction. It is not necessary to call this method explicitly
        /// </summary>
        public void Rollback()
        {
            RollbackAsync().Wait();
        }

        /// <summary>
        /// Commit the transaction if it is not nested in an external transaction. It is necessary to call this method explicitly
        /// </summary>
        public async Task CommitAsync()
        {
            if (IsTransactionRolledBack)
                throw new SharedTransactionRolledbackException();
            
            _wasCommittedLocally = true;
            
            if (_ownsTransaction)
                await CommitTransactionIfStartedAsync().ConfigureAwait(false);
        }
        
        /// <summary>
        /// Commit the transaction if it is not nested in an external transaction. It is necessary to call this method explicitly
        /// </summary>
        public void Commit()
        {
            CommitAsync().Wait();
        }
        
        public DbConnection Connection => GetConnectionAndTransaction().Connection;
        public DbTransaction Transaction => GetConnectionAndTransaction().Transaction;
        public ConnectionAndTransaction ConnectionAndTransaction => GetConnectionAndTransaction().ConnectionAndTransaction;
        public bool IsTransactionRolledBack => GetConnectionAndTransaction().ConnectionAndTransaction.IsRolledBack;
             
        public static void SubscribeOnRollback(Action onRollback)
        {
            SubscribeOnRollbackPrivate(onRollback);
        }

        public static void SubscribeOnRollback(Func<Task> onRollback)
        {
            SubscribeOnRollbackPrivate(onRollback);
        }
        
        #endregion
   
        private static CreationResult GetConnectionAndTransaction()
        {
            CreationResult result = GetConnectionAndTransactionAsync(
                connectionString:null, 
                openIfClosed: false, 
                preventCreation: true)
                .Result;

            if (result.Transaction != null)
                result.WasTransactionExistsBefore = true;
            return result;
        }

        private static async Task<CreationResult> CreateOrGetConnection(string connectionString = null, bool openIfClosed = true)
        {
            var result = await GetConnectionAndTransactionAsync(connectionString, openIfClosed).ConfigureAwait(false);
            if (result.Transaction != null)
                result.WasTransactionExistsBefore = true;
            return result;
        }

        public static void SubscribeOnCommit(Func<Task> onCommit)
        {
            SubscribeOnCommitPrivate(onCommit);
        }
        
        public static void SubscribeOnCommit(Action onCommit)
        {
            SubscribeOnCommitPrivate(onCommit);
        }

        private static void SubscribeOnCommitPrivate(Delegate onCommit)
        {
            if (onCommit == null) throw new ArgumentNullException(nameof(onCommit));
            var id = GetId();
            CommitActions.AddOrUpdate(id, new ConcurrentBag<Delegate> {onCommit}, (guid, bag) =>
            {
                bag.Add(onCommit);
                return bag;
            });
        }
   

        private static void SubscribeOnRollbackPrivate(Delegate onRollback)
        {
            if (onRollback == null) throw new ArgumentNullException(nameof(onRollback));
            var id = GetId();
            RollbackActions.AddOrUpdate(id, new ConcurrentBag<Delegate> {onRollback}, (guid, bag) =>
            {
                bag.Add(onRollback);
                return bag;
            });
        }

        private static async Task<CreationResult> BeginTransactionIfNotStarted(IsolationLevel isolationLevel = IsolationLevel.ReadCommitted, Func<Task> onCommit = null,
            Func<Task> onRollback = null, string connectionString = null)
        {
            var id = GetId();

            var result = await GetConnectionAndTransactionAsync(connectionString, true).ConfigureAwait(false);

            
            if (result.Transaction == null)
            {
                result.ConnectionAndTransaction.Transaction = result.ConnectionAndTransaction.Connection.BeginTransaction(isolationLevel);
                result.WasTransactionExistsBefore = false;

            }
            else
            {
                result.WasTransactionExistsBefore = true;
            }

            if (onCommit != null)
            {
                CommitActions.AddOrUpdate(id, new ConcurrentBag<Delegate> {onCommit}, (guid, bag) =>
                {
                    bag.Add(onCommit);
                    return bag;
                });
            }

            if (onRollback != null)
            {
                RollbackActions.AddOrUpdate(id, new ConcurrentBag<Delegate> {onRollback}, (guid, bag) =>
                {
                    bag.Add(onRollback);
                    return bag;
                });
            }

            return result;
        }

        public static bool IsConnectionExists()
        {
            var id = GetId();
            return ConnectionAndTransactions.ContainsKey(id);
        }

        public static bool IsTransactionExists()
        {
            var id = GetId();
            if (ConnectionAndTransactions.TryGetValue(id, out var connectionAndTransaction))
            {
                return connectionAndTransaction.Transaction != null;
            }
            return false;
        }

        private static async Task CommitTransactionIfStartedAsync()
        {
            var id = GetId();
            
            if (ConnectionAndTransactions.TryGetValue(id, out var connectionAndTransaction))
            {
                if (connectionAndTransaction.Transaction != null)
                {
                    connectionAndTransaction.Transaction.Commit();
                    connectionAndTransaction.Transaction.Dispose();
                    connectionAndTransaction.Transaction = null;
                }
             
                CommitActions.TryRemove(id, out var commitActions);
                RollbackActions.TryRemove(id, out _);
                
                if (commitActions != null)
                {
                    foreach (var commitAction in commitActions)
                    {
                        if (commitAction is Func<Task> asynCommitAction)
                            await asynCommitAction.Invoke().ConfigureAwait(false);
                        else if (commitAction is Action syncCommitAction)
                            syncCommitAction.Invoke();
                        else
                            throw new Exception("Commit action should be Func<Task> or Action");
                    }
                }
            }
        }

        private static async Task RollbackTransactionIfStartedAsync()
        {
            var id = GetId();

            if (ConnectionAndTransactions.TryGetValue(id, out var connectionAndTransaction))
            {
                if (connectionAndTransaction.Transaction != null)
                {
                    connectionAndTransaction.Transaction.Rollback();
                    connectionAndTransaction.Transaction.Dispose();
                    connectionAndTransaction.Transaction = null;
                    connectionAndTransaction.IsRolledBack = true;
                }

                CommitActions.TryRemove(id, out _);
                RollbackActions.TryRemove(id, out var rollbackActions);

                if (rollbackActions != null)
                {
                    foreach (var rollbackAction in rollbackActions)
                    {
                        if (rollbackAction is Func<Task> asyncRollbackAction)
                            await asyncRollbackAction.Invoke().ConfigureAwait(false);
                        else if (rollbackAction is Action syncRollbackAction)
                            syncRollbackAction.Invoke();
                        else
                            throw new Exception("Rollback action should be Func<Task> or Action");
                    }
                }
            }
        }

        private static void CloseConnection()
        {
            var id = GetId();

            if (ConnectionAndTransactions.TryGetValue(id, out var connectionAndTransaction))
            {
                connectionAndTransaction.Connection.Close();
            }
        }

        private static async Task<CreationResult> GetConnectionAndTransactionAsync(
            string connectionString, 
            bool openIfClosed, 
            bool preventCreation = false)
        {
            Guid id = GetId();
            CreationResult creationResult = new CreationResult();

            bool wasConnectionExists = ConnectionAndTransactions.TryGetValue(id, out var connectionAndTransaction);

            if (!wasConnectionExists && !preventCreation)
            {
                DbConnection dataConnection = string.IsNullOrEmpty(connectionString)
                    ? CloverRuntime.DbProvider.DbCommunication.GetDataConnection()
                    : CloverRuntime.DbProvider.DbCommunication.GetConnection(connectionString);

                dataConnection.StateChange += (sender, args) =>
                {
                    if (args.CurrentState == ConnectionState.Closed)
                    {
                        ConnectionAndTransactions.TryRemove(id, out var removedConnectionAndTransaction);
                        //TODO Rollback transaction if exists

                        removedConnectionAndTransaction.Connection.Dispose();
                    }
                };

                ConnectionAndTransaction newConnectionAndTransaction 
                    = new ConnectionAndTransaction(dataConnection);
                connectionAndTransaction 
                    = ConnectionAndTransactions.AddOrUpdate(id, newConnectionAndTransaction, (guid, transaction) =>
                {
                    creationResult.WasConnectionExistsBefore = true;
                    return transaction;
                });
            }
            else
            {
                creationResult.WasConnectionExistsBefore = wasConnectionExists;
            }

            if (connectionAndTransaction != null
                && connectionAndTransaction.Connection.State == ConnectionState.Closed
                && openIfClosed)
            {
                await connectionAndTransaction.Connection.OpenAsync().ConfigureAwait(false);
            }

            creationResult.ConnectionAndTransaction = connectionAndTransaction;

            return creationResult;
        }

        /// <summary>
        /// Returns Id of the shared transaction
        /// </summary>
        /// <returns>Id of the shared transaction</returns>
        public static Guid GetId()
        {
            if (!Id.Value.HasValue)
                Id.Value = Guid.NewGuid();
            var id = Id.Value.Value;
            return id;
        }
    }
}
