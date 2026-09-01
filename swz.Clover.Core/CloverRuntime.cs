using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using System.Xml.Linq;
using Microsoft.AspNetCore.SignalR;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.License;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.Model;
using swz.Clover.Core.Security;
using swz.Workflow.Core.Builder;
using swz.Workflow.Core.Bus;
using swz.Workflow.Core.Generator;
using swz.Workflow.Core.Persistence;
using swz.Workflow.Core.Runtime;

namespace swz.Clover.Core
{
    public class ConnectedToHubEventArgs : EventArgs
    {
        public string UserId { get; set; }
    }
    [Obsolete("The interface will be removed in CLOVER version 2.6 and later.")]
    public interface IEventLogger
    {
        void LogInsert(EntityModel model, IEnumerable<dynamic> entities);
        void LogUpdate(EntityModel model, IEnumerable<dynamic> entities);
        void LogDelete(EntityModel model, IEnumerable<dynamic> entities);
    }
    [Obsolete("The interface will be removed in CLOVER version 2.6 and later.")]
    public interface ISearchEngineNotifier
    {
        void NotifyInsert(EntityModel model, IEnumerable<dynamic> entities);
        void NotifyUpdate(EntityModel model, IEnumerable<dynamic> entities);
        void NotifyDelete(EntityModel model, IEnumerable<dynamic> entities);
    }

    [Obsolete("The interface will be removed in CLOVER version 2.6 and later.")]
    public interface IDynamicEntityExtension
    {
        void CorrectGeneratorParameters(Dictionary<string, string> parameters);
    }

    [Obsolete("You need to inherit from the PrimaryKeyGenerator class and pass it to the DBProvider constructor. " +
              "The interface will be removed in CLOVER version 2.6 and later.")]
    public interface IPrimaryKeyGenerator
    {
        object Generate(AttributeModel attribute);
    }

    /// <summary>
    /// The main object of settings DynamicEntities
    /// </summary>
    public static class CloverRuntime
    {
        static CloverRuntime()
        {
            RegisterLicense(null);
        }


        private static object _compileLock = new object();
        public static Dictionary<string, string> CloverCodeActionErrors = new Dictionary<string, string>();
        public static List<string> FieldsToIdentifyName = new List<string>() {"Name", "Code"};
        private static string _connectionStringMetadata;
        private static string _connectionStringVersion;

        public static bool UseMetadataCache { get; set; }
        public static string SiteUrl { get; set; }
        public static bool UseExecutorCache { get; set; }
        [Obsolete("The property will be removed in CLOVER version 2.6 and later.")]
        public static IEventLogger EventLogger { get; set; }
        [Obsolete("The property will be removed in CLOVER version 2.6 and later.")]
        public static ISearchEngineNotifier Notifier { get; set; }
        [Obsolete("The property will be removed in CLOVER version 2.6 and later.")]
        public static IDynamicEntityExtension Extension { get; set; }

        [Obsolete("You need to inherit from the PrimaryKeyGenerator class and pass it to the DBProvider constructor. " +
                  "The property will be removed in CLOVER version 2.6 and later.")]
        public static IPrimaryKeyGenerator PrimaryKeyGenerator { get; set; }

        [Obsolete("The method will be removed in CLOVER version 2.6 and later.")]
        public static void LogInsert(EntityModel model, IEnumerable<dynamic> entities)
        {
            EventLogger?.LogInsert(model, entities);
        }
        [Obsolete("The method will be removed in CLOVER version 2.6 and later.")]
        public static void LogUpdate(EntityModel model, IEnumerable<dynamic> entities)
        {
            EventLogger?.LogUpdate(model, entities);
        }
        [Obsolete("The method will be removed in CLOVER version 2.6 and later.")]
        public static void LogDelete(EntityModel model, IEnumerable<dynamic> entities)
        {
            EventLogger?.LogDelete(model, entities);
        }
        [Obsolete("The method will be removed in CLOVER version 2.6 and later.")]
        public static void NotifyInsert(EntityModel model, IEnumerable<dynamic> entities)
        {
            Notifier?.NotifyInsert(model, entities);
        }
        [Obsolete("The method will be removed in CLOVER version 2.6 and later.")]
        public static void NotifyUpdate(EntityModel model, IEnumerable<dynamic> entities)
        {
            Notifier?.NotifyUpdate(model, entities);
        }
        [Obsolete("The method will be removed in CLOVER version 2.6 and later.")]
        public static void NotifyDelete(EntityModel model, IEnumerable<dynamic> entities)
        {
            Notifier?.NotifyDelete(model, entities);
        }

        [Obsolete("You need to inherit from the PrimaryKeyGenerator class and pass it to the DBProvider constructor. " +
                  "The method will be removed in CLOVER version 2.6 and later.")]
        public static object GeneratePrimaryKey(AttributeModel attribute)
        {
            return PrimaryKeyGenerator?.Generate(attribute);
        }

