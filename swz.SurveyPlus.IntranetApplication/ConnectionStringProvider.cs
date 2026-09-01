using Amazon.SecretsManager;
using Amazon.SecretsManager.Model;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
using swz.SurveyPlus.IntranetApplication;
using swz.SurveyPlus.Application;
using Amazon;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

/// <summary>
/// Interface for a thing that can return a Connection String on demand. 
/// </summary>
public interface IConnectionStringProvider
{
    string GetConnectionString();
}

/// <summary>
/// Basic implementation of IConnectionStringProvider, this just returns the default connection string from the appsettings
/// (Note that it doesnt verify the value in the options)
/// </summary>
public class DefaultConnectionStringProvider : IConnectionStringProvider
{
    private readonly ConnectionStringsOptions connectionStrings;

    public DefaultConnectionStringProvider(ConnectionStringsOptions connectionStrings)
    {
        this.connectionStrings = connectionStrings ?? throw new ArgumentNullException(nameof(connectionStrings));
    }

    public string GetConnectionString()
    {
        return connectionStrings.Default;
    }
}

/// <summary>
/// Superclass for connection string providers using the AWS Secrets manager.
/// The connection string 'template' is provided by the usual Default connection string from appsettings and then we
/// substitute in the real values for the secret parts based on information retrieved from the secrets manager.
/// </summary>
public abstract class AbstractAWSSecretsManagerConnectionStringProvider : IConnectionStringProvider
{
    protected readonly AWSSecretsManagerSettings awsSecretsManagerSettings;
    protected readonly ConnectionStringsOptions connectionStringsOptions;

    public AbstractAWSSecretsManagerConnectionStringProvider(
        AWSSecretsManagerSettings awsSecretsManagerSettings,
        ConnectionStringsOptions connectionStringsOptions)
    {
        this.awsSecretsManagerSettings = awsSecretsManagerSettings ?? throw new ArgumentNullException(nameof(awsSecretsManagerSettings));
        this.connectionStringsOptions = connectionStringsOptions ?? throw new ArgumentNullException(nameof(connectionStringsOptions));
    }

    public abstract string GetConnectionString();

    /// <summary>
    /// Fetch the secret information from the AWS secrets manager and use it to build a connection string from the secret
    /// elements we store in the secrets manager using the Default string as template. 
    /// </summary>
    protected async Task<string> FetchConnectionStringAsync(
        AWSSecretsManagerSettings awsSecretsManagerSettings,
        ConnectionStringsOptions connectionStringsOptions)
    {
        try
        {
            using (IAmazonSecretsManager client = new AmazonSecretsManagerClient(RegionEndpoint.GetBySystemName(awsSecretsManagerSettings.Region)))
            {
                GetSecretValueRequest request = new GetSecretValueRequest
                {
                    SecretId = awsSecretsManagerSettings.SecretName,
                    VersionStage = awsSecretsManagerSettings.VersionStage,
                };

                GetSecretValueResponse response;

                try
                {
                    response = await client.GetSecretValueAsync(request);
                }
                catch (Exception e)
                {
                    throw new InternalException($"Failed to get secret {awsSecretsManagerSettings.SecretName} from AWS Secrets Manager in region {awsSecretsManagerSettings.Region}.", e);
                }

                Dictionary<string, string> secretData = JsonConvert.DeserializeObject<Dictionary<string, string>>(response.SecretString);
                string connectionString = ConnectionStringUtils.BuildConnectionStringFromAWSSecret(connectionStringsOptions.Default, secretData);
                return connectionString;
            }
        }
        catch(Exception e)
        {
            throw new InternalException($"Failed to get connection string. Reason={e.Message}", e);
        }
    }
}

/// <summary>
/// Calls the secrets manager to get the secrets on first demand and caches the resultant connection string thereafter
/// </summary>
public class LazyAWSSecretsManagerConnectionStringProvider : AbstractAWSSecretsManagerConnectionStringProvider, IConnectionStringProvider
{
    private readonly Lazy<string> lazyConnectionString;

    public LazyAWSSecretsManagerConnectionStringProvider(
        AWSSecretsManagerSettings awsSecretsManagerSettings,
        ConnectionStringsOptions connectionStringsOptions)
        : base(awsSecretsManagerSettings, connectionStringsOptions)
    {
        if (!awsSecretsManagerSettings.IsEnabled)
            throw new InvalidOperationException("Secrets manager is not enabled");
        this.lazyConnectionString = new Lazy<string>( () =>
            {
                string connectionString =
                    FetchConnectionStringAsync(awsSecretsManagerSettings, connectionStringsOptions)
                    .GetAwaiter()
                    .GetResult(); //sync over async :-(                
                return connectionString;
            }, System.Threading.LazyThreadSafetyMode.PublicationOnly);
        //nb: In the SurveyPlus context we'd (normally) expect the very first call to get a connection string
        //to be sometime during startup, so I don't expect to see multiple threads call at once for the first call 
        //but if they do lets use Publication mode and incur slight expense of an extra call to the secrets manager.
    } 

    /// <summary>
    /// On first demand, fetch the connection string from the secrets manager and cache it. Subsequently return that string on
    /// each demand.
    /// </summary>
    /// <returns>connection string</returns>
    public override string GetConnectionString()
    {
        return lazyConnectionString.Value;
    }
}

