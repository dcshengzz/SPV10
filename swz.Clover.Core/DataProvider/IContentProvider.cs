using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading.Tasks;

namespace swz.Clover.Core.DataProvider
{
    public interface IContentProvider
    {
        Task<string> AddAsync(Stream stream, Dictionary<string, string> properties, bool used = true);
        Task SetUsed(string token, bool used);
        Task ReplaceAsync(string token, Stream stream, Dictionary<string, string> properties);
        Task<bool> RemoveAsync(string token);
        Task<bool> ExistAsync(string token);
        Task<(Stream Stream, Dictionary<string, string> Properties)> GetAsync(string token);
        Task<(Stream Stream, Dictionary<string, string> Properties)> GetAsync(Guid token);
    }
}
