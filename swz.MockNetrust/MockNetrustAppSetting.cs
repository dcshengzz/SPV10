namespace swz.MockNetrust
{
    public class Settings
    {
        public MockNetrustAppSetting Corppass { get; } = new MockNetrustAppSetting();
    }

    public class MockNetrustAppSetting
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public LocationsOptions Locations { get; } = new LocationsOptions();

        public TokenOptions Token { get; } = new TokenOptions();
    }

    public class LocationsOptions
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// Where to post the JWT. 
        /// This would be the endpoint in our application to handle the SPCP login. 
        /// e.g. "http://localhost:28800/resp/corppassloginv2"
        /// </summary>
        public string Application { get; private set; } = "http://localhost:28800/resp/corppassloginv2";
    }

    public class TokenOptions
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public string MockCPEntID { get; private set; } = "testco";
    }
}
