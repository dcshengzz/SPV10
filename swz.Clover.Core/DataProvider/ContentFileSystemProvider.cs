using Newtonsoft.Json;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Utils;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading.Tasks;

namespace swz.Clover.Core.DataProvider
{
    public class ContentFileSystemProvider : IContentProvider
    {
        string folder;
   
        public ContentFileSystemProvider(string folderName)
        {
            folder = folderName;
        }

        private string GetDataFileName(string token)
        {
            return Path.Combine(folder, token);
        }

        private string GetPropFileName(string token)
        {
            return Path.Combine(folder, token + ".json");
        }

        public async Task<string> AddAsync(Stream stream, Dictionary<string, string> parameters, bool used = true)
        {
            var token = Guid.NewGuid().ToString("N");
            await insertAsync(token, stream, parameters, used);
            return token;
        }

        public async Task<(Stream Stream, Dictionary<string, string> Properties)> GetAsync(Guid token)
        {
            return await GetAsync(token.ToString());
        }

        public async Task<(Stream Stream, Dictionary<string, string> Properties)> GetAsync(string token)
        {
            var datafile = GetDataFileName(token);
            var pfile = GetPropFileName(token);

            Stream stream = null;
            if (File.Exists(datafile))
            {
                stream = File.OpenRead(pfile);
            }

            Dictionary<string, string> properties = null;
            if (File.Exists(pfile))
            {
                using (var file = File.OpenText(pfile))
                {
                    JsonSerializer serializer = new JsonSerializer();
                    properties = (Dictionary<string, string>)serializer.Deserialize(file, typeof(Dictionary<string, string>));
                }
            }

            return (Stream: stream, Properties: properties);
        }
        
        public async Task ReplaceAsync(string token, Stream stream, Dictionary<string, string> parameters)
        {
            var user = await CloverRuntime.Security.GetCurrentUserAsync();
            await RemoveAsync(token);
            await insertAsync(token, stream, parameters, true);
        }

        public async Task<bool> RemoveAsync(string token)
        {
            var datafile = GetDataFileName(token);
            var pfile = GetPropFileName(token);

            if (File.Exists(datafile))
                File.Delete(datafile);

            if (File.Exists(pfile))
                File.Delete(pfile);

            return true;
        }

        public async Task<bool> ExistAsync(string token)
        {
            var datafile = GetDataFileName(token);
            var pfile = GetPropFileName(token);
            return File.Exists(datafile) && File.Exists(pfile);
        }

        public async Task SetUsed(string token, bool used)
        {
            Guid id;
            if (Guid.TryParse(token, out id))
            {
                var item = await UploadedFilesPoor.SelectByKey(id);
                item.Used = used;
                await item.ApplyAsync();
            }
        }

        private async Task<string> insertAsync(string token, Stream stream, Dictionary<string, string> parameters, bool used = true)
        {
            var user = await CloverRuntime.Security.GetCurrentUserAsync();
            var datafile = GetDataFileName(token);
            var pfile = GetPropFileName(token);

            using (var dataStream = File.Create(datafile))
            {
                dataStream.Seek(0, SeekOrigin.Begin);
                await stream.CopyToAsync(dataStream);
            }

            var p = new Dictionary<string, object>();
            foreach (var parameter in parameters)
                p.Add(parameter.Key, parameter.Value);

            p.Add("CreatedBy", user?.Name);
            p.Add("CreatedDate", DateTime.Now);
            p.Add("Used", used);

            using (StreamWriter file = File.CreateText(pfile))
            {
                JsonSerializer serializer = new JsonSerializer();
                serializer.Serialize(file, p);
            }

            return token;
        }
    }
}
