using System;
using Newtonsoft.Json;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core.Metadata
{
    public class MetadataAttribute
    {
        public Guid Id;
        public Guid? ReferenceEntityId;
        public string Name;
        [JsonConverter(typeof(StringTypeConverter))]
        public Type Type;
        public byte TypeId;
        public bool IsNullable;
        public bool IsVirtual;
        public bool IsCalculated;
        public bool IsExtension;
    }
}