using System.Collections.Generic;

namespace swz.MockNetrust
{
    public class NetrustToken
    {
        public string code { get; set; } = "";
        public SPCPToken token { get; set; } = new SPCPToken();
    }

    /// <summary>
    /// {\"access_token\":\"eyJ0eXAiOiJKV1QiLCJraWQiOiItekFvcnBoS1V5TnpINVlMNDVhTVlKRmxITDFPWWNvOFpZTmZOWi01b0xvIiwiYWxnIjoiRVMyNTYifQ.eyJzdWIiOiJDUDEyNTU3NyIsImV4cCI6MTY0NTY4MTYzMiwiaWF0IjoxNjQ1NjgxMDMyLCJpc3MiOiJodHRwczovL3N0Zy1pZC5jb3JwcGFzcy5nb3Yuc2ciLCJhdWQiOiIwNW1KNmYwc2ZvdkZMZ05oeG1yMiIsInNjb3BlIjpbImF1dGhpbmZvIiwidHBhdXRoaW5mbyJdfQ.QZ9ochY-MhDohCDl6vBHJDPHgqyP8_tIpCXEyY382ey_SsiX7Vc_zgfZtiBd2yuL_veBgKKIo0UteeOgOpxfkw\",\"id_token_value\":{\"userInfo\":{\"CPAccType\":\"Admin\",\"CPUID_FullName\":\"USERS9991595A\",\"ISSPHOLDER\":\"YES\"},\"entityInfo\":{\"CPEntID\":\"" + mockCPEntID + "\",\"CPEnt_TYPE\":\"UEN\",\"CPEnt_Status\":\"Registered\",\"CPNonUEN_Country\":\"\",\"CPNonUEN_RegNo\":\"\",\"CPNonUEN_Name\":\"\"},\"nonce\":\"UnbnSwXeaQaaeYyiVvdRMfYwgWIGHSW0\",\"amr\":[\"pwd\"],\"iat\":1645681031,\"iss\":\"https://stg-id.corppass.gov.sg\",\"sub\":\"s=S9991595A,u=CP125577,c=SG\",\"at_hash\":\"bhtl6G48igXiJVfdz6rlyQ\",\"exp\":1645681631,\"aud\":\"05mJ6f0sfovFLgNhxmr2\"},\"scope\":\"openid\",\"id_token\":\"eyJraWQiOiItekFvcnBoS1V5TnpINVlMNDVhTVlKRmxITDFPWWNvOFpZTmZOWi01b0xvIiwiYWxnIjoiRVMyNTYifQ.eyJ1c2VySW5mbyI6eyJDUEFjY1R5cGUiOiJBZG1pbiIsIkNQVUlEX0Z1bGxOYW1lIjoiVVNFUiBTOTk5MTU5NUEiLCJJU1NQSE9MREVSIjoiWUVTIn0sImVudGl0eUluZm8iOnsiQ1BFbnRJRCI6IjE4MDAyODcxOUciLCJDUEVudF9UWVBFIjoiVUVOIiwiQ1BFbnRfU3RhdHVzIjoiUmVnaXN0ZXJlZCIsIkNQTm9uVUVOX0NvdW50cnkiOiIiLCJDUE5vblVFTl9SZWdObyI6IiIsIkNQTm9uVUVOX05hbWUiOiIifSwibm9uY2UiOiJVbmJuU3dYZWFRYWFlWXlpVnZkUk1mWXdnV0lHSFNXMCIsImFtciI6WyJwd2QiXSwiaWF0IjoxNjQ1NjgxMDMxLCJpc3MiOiJodHRwczovL3N0Zy1pZC5jb3JwcGFzcy5nb3Yuc2ciLCJzdWIiOiJzPVM5OTkxNTk1QSx1PUNQMTI1NTc3LGM9U0ciLCJhdF9oYXNoIjoiYmh0bDZHNDhpZ1hpSlZmZHo2cmx5USIsImV4cCI6MTY0NTY4MTYzMSwiYXVkIjoiMDVtSjZmMHNmb3ZGTGdOaHhtcjIifQ.UwOcU7VP-tjI7nz7FU7AchR6w6vea5kMz0SO8DpMMlia_PxauDmoz3HpOQZjZHSlgxOB4QroIRHpc4GK71-5pA\",\"access_token_value\":{\"iat\":1645681032,\"AuthInfo\":\"{\\\"Result_Set\\\":{\\\"ESrvc_Row_Count\\\":1,\\\"ESrvc_Result\\\":[{\\\"CPESrvcID\\\":\\\"IMDA-GS\\\",\\\"Auth_Result_Set\\\":{\\\"Row_Count\\\":1,\\\"Row\\\":[{\\\"CPEntID_SUB\\\":\\\"\\\",\\\"CPRole\\\":\\\"OR\\\",\\\"StartDate\\\":\\\"2020-02-20\\\",\\\"EndDate\\\":\\\"9999-12-31\\\",\\\"Parameter\\\":[]}]}]}\",\"iss\":\"https://stg-id.corppass.gov.sg\",\"exp\":1645681632,\"aud\":\"05mJ6f0sfovFLgNhxmr2\"},\"token_type\":\"bearer\",\"expires_in\":599}
    /// </summary>
    public class SPCPToken
    {
        public string access_token { get; set; } = "test_access_token";
        public IdTokenValue id_token_value { get; set; } = new IdTokenValue();

        public class EntityInfo
        {
            public string CPEntID { get; set; } = ""; // to get from appsetting or browser
            public string CPEnt_TYPE { get; set; } = "UEN";
            public string CPEnt_Status { get; set; } = "Registered";
            public string CPNonUEN_Country { get; set; } = "";
            public string CPNonUEN_RegNo { get; set; } = "";
            public string CPNonUEN_Name { get; set; } = "";
        }

        public class IdTokenValue
        {
            public UserInfo userInfo { get; set; } = new UserInfo();
            public EntityInfo entityInfo { get; set; } = new EntityInfo();
            public string nonce { get; set; } = ""; //to get from user browser
            public List<string> amr { get; set; } = new List<string>{ "arm" };
            public int iat { get; set; } = 1645681031;
            public string iss { get; set; } = "https://stg-id.corppass.gov.sg";
            public string sub { get; set; } = "s=S9991595A,u=CP125577,c=SG";
            public string at_hash { get; set; } = "bhtl6G48igXiJVfdz6rlyQ";
            public int exp { get; set; } = 1645681631;
            public string aud { get; set; } = "05mJ6f0sfovFLgNhxmr2";
        }

        public class UserInfo
        {
            public string CPAccType { get; set; } = "Admin";
            public string CPUID_FullName { get; set; } = "USERS9991595A";
            public string ISSPHOLDER { get; set; } = "YES";
        }
    }
}