        /// <summary>
        /// ConnectionString for Metadata
        /// </summary>
        public static string ConnectionStringMetadata
        {
            get => _connectionStringMetadata ?? ConnectionStringData;
            set => _connectionStringMetadata = value;
        }

        /// <summary>
        /// ConnectionString for Versioning
        /// </summary>
        public static string ConnectionStringVersion
        {
            get => _connectionStringVersion ?? _connectionStringMetadata ?? ConnectionStringData;
            set => _connectionStringVersion = value;
        }

        /// <summary>
        /// ConnectionString for Data. This is for use by the ORM and framework code.
        /// Application code shouldn't use this to get the connection string as we want
        /// to avoid the 'ambient context' anti-pattern as much as possible..
        /// </summary>
        public static string ConnectionStringData { get; set; }

        public static IDbProvider DbProvider { get; set; }

        private static IContentProvider _contentProvider = null;
        private static object _lockContentProvider = new object();

        public static IContentProvider ContentProvider
        {
            get
            {
                if (_contentProvider == null)
                {
                    lock (_lockContentProvider)
                    {
                        if (_contentProvider == null)
                        {
                            _contentProvider = new ContentDBProvider();
                        }
                    }
                }

                return _contentProvider;
            }
            set { _contentProvider = value; }
        }

        public static string MetadataSchema { get; set; }

        private static string _metadataPrefix = "dw";

        /// <summary>
        /// Prefix for clover's tables 
        /// </summary>
        public static string MetadataPrefix
        {
            get => _metadataPrefix;
            set => _metadataPrefix = value;
        }

        public static IMetadataProvider Metadata { get; set; }        
        public static ILicenseControlProvider LicenseControl { get; set; }

        private static int _commandTimeout = 600;

        public static int CommandTimeout
        {
            get => _commandTimeout;
            set => _commandTimeout = value;
        }

        public static ISecurityProvider Security { get; set; }


        public static List<string> RegisteredTypeNames =
            new List<string> {"String", "Guid", "Char", "Byte", "Int16", "Int32", "Int64", "Single", "Double", "Decimal", "DateTime", "Boolean"};

        private static MetadataCaches metadataCaches;
        public static void SetMetadataCaches(MetadataCaches cacheInstance)
        {
            metadataCaches = cacheInstance ?? throw new ArgumentNullException(nameof(cacheInstance));
        }

        public static void ResetAppCache()
        {
            metadataCaches.Flush();
            Security.ResetUserCache(null);
        }

        public static void UploadLicense(string licensetext)
        {
            RegisterLicense(licensetext);
            var licensefile = "license.key";
            File.WriteAllText(licensefile, licensetext);
        }

        #region Licensing

        /// <summary>
        /// Register the license to remove license restrictions
        /// </summary>
        /// <param name="licenseText">License text</param>
        public static void RegisterLicense(string licenseText)
        {
            lock (LicLockObj)
            {
                if (!string.IsNullOrEmpty(licenseText))
                {
                    Licensing.RegisterLicense<CloverRestrictions>(licenseText);
                }
                else
                {
                    Licensing.RegisterDefaultCLOVER();
                }

                var maxNumOfThreads = Licensing.GetLicenseRestrictions<CloverRestrictions>().MaxNumberOfThreads;
                if (maxNumOfThreads < 0)
                {
                    var oldLicSemaphore = LicenseSemaphore;
                    LicenseSemaphore = null;
                    if (oldLicSemaphore != null)
                    {
                        var releaseCount = maxThreads - oldLicSemaphore.CurrentCount;
                        if (releaseCount > 0)
                            oldLicSemaphore?.Release(releaseCount);
                    }

                }
                else
                {
                    var oldLicSemaphore = LicenseSemaphore;
                    LicenseSemaphore = new SemaphoreSlim(maxNumOfThreads);
                    if (oldLicSemaphore != null)
                    {
                        var releaseCount = maxThreads - oldLicSemaphore.CurrentCount;
                        if (releaseCount > 0)
                            oldLicSemaphore?.Release(releaseCount);
                    }
                }

                maxThreads = maxNumOfThreads;

                if (!string.IsNullOrEmpty(licenseText))
                    WorkflowRuntime.RegisterLicense(Licensing.GetWorkflowLicenseKey(licenseText));
            }
        }

        private static readonly object LicLockObj = new object();
        private static int maxThreads = Licensing.DefaultMaxNumberOfThreads;
        internal static SemaphoreSlim LicenseSemaphore;


        #endregion

        #region Code Actions

        public static ServerActionsProvider ServerActions = new ServerActionsProvider();

        public static async Task CompileAllCodeActionsAsync()
        {
            var codeActionQuery = new MetadataSectionQuery(MetadataSections.Codeactions);

            var collection = await Metadata.PartialMetadata(new List<MetadataSectionQuery> {codeActionQuery}).ConfigureAwait(false);

            lock (_compileLock)
            {
                ServerActions.RegisterCodeActions("global", collection.CodeActions, out CloverCodeActionErrors);
            }
        }

