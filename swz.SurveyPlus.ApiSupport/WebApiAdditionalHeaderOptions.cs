using System;
using System.Collections.Generic;

namespace swz.SurveyPlus.ApiSupport
{
    /// <summary>
    /// Specifies an additional http header to set on traffic between internet and intranet for the U@App API
    /// (Depending on the deployment environment some gateways may need this to allow requests to be passed)
    /// </summary>
    public class WebApiAdditionalHeaderOptions
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// True if the additional header is to be added to u@app api requests
        /// </summary>
        public bool AddAdditionalHeader
        {
            get { return !String.IsNullOrWhiteSpace(Name) && !string.IsNullOrWhiteSpace(Value); }
        }

        /// <summary>
        /// Name of the additional header to include in all u@app api requests
        /// </summary>
        public string Name { get; private set; } = string.Empty;

        /// <summary>
        /// Value for the additional header to include in all u@app api requests
        /// </summary>
        public string Value { get; private set; } = string.Empty;
        
        /// <summary>
        /// No args constructor, mainly for use by ASP.NET DI, will have no name:value and return false for AddAditionalHeader flag
        /// </summary>
        public WebApiAdditionalHeaderOptions()
        {
            ;
        }

        /// <summary>
        /// Constructor that takes the header name and value
        /// </summary>
        /// <param name="name">header name</param>
        /// <param name="value">header value</param>
        public WebApiAdditionalHeaderOptions(string name, string value)
        {
            this.Name = name;
            this.Value = value;
        }

        /// <summary>
        /// Returns the header name and value as a KeyValuePair if the additional header is configured, or false if it isn't.
        /// </summary>
        /// <returns>KeyValuePair representing header name and value. The name of the header will be the key.</returns>
        public KeyValuePair<string, string>? AsKeyValuePair()
        {
            if (AddAdditionalHeader)
                return new KeyValuePair<string, string>(Name, Value);
            else
                return null;
        }

        public void AddHeaderTo(System.Net.Http.HttpClient httpClient)
        {
            if (httpClient == null) throw new ArgumentNullException(nameof(httpClient));
            if (AddAdditionalHeader) httpClient.DefaultRequestHeaders.Add(Name, Value);
        }
    }
}
