using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using swz.Clover.Core.ORM;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core.Metadata.DbObjects
{
    public enum AuthenticationType : byte
    {
        Generic = 0,
        Domain = 1, //Domain covers legacy AD login and Entra ID login (eg Saml2)
    }

    public enum AccessType : byte
    {
        Inherit = 0,
        Allow = 1,
        Deny = 2
    }

    public class SecurityUser : DbObject<SecurityUser>
    {
        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

        [DbObjectModel]
        public string Name
        {
            get => _entity.Name;
            set => _entity.Name = value;
        }

        [DbObjectModel]
        public string Email
        {
            get => _entity.Email;
            set => _entity.Email = value;
        }

        [DbObjectModel]
        public string ExternalId
        {
            get => _entity.ExternalId;
            set => _entity.ExternalId = value;
        }

        [DbObjectModel]
        public string Timezone
        {
            get => _entity.Timezone;
            set => _entity.Timezone = value;
        }

        [DbObjectModel]
        public string Localization
        {
            get => _entity.Localization;
            set => _entity.Localization = value;
        }

        [DbObjectModel]
        public bool IsLocked
        {
            get => _entity.IsLocked;
            set => _entity.IsLocked = value;
        }

        [DbObjectModel]
        public Guid? StructDivisionId
        {
            get => _entity.StructDivisionId;
            set => _entity.StructDivisionId = value;
        }

        [DbObjectModel]
        public string GaSalt
        {
            get => _entity.GaSalt;
            set => _entity.GaSalt = value;
        }

		[DbObjectModel]
		public int NumRetry
		{
			get => _entity.NumRetry;
			set => _entity.NumRetry = value;//_entity.IsLocked == false ? 0 : value;
		}

		[DbObjectModel]
		public string IpAddress
		{
			get => _entity.IpAddress;
			set => _entity.IpAddress = value;
		}

		[DbObjectModel]
		public string BrowserType
		{
			get => _entity.BrowserType;
			set => _entity.BrowserType = value;
		}

		[DbObjectModel]
		public DateTime? LastLoginDate
		{
			get => _entity.LastLoginDate;
			set => _entity.LastLoginDate = value;
		}

        [DbObjectModel]
        public DateTime? DormancyDate
        {
            get => _entity.DormancyDate;
            set => _entity.DormancyDate = value;
        }

        [DbObjectModel]
        public Guid? CreatedBy
        {
            get => _entity.CreatedBy;
            set => _entity.CreatedBy = value;
        }

        [DbObjectModel]
        public DateTime? CreatedDate
        {
            get => _entity.CreatedDate;
            set => _entity.CreatedDate = value;
        }

        [DbObjectModel]
        public Guid? UpdatedBy
        {
            get => _entity.UpdatedBy;
            set => _entity.UpdatedBy = value;
        }

        [DbObjectModel]
        public DateTime? UpdatedDate
        {
            get => _entity.UpdatedDate;
            set => _entity.UpdatedDate = value;
        }

        [DbObjectModel]
        public string LinkedDomainLogin
        {
            get => _entity.LinkedDomainLogin;
            set => _entity.LinkedDomainLogin = value;
        }

        public DbReferencedProperty<List<string>> Groups;
        public DbReferencedProperty<List<string>> Roles;

        public SecurityUser()
        {
            Groups = new DbReferencedProperty<List<string>>(async () => (await SecurityGroupToSecurityUser.SelectByUser(Id).ConfigureAwait(false)).Select(c => c.SecurityGroupCode).ToList());
            Roles = new DbReferencedProperty<List<string>>(async () => (await SecurityUserToSecurityRole.SelectByUser(Id).ConfigureAwait(false)).Select(c => c.SecurityRoleCode).ToList());
        }

        public static async Task<SecurityUser> GetUserById(Guid userId)
        {
            Filter filter = Filter.And.Equal(userId, Constants.FieldName.dwSecurityUser.Id);
            return (await SelectAsync(filter)).FirstOrDefault();
        }

        public static async Task<string> GetEmailByUserId(Guid userId)
        {
            var filter = Filter.And.Equal(userId, "Id");
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result[0].Email : null;
        }

        public static async Task<Guid?> GetStructIdByUserId(Guid userId)
        {
            var filter = Filter.And.Equal(userId, "Id");
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result[0].StructDivisionId : null;
        }

        public static async Task<List<Guid>> GetStructIdWithChildStructIdByUserId(Guid userId)
        {
            var filter = Filter.And.Equal(userId, "Id");
            var user = await SelectAsync(filter).ConfigureAwait(false);
            if(user.Count > 0)
            {
                return await vStructDivisionParentsAndThis.GetByParentStructId(user[0].StructDivisionId.GetValueOrDefault()).ConfigureAwait(false);
            }

            return null;
        }

        public static async Task<List<SecurityUser>> GetByStructId(List<Guid> structId)
        {
            var filter = Filter.And.In(structId, "StructDivisionId");
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return (result.Count > 0) ? result : null;
        }

        //TODO - make the authenticationType mandatory (need to verify existing uses unaffected first)
        /// <summary>
        /// Get Security User by Credential Login
        /// </summary>
        /// <param name="login">identifies the user</param>
        /// <param name="authenticationType">type of login credential</param>
        /// <returns>SecurityUser or null if not found</returns>
        public static async Task<SecurityUser> SelectByPrincipal(string login, AuthenticationType? authenticationType=null)
        {
            Filter filter = Filter.And.Equal(login, Constants.FieldName.dwSecurityCredential.Login);
            if(authenticationType != null)
            {
                filter.Merge(Filter.And.Equal(authenticationType, Constants.FieldName.dwSecurityCredential.AuthenticationType));
            }
            List<SecurityCredential> credential = await SecurityCredential.SelectAsync(filter).ConfigureAwait(false);
            if (credential.Count > 0) //in practice should not occur because of unique index on Login column
                return await SelectByKey(credential[0].SecurityUserId).ConfigureAwait(false);
            return null;
        }

        public static async Task<bool> CheckPermission(Guid userId, string groupPermissionCode, string permissionCode)
        {
            var filter = Filter.And.Equal(userId, "UserId").Equal(groupPermissionCode, "PermissionGroupCode").Equal(permissionCode, "PermissionCode");
            bool hasPermission = false;
            List<V_Security_CheckPermissionUser> permissionList = await V_Security_CheckPermissionUser.SelectAsync(filter);
            if (permissionList != null && permissionList.Count > 0)
            {
                foreach (V_Security_CheckPermissionUser permission in permissionList)
                {
                    if (permission.AccessType == (byte)AccessType.Allow)
                    {
                        hasPermission = true;
                        break;
                    }
                }
            }
            return hasPermission;
        }

        //TODO - consider refactoring to move this to SecurityCredential class instead
        public static async Task<SecurityCredential> GetCredentialByLogin(string login)
        {
            var filter = Filter.And.Equal(login, "Login");
            var result = await SecurityCredential.SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result[0] : null;
        }

        //TODO - consider refactoring to move this to SecurityCredential class instead
        public static async Task<SecurityCredential[]> GetCredentialByUserId(Guid userId)
        {
            var filter = Filter.And.Equal(userId, Constants.FieldName.dwSecurityCredential.SecurityUserId);
            return (await SecurityCredential.SelectAsync(filter).ConfigureAwait(false)).ToArray();
        }

        public static async Task<Dictionary<string, string>> GetGenericLoginCredentialDictByUserId(List<Guid> userIdList)
        {
            Dictionary<string, string> result = new Dictionary<string, string>();
            Filter filter = Filter.And.In(userIdList, Constants.FieldName.dwSecurityCredential.SecurityUserId);
            filter.Merge(Filter.And.Equal(AuthenticationType.Generic, Constants.FieldName.dwSecurityCredential.AuthenticationType));
            List<SecurityCredential> scList = await SecurityCredential.SelectAsync(filter);
            if(scList != null && scList.Any())
            {
                foreach(SecurityCredential sc in scList)
                {
                    result[sc.SecurityUserId.ToString()] = sc.Login;
                }
            }
            return result;
        }

        public async static Task<Dictionary<Guid, SecurityUser>> GetAlternativeAccount(Security.User currentUser, bool excludeCurrentUser = true)
        {
            return await GetAlternativeAccount(currentUser.Id, currentUser.LinkedDomainLogin, excludeCurrentUser);
        }

        /// Get Alternative Account "Linked/Binded" with Domain Login (Windows Authenticate)
        /// (We also refer to the alt account as alternative or secondary profile in some docs and communications)
        /// </summary>
        /// <param name="UserId"></param>
        /// <param name="LinkedDomainLogin"></param>
        /// <param name="excludeCurrentUser"></param>
        /// <returns>List of Alternative Account "Linked/Binded" with Domain Login (Windows Authenticate)</returns>
        public async static Task<Dictionary<Guid, SecurityUser>> GetAlternativeAccount(Guid UserId, string LinkedDomainLogin, bool excludeCurrentUser = true)
        {
            Dictionary<Guid, SecurityUser> result = new Dictionary<Guid, SecurityUser>();
            bool isPrimary = string.IsNullOrEmpty(LinkedDomainLogin);
            Guid primaryUserId = isPrimary ? UserId : Guid.Empty;

            if (isPrimary)
            {
                //user.LinkedDomainLogin is empty on primary account
                //Require to find the Domain Login value
                SecurityCredential domainCredential = await GetDomainLoginCredential(primaryUserId);
                if (domainCredential != null) LinkedDomainLogin = domainCredential.Login;
            }
            else
            {
                //user.LinkedDomainLogin is available for alternate account
                //Require to find primary account user Id value
                SecurityCredential domainCredential = await SecurityUser.GetCredentialByLogin(LinkedDomainLogin);
                if (domainCredential != null) primaryUserId = domainCredential.SecurityUserId;
            }

            if (!string.IsNullOrEmpty(LinkedDomainLogin))
                result = await GetLinkedDomainLoginUser(LinkedDomainLogin, primaryUserId);

            if (excludeCurrentUser && result.Any())
            {
                result.Remove(UserId);
            }

            return result;
        }

        private static async Task<SecurityCredential> GetDomainLoginCredential(Guid userId)
        {
            SecurityCredential result = null;

            Filter filter = Filter.And.Equal(userId, Constants.FieldName.dwSecurityCredential.SecurityUserId);
            filter.Merge(Filter.And.Equal(AuthenticationType.Domain, Constants.FieldName.dwSecurityCredential.AuthenticationType));
            List<SecurityCredential> credentials = await SecurityCredential.SelectAsync(filter);
            if (credentials.Count > 0)
                result = credentials[0];

            return result;
        }

        /// <summary>
        /// Get user listing by Domain Login with "OR" SecurityUser.Id (to include the primary account) into the listing.
        /// Primay Account should have null for LinkedDomainLogin column.
        /// </summary>
        /// <param name="domainLogin">Domain Login to match LinkedDomainLogin</param>
        /// <param name="userId">Primary Account Security User Id</param>
        /// <returns></returns>
        private static async Task<Dictionary<Guid, SecurityUser>> GetLinkedDomainLoginUser(string domainLogin, Guid userId = new Guid())
        {
            Dictionary<Guid, SecurityUser> result = new Dictionary<Guid, SecurityUser>();

            Filter filter = Filter.Or.Equal(domainLogin, Constants.FieldName.dwSecurityUser.LinkedDomainLogin);
            if (userId != Guid.Empty)
            {
                filter.Merge(Filter.Or.Equal(userId, Constants.FieldName.dwSecurityUser.Id));
            }

            List<SecurityUser> users = await SecurityUser.SelectAsync(filter);
            if (users != null && users.Any())
            {
                result = users.ToDictionary(e => e.Id, e => e);
            }
            return result;
        }

        private static byte[] GaSecretEncryptionKey; //Please do not mutate outside of InitGaSaltEncryptionKey()

        /// <summary>
        /// Initialise the AES key for storing the TOTP secrets in GaSalt column in 20221010 format. 
        /// Need to call this at startup. 
        /// </summary>
        /// <param name="key"></param>
        public static void InitTotpSecretEncryptionKey(byte[] key)
        {
            if (GaSecretEncryptionKey != null) throw new InvalidOperationException("Key already initialised");
            if (key == null) throw new ArgumentNullException(nameof(key));
            if( key.Length==(256/8) ||  key.Length==(192/8) || key.Length==(128/8)) 
            {
                GaSecretEncryptionKey = key;
            }
            else
            {
                throw new ArgumentException(nameof(key), "Invalid length, must be 256 or 192 or 128 bits");
            }            
        }

        //Size in bytes of the secret in 20221010 format for the TOTP secret (its 128 bits)
        //Don't anyhow just change this because changing this will break existing GaSalt using the 20221010 format
        //so you would probably want to create a new format with its own length and prefix etc and keep supporting the 20221010
        //as another legacy format.
        //Most sites seem to use only 80 bits but by rights it should be at least 128 bits
        //using more results in excessively long keys to type
        //We shall use 128 bits (= 16 bytes)
        private const int totpSecretLength20221010 = 128/8;

        //Prefix for GaSalt with new & improved flavour (less salty, more secret)
        private const string formatMarker20221010 = "TOTP20221010\t";

        /// <summary>
        /// Generate an encrypted random value for use as a TOTP secret. 
        /// This is used by the ResetTotpSecret method.
        /// This is in what we call the 'new 20221010 format', but the returned value does not 
        /// include the formatMarker20221010 prefix (ResetTotpSecret would add it)
        /// </summary>
        public static string GenerateEncryptedTotpSecretBase64(Guid userId, byte[] encryptionKey)
        {
            //Have moved this logic to a static method to make it unit testable
            //without needing to create an instance of SecurityUser

            if (encryptionKey == null) throw new ArgumentNullException(nameof(encryptionKey));
            try
            {
                using (Aes aesAlg = Aes.Create())
                {
                    aesAlg.Key = encryptionKey;
                    aesAlg.IV = userId.ToByteArray();
                    byte[] secret = new byte[totpSecretLength20221010];
                    using (var rng = RandomNumberGenerator.Create()) { rng.GetBytes(secret); }
                    ICryptoTransform encryptor = aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV);
                    using (MemoryStream msEncrypt = new MemoryStream())
                    {
                        using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                        {
                            csEncrypt.Write(secret, 0, secret.Length);
                            csEncrypt.FlushFinalBlock(); //Ensure valid padding, see: https://stackoverflow.com/a/40564155/8243046
                            return Convert.ToBase64String(msEncrypt.ToArray());
                        }
                    }
                }
            }
            catch(Exception e)
            {
                throw new Exception("Failed to generate TOTP secret", e);
            }
        }

        /// <summary>
        /// Takes a 'new 20221010 format' base64 totp secret (the part after the marker in GaSalt) and decrypts it.
        /// nb.b this is not a general-purpose decryptor, it is for the totp secrets in SecurityUser and will assert
        /// that the decrypted result meets our expectations for those.
        /// </summary>
        public static byte[] DecryptTotpSecret(Guid userId, byte[] encryptionKey, string encryptedSecretBase64)
        {
            if (encryptionKey == null) throw new ArgumentNullException(nameof(encryptionKey));
            if (string.IsNullOrEmpty(encryptedSecretBase64)) throw new ArgumentException(nameof(encryptedSecretBase64));
            try
            {
                byte[] encryptedSecret = Convert.FromBase64String(encryptedSecretBase64);
                using (Aes aesAlg = Aes.Create())
                {
                    aesAlg.Key = encryptionKey;
                    aesAlg.IV = userId.ToByteArray();
                    ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV);
                    using (MemoryStream msDecrypt = new MemoryStream(encryptedSecret))
                    {
                        using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                        {
                            using (BinaryReader reader = new BinaryReader(csDecrypt))
                            {
                                //We try to read just a little more than the number of bytes we expect. That way if the
                                //secret is too long we will know. (ReadBytes can return less than the amount requested
                                //and here we actually expect totpSecretLength)
                                byte[] secret = reader.ReadBytes(totpSecretLength20221010+1);
                                if (secret.Length != totpSecretLength20221010)
                                {
                                    throw new InvalidOperationException($"The TOTP secret is invalid for 20221010 format because it is not {totpSecretLength20221010*8} bits in length");
                                }
                                return secret;
                            }
                        }
                    }
                }
            }
            catch (InvalidOperationException)
            {
                throw;
            }
            catch (Exception e)
            {
                //Other errors
                //n.b if you see invalid padding errors here, check:
                //  AES key and IV are same used to encrypt (we use bytes from the Id as the initialization vector here)
                //  and that FlushFinalBlock was called when encrypting 
                throw new Exception("Unable to decrypt encrypted TOTP secret (20221010 format)", e);
            }
        }
        
        /// <summary>
        /// Reset the TOTP Secret for a user, note that the Id MUST be set first as it is necessary for this operation. 
        /// </summary>
        public void ResetTotpSecret()
        {
            //This is now using the new 20221010 format, which is an encrypted secret stored in the GaSalt column
            //(in this format its storing the entire secret in GaSalt, not just a salt, but I'm not going to rename the
            //column, and for all the legacy format records it will still be a salt). 
            Guid id = (Guid)(_entity["Id"] 
                ?? throw new InvalidOperationException($"Id is not initialised in this {nameof(SecurityUser)} object"));
            byte[] encryptionKey = GaSecretEncryptionKey
                 ?? throw new InvalidOperationException($"TOTP encryption key is not initialised in {nameof(SecurityUser)} class");
            GaSalt = formatMarker20221010 + GenerateEncryptedTotpSecretBase64(id, encryptionKey);
        }

        /// <summary>
        /// Returns the GA secret for this user, this is based on the GaSalt and other user-specific information.
        /// We now support to formats, the encrypted 20221010 secret format, and the legacy plaintext ASCII salt format.
        /// (Callers must not concern themselves with the exact implementation as we may wish to evolve it later)
        /// If the secret/salt has not been initialised then this will return null. 
        /// WARNING: this can only be called on a SecurityUser that already has an Id set (throws InvalidOperationException if not)
        /// </summary>
        /// <param name="su"></param>
        /// <returns></returns>
        public byte[] ReadTotpSecret()
        {
            Guid id = (Guid)(_entity["Id"] 
                ?? throw new InvalidOperationException($"Unable to read TOTP secret from GaSalt because Id is not set in this {nameof(SecurityUser)} object"));
            if (string.IsNullOrEmpty(GaSalt)) return null; 
            //Use the presence of marker to determine if this user uses new or legacy format to store the GaSalt
            if (GaSalt.StartsWith(formatMarker20221010))
            {
                if (GaSecretEncryptionKey == null)
                    throw new InvalidOperationException($"TOTP encryption key is not initialised in {nameof(SecurityUser)} class");
                //New 20221010 format for storing the value and obfuscating it at rest
                string encryptedSecretBase64 = GaSalt.Substring(formatMarker20221010.Length);
                byte[] secret = DecryptTotpSecret(id, GaSecretEncryptionKey, encryptedSecretBase64);
                return secret;
            }
            else
            {
                try
                {
                    //Legacy format for the GaSalt, just a plaintext ASCII string whose bytes form
                    //the salt which combines with bytes from the id Guid to form the actual totp secret
                    byte[] secret = Encoding.ASCII.GetBytes(GaSalt + id.ToString());
                    return secret;
                }
                catch(Exception e)
                {
                    throw new Exception("Unable to read TOTP secret from GaSalt (legacy format)", e);
                }
            }
        }

        /// <summary>
        /// List all Security User ID, used by IamClient/CAM
        /// Exclude username in dwAppSettings IamIgnoreLogins
        /// </summary>
        /// <returns>List of SecurityUser</returns>
        public static async Task<List<SecurityUser>> GetListSecurityUserAndExcludeName(List<string> name)
        {
            var filter = Filter.And.NotIn(name, Constants.FieldName.dwSecurityUser.Name)
                .NotEqual(Guid.Empty, Constants.FieldName.dwSecurityUser.Id);
            return await SelectAsync(filter).ConfigureAwait(false);
        }

        public static async Task<SecurityUser> SelectByName(string name)
        {
            Filter filter = Filter.And.Equal(name, Constants.FieldName.dwSecurityUser.Name);
            List<SecurityUser> result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result[0] : null;
        }
    } //end of SecurityUser

    public class SecurityCredential : DbObject<SecurityCredential>
    {
        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

        [DbObjectModel]
        public Guid SecurityUserId
        {
            get => _entity.SecurityUserId;
            set => _entity.SecurityUserId = value;
        }

        [DbObjectModel]
        public string Login
        {
            get => _entity.Login;
            set => _entity.Login = value;
        }

        [DbObjectModel]
        public byte AuthenticationType
        {
            get => _entity.AuthenticationType;
            set => _entity.AuthenticationType = value;
        }

        [DbObjectModel]
        public string PasswordSalt
        {
            get => _entity.PasswordSalt;
            set => _entity.PasswordSalt = value;
        }

        [DbObjectModel]
        public string PasswordHash
        {
            get => _entity.PasswordHash;
            set => _entity.PasswordHash = value;
        }

        [DbObjectModel]
        public bool RequireTotp
        {
            get => _entity.RequireTotp;
            set => _entity.RequireTotp = value;
        }

        public static async Task<string> GetLoginByUserId(Guid userId)
        {
            var filter = Filter.And.Equal(userId, Constants.FieldName.dwSecurityCredential.SecurityUserId);
            var result = await SelectAsync(filter).ConfigureAwait(false);
            return result.Count > 0 ? result[0].Login : null;
        }

        /// <summary>
        /// Does not matter about AuthenticationType, because column Login itself has unique constraint.
        /// As long as exist, it should not be duplicated.
        /// </summary>
        /// <param name="login"></param>
        /// <param name="userId">Exception user</param>
        /// <returns></returns>
        public static async Task<bool> IsLoginCredentialExist(string login, Guid userId)
        {
            Filter filter = Filter.And.Equal(login, Constants.FieldName.dwSecurityCredential.Login);
            if(userId != Guid.Empty)
            {
                filter = filter.NotEqual(userId, Constants.FieldName.dwSecurityCredential.SecurityUserId);
            }

            List<SecurityCredential> result = await SelectAsync(filter);
            if (result == null) return false;

            return result.Any();
        }
    } //end of SecurityCredential


    // ReSharper disable once InconsistentNaming
    /// <summary>
    /// It finds any permission that AccessType is NOT 0 (Inherit).
    /// It is returning MAX of AccessType, any Not Allow will override other permission (Inherit/Allow).
    /// </summary>
    public class V_Security_CheckPermissionUser : DbObject<V_Security_CheckPermissionUser>
    {
        [DbObjectModel(IsKey = true)]
        public Guid UserId
        {
            get => _entity.UserId;
            set => _entity.UserId = value;
        }
        
        [DbObjectModel]
        public Guid PermissionId
        {
            get => _entity.PermissionId;
            set => _entity.PermissionId = value;
        }

        [DbObjectModel]
        public string PermissionGroupCode
        {
            get => _entity.PermissionGroupCode;
            set => _entity.PermissionGroupCode = value;
        }

        [DbObjectModel]
        public string PermissionGroupName
        {
            get => _entity.PermissionGroupName;
            set => _entity.PermissionGroupName = value;
        }

        [DbObjectModel]
        public string PermissionCode
        {
            get => _entity.PermissionCode;
            set => _entity.PermissionCode = value;
        }

        [DbObjectModel]
        public string PermissionName
        {
            get => _entity.PermissionName;
            set => _entity.PermissionName = value;
        }

        [DbObjectModel]
        public byte AccessType
        {
            get => _entity.AccessType;
            set => _entity.AccessType = value;
        }
    }

    public class SecurityUserToSecurityRole : DbObject<SecurityUserToSecurityRole>
    {
        [DbObjectModel(IsKey = true)]
        public Guid Id
        {
            get => _entity.Id;
            set => _entity.Id = value;
        }

        [DbObjectModel]
        public Guid SecurityUserId
        {
            get => _entity.SecurityUserId;
            set => _entity.SecurityUserId = value;
        }

        [DbObjectModel]
        public Guid SecurityRoleId
        {
            get => _entity.SecurityRoleId;
            set => _entity.SecurityRoleId = value;
        }
        
        [DbObjectModel(TableType = typeof(SecurityRole), ParentPropertyName = "SecurityRoleId", ColumnName = "Code")]
        public string SecurityRoleCode
        {
            get => _entity.SecurityRoleCode;
            set => _entity.SecurityRoleCode = value;
        }

        public static Task<List<SecurityUserToSecurityRole>> SelectByUser(Guid userId)
        {
            var filter = Filter.And.Equal(userId, "SecurityUserId");
            return SelectAsync(filter);
        }

        public static Task<List<SecurityUserToSecurityRole>> SelectByRole(Guid roleId)
        {
            var filter = Filter.And.Equal(roleId, "SecurityRoleId");
            return SelectAsync(filter);
        }

        public static async Task<bool> HasUserRole(Guid userId, string roleCode)
        {
            var filter = Filter.And.Equal(roleCode, "SecurityRoleCode").Equal(userId, "SecurityUserId");
            return (await SelectAsync(filter)).Count > 0;
        }
    }

    public class V_Security_UserRole: DbObject<V_Security_UserRole>
    {
        [DbObjectModel]
        public Guid UserId
        {
            get => _entity.UserId;
            set => _entity.UserId = value;
        }

        [DbObjectModel]
        public Guid RoleId
        {
            get => _entity.RoleId;
            set => _entity.RoleId = value;
        }

        [DbObjectModel(TableType = typeof(SecurityUser), ParentPropertyName = "UserId", ColumnName = "Name")]
        public string UserName
        {
            get => _entity.UserName;
            set => _entity.UserName = value;
        }

        [DbObjectModel(TableType = typeof(SecurityRole), ParentPropertyName = "RoleId", ColumnName = "Code")]
        public string RoleCode
        {
            get => _entity.RoleCode;
            set => _entity.RoleCode = value;
        }
    }
}