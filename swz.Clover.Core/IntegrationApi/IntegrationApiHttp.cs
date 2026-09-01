using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Linq;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Extensions;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using swz.Clover.Core.View;

namespace swz.Clover.Core.IntegrationApi
{
    public static class IntegrationApiPath
    {
        public static string ApiPath = "/api";
        public static string SwaggerPath = "/swagger";
    }
    
    public static class IntegrationApiHttp
    {
        public static async Task<object> Process(HttpRequest request)
        {
            if (request.Method.Equals("OPTIONS", StringComparison.OrdinalIgnoreCase))
                return new SuccessResponse();


            var queryDictionary = await GetParametersFromRequest(request);

            queryDictionary = queryDictionary.ToDictionary(kvp => kvp.Key.ToLower(), kvp => kvp.Value);

            var url = new Uri(request.GetEncodedUrl());

            if (url.Segments.Length < 5)
                throw new Exception($"Wrong url {url}");

            var operation = url.Segments[2].Trim('/');
            var mode = url.Segments[3].Trim('/');
            var name = url.Segments[4].Trim('/');
            string level = null;
            string filter = null;
            if (mode.Equals(IntegrationApiMode.Model.ToString("G"), StringComparison.OrdinalIgnoreCase) && url.Segments.Length > 6)
            {
                level = url.Segments[5].Trim('/');
                filter = url.Segments[6].Trim('/');
            }
            else if (mode.Equals(IntegrationApiMode.Model.ToString("G"), StringComparison.OrdinalIgnoreCase) && url.Segments.Length > 5)
            {
                filter = url.Segments[5].Trim('/');
            }
            else if (url.Segments.Length > 5)
            {
                filter = url.Segments[5].Trim('/');
            }

            queryDictionary.Add(IntegrationApiKeys.Operation, operation);
            queryDictionary.Add(IntegrationApiKeys.Mode, mode);
            queryDictionary.Add(IntegrationApiKeys.Name, name);
            if (level != null)
                queryDictionary.Add(IntegrationApiKeys.Level, level);
            if (filter != null)
                queryDictionary.Add(IntegrationApiKeys.UrlFilter, filter);

            var headerWithApiKey = request.Headers.FirstOrDefault(h => h.Key.Equals(IntegrationApiKeys.HeaderApiKey, StringComparison.OrdinalIgnoreCase));
            if (!string.IsNullOrEmpty(headerWithApiKey.Value) && !queryDictionary.ContainsKey(IntegrationApiKeys.ApiKey))
            {
                queryDictionary.Add(IntegrationApiKeys.ApiKey,headerWithApiKey.Value);
            }
              
            return await IntegrationApiProcessor.ProcessAsync(queryDictionary);
        }

        public static async Task<string> GetSwaggerSpecsAsync(HttpRequest request)
        {
            if (request.Method.Equals("OPTIONS", StringComparison.OrdinalIgnoreCase))
                return String.Empty;


            var queryDictionary = await GetParametersFromRequest(request);

            queryDictionary = queryDictionary.ToDictionary(kvp => kvp.Key.ToLower(), kvp => kvp.Value);

            var url = new Uri(request.GetEncodedUrl());
            
            if (url.Segments.Length >= 4)
            {
                var name = url.Segments[3].Trim('/');;
                queryDictionary.Add(IntegrationApiKeys.Name, name);
            }

            if (url.Segments.Length >= 3)
            {
                var mode = url.Segments[2].Trim('/');
                queryDictionary.Add(IntegrationApiKeys.Mode, mode);
            }

            return await IntegrationApiSwaggerGenerator.GenerateAsync(queryDictionary, url.Host + ":" + url.Port);
        }

        private static async Task<Dictionary<string,string>> GetParametersFromRequest(HttpRequest request)
        {
            var queryDictionary = request.Query.ToDictionary(c => c.Key.ToLower(), c => c.Value.ToString());

            if (!request.Method.Equals("POST", StringComparison.OrdinalIgnoreCase)
                && !request.Method.Equals("GET", StringComparison.OrdinalIgnoreCase))
                throw new Exception($"Method {request.Method} is not supported");

            if (request.Method.Equals("POST", StringComparison.OrdinalIgnoreCase)
                && !string.IsNullOrEmpty(request.ContentType)
                && !request.ContentType.StartsWith("multipart/form-data", StringComparison.OrdinalIgnoreCase)
                && !request.ContentType.Equals("application/json", StringComparison.OrdinalIgnoreCase)
                && !request.ContentType.Equals("application/x-www-form-urlencoded", StringComparison.OrdinalIgnoreCase))
                throw new Exception($"Content type {request.ContentType} is not supported");

            if (string.IsNullOrEmpty(request.ContentType))
                return queryDictionary;
            
            if (request.Method.Equals("POST", StringComparison.OrdinalIgnoreCase) && request.ContentType.Equals("application/json", StringComparison.OrdinalIgnoreCase))
            {
                //request = request.EnableRewind();
                HttpRequestRewindExtensions.EnableBuffering(request); //EnableRewind is replaced by this in 3.1
                string documentContents;
                using (var bodyStream = request.Body)
                {
                    using (var readStream = new StreamReader(bodyStream, Encoding.UTF8))
                    {
                        documentContents = await readStream.ReadToEndAsync().ConfigureAwait(false);
                    }
                }

                try
                {
                    var bodyDictionary = JsonConvert.DeserializeObject<Dictionary<string, JRaw>>(documentContents);

                    foreach (var kvp in bodyDictionary)
                    {
                        queryDictionary.Add(kvp.Key, kvp.Value.ToString());
                    }
                }
                catch (Exception)
                {
                    throw new Exception("Invalid request body type");
                }
            }
            else if (request.Method.Equals("POST", StringComparison.OrdinalIgnoreCase) &&
                     (request.ContentType.Equals("application/x-www-form-urlencoded", StringComparison.OrdinalIgnoreCase)
                      || request.ContentType.StartsWith("multipart/form-data", StringComparison.OrdinalIgnoreCase)) &&
                     request.Form != null)
            {
                foreach (var keyValuePair in request.Form)
                {
                    queryDictionary.Add(keyValuePair.Key, keyValuePair.Value.ToString());
                }
            }

            return queryDictionary;
        }
    }
}