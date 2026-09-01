using System.Collections.Generic;

namespace swz.Clover.Core.Metadata
{
    public interface IMetadataItem
    {
        int FindInCollectionByKey<T>(List<T> coll) where T: IMetadataItem;
    }
}