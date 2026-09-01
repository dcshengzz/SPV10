using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Model;
#pragma warning disable 1591

namespace swz.Clover.Core
{

    public static class DynamicEntityOperationNotifier
    {
        private class Subscription
        {
            private readonly ReaderWriterLockSlim _lock = new ReaderWriterLockSlim();
            private readonly Dictionary<string, Dictionary<string, List<Delegate>>> _subscriptions = new Dictionary<string, Dictionary<string, List<Delegate>>>();

            public List<Delegate> GetSubscriptionsByEntityName(string entityName)
            {
                var res = new List<Delegate>();
                _lock.EnterReadLock();
                try
                {
                    if (_subscriptions.ContainsKey(entityName))
                    {
                        foreach (var sub in _subscriptions[entityName])
                        {
                            foreach (var action in sub.Value)
                            {
                                res.Add(action);
                            }
                        }
                    }
                }
                finally
                {
                    _lock.ExitReadLock();
                }

                return res;
            }

            public void AddSubscription(string entityName, string subscriptionName, Delegate action)
            {
                _lock.EnterWriteLock();
                try
                {
                    if (!_subscriptions.TryGetValue(entityName, out var entitySubscription))
                    {
                        entitySubscription = new Dictionary<string, List<Delegate>>();
                        _subscriptions.Add(entityName, entitySubscription);
                    }

                    if (!entitySubscription.TryGetValue(subscriptionName, out var namedSubscription))
                    {
                        namedSubscription = new List<Delegate>();
                        entitySubscription.Add(subscriptionName, namedSubscription);
                    }

                    namedSubscription.Add(action);
                }
                finally
                {
                    _lock.ExitWriteLock();
                }
            }

            public void RemoveSubscription(string subscriptionName)
            {
                _lock.EnterWriteLock();
                try
                {
                    var keysToRemove = new List<string>();
                    foreach (var subscription in _subscriptions)
                    {
                        if (subscription.Value.ContainsKey(subscriptionName))
                        {
                            subscription.Value.Remove(subscriptionName);
                        }

                        if (subscription.Value.Count < 1)
                            keysToRemove.Add(subscription.Key);
                    }

                    keysToRemove.ForEach(k => _subscriptions.Remove(k));
                }
                finally
                {
                    _lock.ExitWriteLock();
                }
            }
        }

        private static readonly Subscription InsertSubscriptionsByModel = new Subscription();
        private static readonly Subscription UpdateSubscriptionsByModel = new Subscription();
        private static readonly Subscription DeleteSubscriptionsByModel = new Subscription();
        private static readonly Subscription InsertSubscriptionsByTable = new Subscription();
        private static readonly Subscription UpdateSubscriptionsByTable = new Subscription();
        private static readonly Subscription DeleteSubscriptionsByTable = new Subscription();

        public static void SubscribeToInsertByDataModelName(string entityName, string subscriptionName,
            Action<EntityModel, List<ChangeOperation>> action)
        {
            InsertSubscriptionsByModel.AddSubscription(entityName, subscriptionName, action);
        }

        public static void SubscribeToUpdateByDataModelName(string entityName, string subscriptionName,
            Action<EntityModel, List<ChangeOperation>> action)
        {
            UpdateSubscriptionsByModel.AddSubscription(entityName, subscriptionName, action);
        }

        public static void SubscribeToDeleteByDataModelName(string entityName, string subscriptionName,
            Action<EntityModel, List<ChangeOperation>> action)
        {
            DeleteSubscriptionsByModel.AddSubscription(entityName, subscriptionName, action);
        }

        public static void SubscribeToInsertByDataModelName(string entityName, string subscriptionName,
            Func<EntityModel, List<ChangeOperation>, Task> action)
        {
            InsertSubscriptionsByModel.AddSubscription(entityName, subscriptionName, action);
        }

        public static void SubscribeToUpdateByDataModelName(string entityName, string subscriptionName,
            Func<EntityModel, List<ChangeOperation>, Task> action)
        {
            UpdateSubscriptionsByModel.AddSubscription(entityName, subscriptionName, action);
        }

        public static void SubscribeToDeleteByDataModelName(string entityName, string subscriptionName,
            Func<EntityModel, List<ChangeOperation>, Task> action)
        {
            DeleteSubscriptionsByModel.AddSubscription(entityName, subscriptionName, action);
        }

        public static void SubscribeToInsertByTableName(string entityName, string subscriptionName,
            Action<EntityModel, List<ChangeOperation>> action)
        {
            InsertSubscriptionsByTable.AddSubscription(entityName, subscriptionName, action);
        }

