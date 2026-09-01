namespace swz.MockNevis
{
    public class Settings
    {
        public MockNevisAppSetting Corppass { get; } = new MockNevisAppSetting();

        public MockNevisAppSetting Singpass { get; } = new MockNevisAppSetting();
    }

    public class MockNevisAppSetting
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        public Preferences Preferences { get; } = new Preferences();

        public LocationsOptions Locations { get; } = new LocationsOptions();

        public TokenOptions Token { get; } = new TokenOptions();
    }

    public class Preferences
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// Delay (in seconds) before the form returned by the consumption path
        /// submits itself.  0 is is no delay. If negative the self-post is disabled.
        /// </summary>
        public int SelfPostDelaySeconds { get; private set; } = 0;
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
        public string Application { get; private set; } = "http://localhost:27700/hello";

        /// <summary>
        /// Location of the pem file (base64) containing the private key to sign the token with.
        /// (This file will start with "-----BEGIN PRIVATE KEY-----")
        /// This is just a mock test application so storing the PK in a local file is
        /// fine here, but in a production application you need to give serious throught 
        /// as to how you manage the private keys as there are very significant security
        /// considerations.
        /// </summary>
        public string SignaturePrivateKeyPath { get; private set; }

        /// <summary>
        /// Location of the public key in base64 PEM format used for the encryption when encrypting the token.
        /// (Not required if not using encryption)
        /// (This file will begin with "-----BEGIN PUBLIC KEY-----")
        /// </summary>
        public string EncryptionPublicKeyPath { get; private set; } = "";

    }

    public class TokenOptions
    {
        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        //(Netcore can use the private ones when constructing it from configuration//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// Name of the parameter in the posted form that will contain the token
        /// </summary>
        public string TokenParameter { get; private set; } = "token";

        /// <summary>
        /// The value to use for the entityInfo claim in the generated tokens. Note the name of this claim (e.g. entityInfo or sub etc)
        /// is set by the EntityInfoClaim property
        /// Based on the sample provided, the format is like
        ///     { "CPEntID": "82532759L", "CPEnt_TYPE": "UEN",
        ///     "CPEnt_Status": "Registered", "CPNonUEN_Country": "",
        ///     "CPNonUEN_RegNo": "", "CPNonUEN_Name": "" }
        /// So the UEN needs to go in the CPEntID property.
        /// </summary>
        public string EntityInfo { get; private set; } = "{ \"CPEntID\": \"testco\", \"CPEnt_TYPE\": \"UEN\",\r\n\"CPEnt_Status\": \"Registered\", \"CPNonUEN_Country\": \"\",\r\n\"CPNonUEN_RegNo\": \"\", \"CPNonUEN_Name\": \"\" }";

        /// <summary>
        /// Property to facilitate overriding the name of the claim in which we send the entity information
        /// included amongst which will be the UEN.
        /// Default is "entityInfo", for singpass should be "sub"
        /// </summary>
        public string EntityInfoClaim { get; private set; } = "entityInfo";

        /// <summary>
        /// Audience claim for the token. 
        /// Applications should check this. 
        /// Convention is to use the application url.
        /// </summary>
        public string Audience { get; private set; } = "http://example.com";

        /// <summary>
        /// Issuer claim. 
        /// </summary>
        public string Issuer { get; private set; } = "swz.MockNevis";

        /// <summary>
        /// MockNevis will set an expiry date based on the creation time and this setting.
        /// It was indicated we will likely be using 1 or 2 minutes in production.
        /// </summary>
        public int ExpirySeconds { get; private set; } = 60;

        /// <summary>
        /// Algorithm to sign the JWT with. Default is "RS834" (RsaSha384)
        /// Refer to the values defined in Microsoft.IdentityModel.Tokens.SecurityAlgorithms
        /// </summary>
        public string SignatureAlgorithm { get; private set; } = "RS384";

        /// <summary>
        /// (Optional) JWE key wrapping algorithm, e.g. RsaOAEP, default is none
        /// </summary>
        public string WrapEncryptionAlgorithm { get; private set; } = "";

        public bool IsUsingEncryption { get => !string.IsNullOrWhiteSpace(WrapEncryptionAlgorithm); }

        /// <summary>
        /// JWE data encrytion algorithm (used if WrapEncryption algroithm is specified)
        /// e.g. Aes256Gcm, default is none
        /// </summary>
        public string DataEncryptionAlgorithm { get; private set; } = "";
    }
}
