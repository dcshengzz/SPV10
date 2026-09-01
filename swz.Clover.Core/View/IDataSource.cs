using swz.Clover.Core.Model;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.Clover.Core.View
{
    /// <summary>
    /// Interface to allow the DataSource to be pluggable. This is to facilitate U@App architecture.
    /// Note that the class DataSource is static and doesn't implement this (newer) interface. Instead I have provided the
    /// class DataSourceAdapter which implements this interface and calls the static methods in DataSource.
    /// For SurveyPlus U@App the ApiDataSource will also implement this interface.
    /// </summary>
    public interface IDataSource
    {
        Task<(DynamicEntity Entity, bool IsFromUrl)> GetDataForFormAsync(GetDataRequest getDataRequest);

        Task<(bool Succeess, string Message)> DeleteDataForUrlAsync(ChangeDataRequest request, EntityModel model);

        //DataSource doesnt bother with the Async suffix on this one...
        Task<(FailResponse fail, ItemSuccessResponse<ChangeDataResponce> success)> ChangeData(ChangeDataRequest request);

        //nb: ChangeDataForUrlAsync is private in DataSource

        Task<(Dictionary<object, string>, long)> GetDictionaryAsync(GetDictionaryRequest getDictionaryRequest);
    }
}
