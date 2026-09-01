using Microsoft.IdentityModel.Tokens;
using System;
using System.Text;

namespace swz.AspNetCore.Identity.Anonymous
{
    internal static class AnonymousIdEncoder
    {
        internal static string Encode(AnonymousIdData data)
        {
            if (data == null || string.IsNullOrWhiteSpace(data.AnonymousId))
            {
                return null;
            }

            byte[] bufferId = Encoding.UTF8.GetBytes(data.AnonymousId);
            byte[] bufferIdLength = BitConverter.GetBytes(bufferId.Length);
            byte[] bufferDate = BitConverter.GetBytes(data.ExpireDate.ToFileTime());
            byte[] buffer = new byte[12 + bufferId.Length];

            Buffer.BlockCopy(bufferDate, 0, buffer, 0, 8);
            Buffer.BlockCopy(bufferIdLength, 0, buffer, 8, 4);
            Buffer.BlockCopy(bufferId, 0, buffer, 12, bufferId.Length);

            return Base64UrlEncoder.Encode(buffer);
        }

        internal static AnonymousIdData Decode(string data)
        {
            if (string.IsNullOrEmpty(data))
            {
                return null;
            }

            try
            {
                byte[] blob = Base64UrlEncoder.DecodeBytes(data);

                if (blob == null || blob.Length < 13)
                {
                    return null;
                }

                DateTime expireDate = DateTime.FromFileTime(BitConverter.ToInt64(blob, 0));

                if (expireDate < DateTime.Now)
                {
                    return null;
                }

                int len = BitConverter.ToInt32(blob, 8);

                if (len < 0 || len > blob.Length - 12)
                {
                    return null;
                }

                string id = Encoding.UTF8.GetString(blob, 12, len);

                return new AnonymousIdData(id, expireDate);
            }
            catch 
            {
                //Make the null return here explicit for SVP-08 of the MPA SCR Report of 2022-04-09
                //If there is an error decoding the the data string it indicates the data value
                //is invalid so we return null to the caller to indicate this
                return null;
            }
        }
    }
}