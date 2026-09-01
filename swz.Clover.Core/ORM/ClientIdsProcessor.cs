using System;

namespace swz.Clover.Core.ORM
{
    public static class ClientIdsProcessor
    {
        public static bool IsClientId(string value)
        {
            return value?.StartsWith("CLIENT_", StringComparison.OrdinalIgnoreCase) ?? false;
        }

        public static string GenerateClientId()
        {
            return $"CLIENT_{Guid.NewGuid():N}";
        }
    }
}