        public static void SubscribeToUpdateByTableName(string entityName, string subscriptionName,
            Action<EntityModel, List<ChangeOperation>> action)
        {
            UpdateSubscriptionsByTable.AddSubscription(entityName, subscriptionName, action);
        }

        public static void SubscribeToDeleteByTableName(string entityName, string subscriptionName,
            Action<EntityModel, List<ChangeOperation>> action)
        {
            DeleteSubscriptionsByTable.AddSubscription(entityName, subscriptionName, action);
        }

        public static void SubscribeToInsertByTableName(string entityName, string subscriptionName,
            Func<EntityModel, List<ChangeOperation>, Task> action)
        {
            InsertSubscriptionsByTable.AddSubscription(entityName, subscriptionName, action);
        }

        public static void SubscribeToUpdateByTableName(string entityName, string subscriptionName,
            Func<EntityModel, List<ChangeOperation>, Task> action)
        {
            UpdateSubscriptionsByTable.AddSubscription(entityName, subscriptionName, action);
        }

        public static void SubscribeToDeleteByTableName(string entityName, string subscriptionName,
            Func<EntityModel, List<ChangeOperation>, Task> action)
        {
            DeleteSubscriptionsByTable.AddSubscription(entityName, subscriptionName, action);
        }

        public static void UnsubscribeBySubscriptionName(string subscriptionName)
        {
            InsertSubscriptionsByModel.RemoveSubscription(subscriptionName);
            InsertSubscriptionsByTable.RemoveSubscription(subscriptionName);
            UpdateSubscriptionsByModel.RemoveSubscription(subscriptionName);
            UpdateSubscriptionsByTable.RemoveSubscription(subscriptionName);
            DeleteSubscriptionsByModel.RemoveSubscription(subscriptionName);
            DeleteSubscriptionsByTable.RemoveSubscription(subscriptionName);
        }

        private static async Task NotifyInsertPrivateAsync(EntityModel model, List<ChangeOperation> changes)
        {
            await NotifyAsync(model, changes, InsertSubscriptionsByModel, model.SourceDataModelName);
            await NotifyAsync(model, changes, InsertSubscriptionsByTable, model.TableName);
        }

        private static async Task NotifyUpdatePrivateAsync(EntityModel model, List<ChangeOperation> changes)
        {
            await NotifyAsync(model, changes, UpdateSubscriptionsByModel, model.SourceDataModelName);
            await NotifyAsync(model, changes, UpdateSubscriptionsByTable, model.TableName);
        }

        private static async Task NotifyDeletePrivateAsync(EntityModel model, List<ChangeOperation> changes)
        {
            await NotifyAsync(model, changes, DeleteSubscriptionsByModel, model.SourceDataModelName);
            await NotifyAsync(model, changes, DeleteSubscriptionsByTable, model.TableName);
        }

        private static async Task NotifyAsync(EntityModel model, List<ChangeOperation> changes, Subscription subscriptions, string entityName)
        {
            var actions = subscriptions.GetSubscriptionsByEntityName(entityName);

            foreach (var action in actions)
            {
                if (action is Action<EntityModel, List<ChangeOperation>> syncAction)
                    syncAction.Invoke(model, changes);
                else if (action is Func<EntityModel, List<ChangeOperation>, Task> asyncAction)
                    await asyncAction.Invoke(model, changes).ConfigureAwait(false);
            }
        }


        internal static async Task NotifyDeleteAsync(EntityModel model, List<ChangeOperation> changes)
        {
            if (SharedTransaction.IsTransactionExists())
            {
                SharedTransaction.SubscribeOnCommit(() =>  NotifyDeletePrivateAsync(model, changes));
            }
            else
            {
                await NotifyDeletePrivateAsync(model, changes).ConfigureAwait(false);;
            }
       }

        internal static async Task NotifyInsertAsync(EntityModel model, List<ChangeOperation> changes)
        {
            if (SharedTransaction.IsTransactionExists())
            {
                SharedTransaction.SubscribeOnCommit(() => NotifyInsertPrivateAsync(model, changes));
            }
            else
            {
                await NotifyInsertPrivateAsync(model, changes).ConfigureAwait(false);;
            }
        }

        internal static async Task NotifyUpdateAsync(EntityModel model, List<ChangeOperation> changes)
        {
            if (SharedTransaction.IsTransactionExists())
            {
                SharedTransaction.SubscribeOnCommit(() => NotifyUpdatePrivateAsync(model, changes));
            }
            else
            {
                await NotifyUpdatePrivateAsync(model, changes).ConfigureAwait(false);
            }
        }
    }
}