        #endregion

        private static WorkflowRuntime _runtime = null;

        public static WorkflowRuntime GetCreatedWorkflowRuntime()
        {
            return _runtime;
        }

        public static WorkflowRuntime CreateWorkflowRuntime()
        {
            var dbProvider = CloverRuntime.DbProvider.GetWorkflowProvider();
            var builder = new WorkflowBuilder<XElement>(
                (IWorkflowGenerator<XElement>) dbProvider,
                new swz.Workflow.Core.Parser.XmlWorkflowParser(),
                (ISchemePersistenceProvider<XElement>) dbProvider
            ).WithDefaultCache();

            _runtime = new WorkflowRuntime()
                .WithBuilder(builder)
                .WithPersistenceProvider((IPersistenceProvider) dbProvider)
                .WithBus(new NullBus())
                .EnableCodeActions()
                .SwitchAutoUpdateSchemeBeforeGetAvailableCommandsOn();

            return _runtime;
        }

        private static string _integrationApiKey = null;

        /// <summary>
        /// ApiKey for the U@App API
        /// This must be set at startup before other threads need to access it
        /// </summary>
        public static string IntegrationApiKey
        {
            get
            {
                if (_integrationApiKey == null)
                    throw new InvalidOperationException("IntegrationApiKey has not been set");
                return _integrationApiKey;
            }

            //I haven't bothered added a lock here as its only intended to be called at startup.
            //Once in use multiple threads will call the getter
            set 
            {
                if (_integrationApiKey != null) 
                    throw new InvalidOperationException("IntegrationApiKey already set");
                if (string.IsNullOrWhiteSpace(value))
                    throw new ArgumentException("Value provided for IntegrationApiKey is null or empty");
                _integrationApiKey = value;
            }
        }

        public static IHubContext<ClientNotificationHub> HubContext { get; set; }

        public static async Task SendStateChangeToGroupAsync(string groupName, string path, object change)
        {
            if (change == null) throw new ArgumentNullException(nameof(change));
            if (string.IsNullOrEmpty(path)) throw new ArgumentNullException(nameof(path));

            if (HubContext != null) //check if we have signalR setup or not before sending
            {
                var message = new
                {
                    path = path,
                    change = change
                };

                await HubContext.Clients.Group(groupName).SendAsync("StateChange", message);
            }
        }

        public static Task SendStateChangeToUserAsync(Guid userId, string path, object change)
        {
            return SendStateChangeToUserAsync(userId.ToString(), path, change);
        }

        public static async Task SendStateChangeToUserAsync(string userId, string path, object change)
        {
            if (change == null) throw new ArgumentNullException(nameof(change));
            if (string.IsNullOrEmpty(path)) throw new ArgumentNullException(nameof(path));

            if(HubContext != null) //check if we have signalR setup or not before sending
            {
                var message = new
                {
                    path = path,
                    change = change
                };

                await HubContext.Clients.User(userId).SendAsync("StateChange", message);
            }
        }


        private static ConcurrentDictionary<Type, List<Func<string, Task>>> _clientNotifiers = new ConcurrentDictionary<Type, List<Func<string, Task>>>();
        private static ConcurrentDictionary<Type, List<Func<string, object, Task>>> _spClientNotifiers = new ConcurrentDictionary<Type, List<Func<string, object, Task>>>();

        public static async Task NotifyConnectedClients(Type hubType, string userId)
        {
            _clientNotifiers.TryGetValue(hubType, out List<Func<string, Task>> notifiers);

            if (notifiers == null)
                return;

            var notifiersArray = notifiers.ToArray();

            foreach (var notifier in notifiersArray)
            {
                await notifier(userId);
            }
        }
        public static async Task SpNotifyConnectedClients(Type hubType, string userId, object spData=null)
        {
            _spClientNotifiers.TryGetValue(hubType, out List<Func<string, object, Task>> notifiers);

            if (notifiers == null)
                return;

            var notifiersArray = notifiers.ToArray();

            foreach (var notifier in notifiersArray)
            {
                await notifier(userId, spData);
            }
        }

        public static void AddClientNotifier(Type hubtype, Func<string, Task> notifier)
        {
            _clientNotifiers.AddOrUpdate(hubtype, new List<Func<string, Task>> {notifier}, (key, oldValue) =>
            {
                oldValue.Add(notifier);
                return oldValue;
            });
        }


        public static void AddClientNotifier(Type hubtype, Func<string, object, Task> notifier)
        {
            _spClientNotifiers.AddOrUpdate(hubtype, new List<Func<string, object, Task>> { notifier }, (key, oldValue) =>
            {
                oldValue.Add(notifier);
                return oldValue;
            });
        }
        public static Func<string, Task<List<string>>> SignalRGroupClassifier { get; set; }

    }
}
