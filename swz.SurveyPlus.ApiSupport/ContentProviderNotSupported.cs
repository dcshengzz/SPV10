using swz.Clover.Core.DataProvider;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace swz.SurveyPlus.ApiSupport
{
    /// <summary>
    /// A placeholder implementation of the IContentProvider API that will throw a NotImplementedException from all its methods
    /// </summary>
    public class ContentProviderNotSupported : IContentProvider
    {
        private const string ApiNotSupported = "The IContentProvider API is not supported here";

        //private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger<ContentProviderNotSupported>();

        public Task<string> AddAsync(Stream stream, Dictionary<string, string> properties, bool used = true)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task<bool> ExistAsync(string token)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task<(Stream Stream, Dictionary<string, string> Properties)> GetAsync(string token)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task<(Stream Stream, Dictionary<string, string> Properties)> GetAsync(Guid token)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task<bool> RemoveAsync(string token)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task ReplaceAsync(string token, Stream stream, Dictionary<string, string> properties)
        {
            throw new NotImplementedException(ApiNotSupported);
        }

        public Task SetUsed(string token, bool used)
        {
            throw new NotImplementedException(ApiNotSupported);
        }
    }
}