/// <summary>
/// Calls the secrets manager and builds the connection string on every demand.
/// This impl is provided in case we have issues with the lazy one and will likely be removed in a future build.
/// </summary>
public class BusyAWSSecretsManagerConnectionStringProvider : AbstractAWSSecretsManagerConnectionStringProvider, IConnectionStringProvider
{
    public BusyAWSSecretsManagerConnectionStringProvider(
        AWSSecretsManagerSettings awsSecretsManagerSettings,
        ConnectionStringsOptions connectionStringsOptions)
        : base(awsSecretsManagerSettings, connectionStringsOptions) { }

    public override string GetConnectionString()
    {
        string connectionString
            = FetchConnectionStringAsync(awsSecretsManagerSettings, connectionStringsOptions)
            .GetAwaiter()
            .GetResult(); //sync over async :-(
        return connectionString;
    }
}

public class ConnectionStringUtils
{
    /// <summary>
    /// Given a base connection string will try to build a connection string using data from the secretData object 
    /// and a baseConnectionString that can provide the rest of the information that isn't present in the secret.
    /// The secret is expected to have keys with the names used for SQL Server connection secrets as per AWS Secrets Manager.
    /// Where a key is absent or is empty then it will not be used to build the string, instead the value from the baseConnectionString
    /// will be retained. 
    /// For the DataSource the secret has seperate host and port keys, while the connectionstring has these merged as DataSource, so 
    /// where either host, port, or both are present and not empty in the secret then we shall try to reconstruct DataSource based 
    /// on what values are provided in the secret and in the baseConnectionString. 
    /// See: 
    /// https://docs.aws.amazon.com/secretsmanager/latest/userguide/reference_secret_json_structure.html#reference_secret_json_structure_RDS_sqlserver
    /// Keys in the secret:
    ///     "engine": "sqlserver" (not used here)
    ///     "host": instance host name/resolvable DNS name, used to build DataSource
    ///     "username": User ID,
    ///     "password": Password,
    ///     "dbname": Initial Catalog,
    ///     "port": port name, used to build DataSource
    ///     
    /// Additionally, this method will force the format of "Trust Server Certificate" to be "trustservercertificate" if present in 
    /// the final string because the usual format fails with RDS. 
    /// </summary>
    /// <param name="baseConnectionString">A connection string to use as base (can have placeholder values)</param>
    /// <param name="secret">dictionary providing additional data (i.e. such as obtained from the Secrets Manager)</param>
    /// <returns>A connection string</returns>
    public static string BuildConnectionStringFromAWSSecret(string baseConnectionString, Dictionary<string, string> secret)
    {
        if (baseConnectionString == null) throw new ArgumentNullException(nameof(baseConnectionString));
        if (secret == null) throw new ArgumentNullException(nameof(secret));

        SqlConnectionStringBuilder connectionStringBuilder = new SqlConnectionStringBuilder(baseConnectionString);

        string userId = secret.GetNonEmptyStringValueOrDefault("username");
        if (userId != null)
            connectionStringBuilder.UserID = userId;

        string password = secret.GetNonEmptyStringValueOrDefault("password");
        if (password != null)
            connectionStringBuilder.Password = password;

        //so for the builder we need to put the server name and the port together into one string as the DataSource but in the secrets
        //manager they are separate and maybe only one or neither or both specified, and if it only specifies port we would need to
        //get the host from the string, but maybe the string also has some other port. Or not. So we need to check that and build accordingly
        string host = secret.GetNonEmptyStringValueOrDefault("host");
        string port = secret.GetNonEmptyStringValueOrDefault("port");
        bool useDataSourceFromSecret = (host != null) || (port != null);
        if (useDataSourceFromSecret)
        {
            (string baseHost, string basePort) = SplitDataSource(connectionStringBuilder.DataSource??"");
            host = host ?? baseHost;
            port = port ?? basePort;
            connectionStringBuilder.DataSource = (port == null) ? host : $"{host}, {port}";
        }

        //corresponds to the "Initial Catalog" and "database" keys within the connection string
        string database = secret.GetNonEmptyStringValueOrDefault("dbname");
        if(database != null)
            connectionStringBuilder.InitialCatalog = secret["dbname"];

        string connectionString = connectionStringBuilder.ConnectionString;
        //The usual format of "Trust Server Certificate" as output by the builder
        //doesn't work for RDS, so we change to "trustservercertificate"
        //TODO - find some documentation on this, as right now googling finds no references, but I haven't RDS handy to test again atm
        string pattern = @"\bTrust Server Certificate\b";
        string replacement = "trustservercertificate";
        connectionString = Regex.Replace(connectionString, pattern, replacement, RegexOptions.IgnoreCase);

        return connectionString;
    }

    /// <summary>
    /// Given a Datasource with an optional Port, eg: "localhost, 1433" will split the string on the comma and return the host and port.
    /// If either is absent it will be returned as null. (Note that the validity of the port and host aren't checked here this is
    /// just a string splitting method, but if there is more than one comma then an ArgumentException is raised)
    /// </summary>
    public static (string host,string port) SplitDataSource(string dataSource)
    {
        if (dataSource == null) 
            throw new ArgumentNullException(nameof(dataSource));
        string[] elements = dataSource.Split(',');
        if (elements.Length > 2) 
            throw new ArgumentException("Invalid DataSource string", nameof(dataSource));
        string host = elements[0].Trim();
        string port = (elements.Length == 2) ? elements[1].Trim() : null;
        if (string.IsNullOrWhiteSpace(host))
            host = null;
        if (string.IsNullOrWhiteSpace(port))
            port = null;
        return (host, port);
    }
}