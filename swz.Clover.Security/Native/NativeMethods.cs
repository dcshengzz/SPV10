using System;
using System.Runtime.InteropServices;

namespace swz.Clover.Security.Native
{
    internal static class NativeMethods
    {
        private const int LOGON32_LOGON_INTERACTIVE = 2;
        private const int LOGON32_LOGON_NETWORK = 3;
        private const int LOGON32_LOGON_BATCH = 4;
        private const int LOGON32_LOGON_SERVICE = 5;
        private const int LOGON32_LOGON_UNLOCK = 7;
        private const int LOGON32_LOGON_NETWORK_CLEARTEXT = 8;
        private const int LOGON32_LOGON_NEW_CREDENTIALS = 9;
        private const int LOGON32_PROVIDER_DEFAULT = 0;
        private const int LOGON32_PROVIDER_WINNT35 = 1;
        private const int LOGON32_PROVIDER_WINNT40 = 2;
        private const int LOGON32_PROVIDER_WINNT50 = 3;


        [DllImport("advapi32.dll")]
        public static extern int LogonUserA(String lpszUserName,
                                            String lpszDomain,
                                            String lpszPassword,
                                            int dwLogonType,
                                            int dwLogonProvider,
                                            ref IntPtr phToken);

        [DllImport("advapi32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        public static extern int DuplicateToken(IntPtr hToken,
                                                int impersonationLevel,
                                                ref IntPtr hNewToken);

        [DllImport("advapi32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        public static extern bool RevertToSelf();

        [DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
        public static extern bool CloseHandle(IntPtr handle);

        [DllImport("advapi32.dll", SetLastError = true)]
        public static extern int LogonUser(
            string lpszUsername,
            string lpszDomain,
            string lpszPassword,
            int dwLogonType,
            int dwLogonProvider,
            out IntPtr phToken
            );

        [DllImport("advapi32.dll", SetLastError = true)]
        public static extern int ImpersonateLoggedOnUser(
            IntPtr hToken
            );

        public static IntPtr LogonUser(string username, string password, string domain)
        {
            IntPtr token;
            LogonUser(username, domain, password, LOGON32_LOGON_NETWORK,
                      LOGON32_PROVIDER_DEFAULT, out token);
            return token;
        }
    }
}