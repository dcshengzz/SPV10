using swz.Clover.Core.Model;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.Clover.Core.View
{
    /// <summary>
    /// Allows use of the standard but static Clover DataSource via the new IDataSource interface
    /// (Interface allows it to be pluggable so we can use an alternate implementation when deploying for U@App)
    /// </summary>
    public class DataSourceAdapter : IDataSource
    {
        public async Task<(FailResponse fail, ItemSuccessResponse<ChangeDataResponce> success)> ChangeData(ChangeDataRequest request)
        {
            return await DataSource.ChangeData(request);
        }

        public async Task<(bool Succeess, string Message)> DeleteDataForUrlAsync(ChangeDataRequest request, EntityModel model)
        {
            return await DataSource.DeleteDataForUrlAsync(request, model);
        }

        public async Task<(DynamicEntity Entity, bool IsFromUrl)> GetDataForFormAsync(GetDataRequest getDataRequest)
        {
            return await DataSource.GetDataForFormAsync(getDataRequest);
        }

        public async Task<(Dictionary<object, string>, long)> GetDictionaryAsync(GetDictionaryRequest getDictionaryRequest)
        {
            return await DataSource.GetDictionaryAsync(getDictionaryRequest);
        }
    }
}
