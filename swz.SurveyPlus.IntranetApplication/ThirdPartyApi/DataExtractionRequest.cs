using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication.ThirdPartyApi
{
    /// <summary>
    /// Represents the requests to the 3PA for retrieving data.
    /// Provides factory methods to construct from JSON and dynamics.
    /// </summary>
    public class DataExtractionRequest
    {
        /// <summary>
        /// Identifies what sort of deployment specifier is in use. Currently we only support ApiIdentifier
        /// (which is implemented by IdentifierDeploymentSpecifier). Going forward we may add additional mechanisms here
        /// and the mapping between type and implementation class may well not be one-to-one, as the same impl class
        /// might be used with multiple types, or a single type might use multiple classes to support it.
        /// </summary>
        [JsonConverter(typeof(StringEnumConverter))]
        public enum SpecifierType { ApiIdentifier }

        /// <summary>
        /// Interface for classes that are used as a deployment specifier.
        /// Such classes should be immutable.
        /// Currently the sole implementation is IdentifierDeploymentSpecifier and the interface serves only to tag it as
        /// beign a specifier.
        /// </summary>
        public interface IDeploymentSpecifier { }

        /// <summary>
        /// Information that identifies the desired deployments by the ApiIdentifier together with a mandatory StartDate,
        /// as well as an optional End Date.
        /// </summary>
        public class IdentifierDeploymentSpecifier : IDeploymentSpecifier
        {
            public static IdentifierDeploymentSpecifier FromDynamic(dynamic deploymentSpecifier)
            {
                try
                {
                    Object status = deploymentSpecifier.status;
                    IEnumerable<string> statusEnumerable;
                    if (status == null)
                    {
                        statusEnumerable = Constants.Flyweights.Empty_ReadOnlyCollection_String;
                    }
                    else if(status is IEnumerable<string>)
                    {
                        statusEnumerable = (IEnumerable<string>)status;
                    } 
                    else if(status is JArray)
                    {
                        statusEnumerable = ((JArray)status).ToObject<string[]>();
                    }
                    else
                    {
                        throw new ArgumentException("deploymentSpecifier.status");
                    }

                    ApiIdentifier apiIdentifier;
                    try
                    {
                        apiIdentifier = ApiIdentifier.FromString((string)deploymentSpecifier.apiIdentifier);
                    }
                    catch(Exception e)
                    {
                        throw new ArgumentException("apiIdentifier", e);
                    }

                    string apiIdentifierString = (string)deploymentSpecifier.apiIdentifier;

                    return new IdentifierDeploymentSpecifier(
                        apiIdentifier,
                        (DateTime?)deploymentSpecifier.dateStart,
                        (DateTime?)deploymentSpecifier.dateEnd,
                        statusEnumerable,
                        (DateTime?)deploymentSpecifier.startAfter,
                        (DateTime?)deploymentSpecifier.startBefore
                    );
                }
                catch(ArgumentException)
                {
                    throw;
                }
                catch(Exception e)
                {
                    throw new ArgumentException(nameof(deploymentSpecifier), e);
                }
            }

            // // // // // // // // // // // // // // // // // // // // // // // //
            //NOTE: this object is intended to be immutable. DO NOT ADD SETTERS. //
            // // // // // // // // // // // // // // // // // // // // // // // //

            /// <summary>
            /// Required to identify the deployment(s) of interest.
            /// Deployments without an API identifier cannot be retrieved via the 3PA
            /// </summary>
            public ApiIdentifier ApiIdentifier { get; private set; }

            /// <summary>
            /// Optional to filter the deployment to one starting at this datetime (exact)
            /// May be required to disambiguate when selecting a single deployment and multiple deployments
            /// match other criteria
            /// </summary>
            public DateTime? DateStart { get; private set; }

            /// <summary>
            /// Optional to filter the deployment to one ending at this datetime (exact)
            /// May be required to disambiguate when selecting a single deployment and multiple deployments
            /// match other criteria
            /// </summary>
            public DateTime? DateEnd { get; private set; }

            /// <summary>
            /// Optional to filter deployments on list of status titles
            /// </summary>
            public IEnumerable<string> Status { get; private set; }

            /// <summary>
            /// Optional to filter deployments starting on or after (inclusive) this time
            /// </summary>
            public DateTime? StartAfter { get; private set; }

            /// <summary>
            /// Optional to filter deployments starting before (exclusive) this time
            /// </summary>
            public DateTime? StartBefore { get; private set; }

            [JsonConstructor]    //<-- is this used/working? remove if not
            private IdentifierDeploymentSpecifier(
                [JsonConverter(typeof(ApiIdentifier.JsonConverterImpl))]
                ApiIdentifier apiIdentifier,
                DateTime? dateStart,
                DateTime? dateEnd,
                IEnumerable<string> status,
                DateTime? startAfter,
                DateTime? startBefore)

            {
                if (apiIdentifier == null) throw new ArgumentNullException(nameof(apiIdentifier));
                this.ApiIdentifier = apiIdentifier;
                this.DateStart = dateStart;
                this.DateEnd = dateEnd;
                this.Status = new ReadOnlyCollection<string>(new List<string>(status));
                this.StartAfter = startAfter;
                this.StartBefore = startBefore;
            }
        }

        // // // // // // // // // // // // // // // //

        /// <summary>
        /// Exception thrown by AtaExtractionRequest factory methods if the provided information is malformed or invalid
        /// </summary>
        public class InvalidDataExtractionRequestException : ArgumentException
        {
            public InvalidDataExtractionRequestException(string message) : base(message) { }

            public InvalidDataExtractionRequestException(string message, Exception root) : base(message, root) { }
        }

        /// <summary>
        /// Factory method to construct an instance of ExtractDataRequest from a dynamic having the expected properties.
        /// Note that extraneous properties will be ignored. 
        /// Throws InvalidDataExtractionRequestException to report failure 
        /// </summary>
        /// <param name="d">a dynamic (for example from JSON deserialisation to a dynamic)</param>
        /// <returns></returns>
        public static DataExtractionRequest FromDynamic(dynamic d)
        {
            try
            {
                if( !Enum.TryParse<SpecifierType>((string)d.specifyDeploymentBy, ignoreCase: true, out var specifyDeploymentBy))
                    throw new InvalidDataExtractionRequestException("specifyDeploymentBy");
                DataExtractionRequest.IDeploymentSpecifier deploymentSpecifier = null;
                if (specifyDeploymentBy == DataExtractionRequest.SpecifierType.ApiIdentifier)
                {
                    deploymentSpecifier = IdentifierDeploymentSpecifier.FromDynamic(d.deploymentSpecifier);
                } 
                else
                {
                    //Valid enum value, but we have not yet implemented it here
                    throw new NotImplementedException(specifyDeploymentBy.ToString());
                }
                return new DataExtractionRequest(
                    (bool)d.allowMultipleDeployments,
                    specifyDeploymentBy,
                    deploymentSpecifier);
            }
            catch(InvalidDataExtractionRequestException)
            {
                throw;
            }
            catch (ArgumentException ae)
            {
                throw new InvalidDataExtractionRequestException(ae.Message, ae);
            }
            catch (Exception e)
            {
                throw new InvalidDataExtractionRequestException("Invalid Data", e);
            }
            
        }

        /// <summary>
        /// Factory method to create an instance from a UTF-8 JSON stream.
        /// Note that extraneous properties will be ignored. 
        /// Throws InvalidDataExtractionRequestException to report failure
        /// </summary>
        /// <param name="stream"></param>
        /// <returns></returns>
        public static async Task<DataExtractionRequest> FromJsonStreamAsync(Stream stream)
        {
            try
            {
                string json = null;
                using (StreamReader reader = new StreamReader(stream, Encoding.UTF8))
                {
                    json = await reader.ReadToEndAsync();
                }
                dynamic d = JsonConvert.DeserializeObject<dynamic>(json);
                DataExtractionRequest dataRequest = FromDynamic(d);
                return dataRequest;
            }
            catch (InvalidDataExtractionRequestException)
            {
                throw;
            }
            catch (Exception e)
            {
                //The assumption here is that whatever caused the exception was due to bad data
                //(in case of code/logic/environment errors this may not be the case)
                throw new InvalidDataExtractionRequestException("Unable to parse", e);
            }
        }

        /// <summary>
        /// When true this indicates the caller is ok to receive more than one deployment matching the specifier.
        /// When false then finding multiple deployments that match the specifier will be considered an error.
        /// </summary>
        public bool AllowMultipleDeployments { get; private set; }

        /// <summary>
        /// Indicates the mechanism used to select the deployments of interest (and thus what implementation of IDeploymentSpecifier is
        /// being used though the mapping isn't necessarily 1-1). 
        /// </summary>
        public SpecifierType SpecifyDeploymentBy { get; private set; }

        /// <summary>
        /// The deployment specifier. This is the important part of the request and contains the information
        /// to select and filter which deployments are of interest to the caller.
        /// </summary>
        public IDeploymentSpecifier DeploymentSpecifier { get; private set; }

        [JsonConstructor]
        private DataExtractionRequest(
            bool? allowMultipleDeployments,
            SpecifierType? specifyDeploymentBy,
            IDeploymentSpecifier deploymentSpecifier)
        {
            //nb: allowing nulls in the args is deliberate to help us catch deserialisation of junk json
            if (allowMultipleDeployments == null) throw new ArgumentNullException(nameof(allowMultipleDeployments));
            if (specifyDeploymentBy == null) throw new ArgumentNullException(nameof(specifyDeploymentBy));
            if (deploymentSpecifier == null) throw new ArgumentNullException(nameof(deploymentSpecifier));
            this.AllowMultipleDeployments = (bool)allowMultipleDeployments;
            this.SpecifyDeploymentBy = (SpecifierType)specifyDeploymentBy;
            this.DeploymentSpecifier = deploymentSpecifier;
        }

    } //end of ExtractDataRequest
}
