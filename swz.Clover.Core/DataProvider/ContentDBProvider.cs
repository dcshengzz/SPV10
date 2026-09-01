using Newtonsoft.Json;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Utils;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace swz.Clover.Core.DataProvider
{
    public class ContentDBProvider : IContentProvider
    {
        /// <summary>
        /// Thrown by AddAsync() if it is unable to add the uploaded file into db.
        /// You can refer to the inner exceptions for finer details on the cause.
        /// </summary>
        public class AddAsyncException : Exception
        {
            public AddAsyncException(string message, Exception innerException) : base(message, innerException) { }
        }

        public async Task<string> AddAsync(Stream stream, Dictionary<string, string> parameters, bool used = true)
        {
            try
            {
                var user = await CloverRuntime.Security.GetCurrentUserAsync();
                string name = string.Empty;
                if (parameters.ContainsKey(Constants.FileProperties.Name))
                {
                    name = parameters[Constants.FileProperties.Name];
                }

                string contentType = string.Empty;
                if (parameters.ContainsKey(Constants.FileProperties.ContentType))
                {
                    contentType = parameters[Constants.FileProperties.ContentType];
                }

			    bool isLocalStorage = false;
			    if (parameters.ContainsKey(Constants.FileProperties.IsLocalStorage) && parameters[Constants.FileProperties.IsLocalStorage] == "True")
			    {
			    	isLocalStorage = true;
			    }

			    var file = new UploadedFiles()
			    {
			    	Id = CloverRuntime.DbProvider.GenerateGuid(),
			    	Name = name,
			    	AttachmentLength = stream.Length,
			    	ContentType = contentType,
			    	CreatedBy = user?.Name,
			    	CreatedDate = DateTime.Now,
			    	Used = used,
			    	Properties = JsonConvert.SerializeObject(parameters),
			    	IsLocalStorage = isLocalStorage,
                    StructDivisionId = user != null ? user.StructDivisionId != null ? Guid.Parse(user.StructDivisionId.ToString()) : Guid.Empty : Guid.Empty
			    };
                file.Data = new byte[stream.Length];
                await stream.ReadExactlyAsync(file.Data, 0, (int)stream.Length);
                await file.ApplyAsync();
                return file.Id.ToString("N");
            }
            catch (IOException ioEx)
            {
                throw new AddAsyncException("Failed to read bytes from uploaded file", ioEx);
            }
            catch (Exception e)
            {
                throw new AddAsyncException("Unable to add uploaded file into db", e);
            }
        }

        public async Task<(Stream Stream, Dictionary<string, string> Properties)> GetAsync(Guid token)
        {
            return await GetAsync(token.ToString()).ConfigureAwait(false);
        }

        public async Task<(Stream Stream, Dictionary<string, string> Properties)> GetAsync(string token)
        { 
            Guid id;
            if (Guid.TryParse(token, out id))
            {
                var item = await UploadedFiles.SelectByKey(id);
                var stream = new MemoryStream(item.Data);

                var dic = new Dictionary<string, string>();
                dic.Add(Constants.FileProperties.Name, item.Name);
                dic.Add(Constants.FileProperties.Length, item.AttachmentLength.ToString());
                dic.Add(Constants.FileProperties.ContentType, item.ContentType);
				dic.Add(Constants.FileProperties.IsLocalStorage, item.IsLocalStorage.ToString());
                dic.Add(Constants.FileProperties.CreatedBy, item.CreatedBy);
                dic.Add(Constants.FileProperties.CreatedDate, item.CreatedDate.ToString());
                dic.Add(Constants.FileProperties.UpdatedBy, item.UpdatedBy);
                dic.Add(Constants.FileProperties.UpdatedDate, item.UpdatedDate.ToString());

                string propertiesString = item.Properties;
                var properties = String.IsNullOrWhiteSpace(propertiesString) ? null : JsonConvert.DeserializeObject<Dictionary<string, string>>(propertiesString);
                if(properties != null && properties.ContainsKey(Constants.FileProperties.IsDownloadable))
                {
                    dic.Add(Constants.FileProperties.IsDownloadable, properties[Constants.FileProperties.IsDownloadable]);
                }

                return (Stream: stream, Properties: dic);
            }
            return (Stream: null, Properties: null);
        }
        
        /// <summary>
        /// WARNING: THIS FUNCTION WILL SET IsLocalStorage=true and it doesn't care what it was before....
        /// THEREFORE ONLY USE IT WITH THE FILE STORAGE FEATURE!
        /// </summary>
        /// <param name="token"></param>
        /// <param name="stream"></param>
        /// <param name="parameters"></param>
        /// <returns></returns>
        public async Task ReplaceAsync(string token, Stream stream, Dictionary<string, string> parameters)
        {
            var user = await CloverRuntime.Security.GetCurrentUserAsync();

            string name = null;
            if (parameters.ContainsKey(Constants.FileProperties.Name))
            {
                name = parameters[Constants.FileProperties.Name];
            }

            string contentType = null;
            if (parameters.ContainsKey(Constants.FileProperties.ContentType))
            {
                contentType = parameters[Constants.FileProperties.ContentType];
            }
            
            Guid id;
            UploadedFiles file;
            if (Guid.TryParse(token, out id))
            {
                file = await UploadedFiles.SelectByKey(id);
            }
            else
            {
                file = new UploadedFiles(){
                    Id = id,
                    CreatedBy = user?.Name,
                    CreatedDate = DateTime.Now
                };
            }
			
			file.StartTracking();//Added this to apply update
			if (name != null)
				file.Name = name;
			if (file.ContentType != null)
				file.ContentType = contentType;
			file.UpdatedBy = user?.Name;
			file.UpdatedDate = DateTime.Now;
			file.Used = true;
			file.Data = new byte[stream.Length];
			file.IsLocalStorage = true; //  TODO <---- WHY IS THIS ALWAYS TRUE????????????????????????????
            
            if (stream != null) {
				await stream.ReadExactlyAsync(file.Data, 0, (int)stream.Length);
                file.AttachmentLength = stream.Length;
            }

            await UploadedFiles.ApplyAsync(file);
        }

        public async Task<bool> RemoveAsync(string token)
        {
            Guid id;
            if (Guid.TryParse(token, out id))
            {
                await UploadedFiles.Remove<Guid>(id);
                return true;
            }
            return false;
        }

        public async Task<bool> ExistAsync(string token)
        {
            Guid id;
            if (Guid.TryParse(token, out id))
            {
                var item = await UploadedFilesPoor.SelectByKey(id);
                return item != null;
            }
            return false;
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
    }
}
