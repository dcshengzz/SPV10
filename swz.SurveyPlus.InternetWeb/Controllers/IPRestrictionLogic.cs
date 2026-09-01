using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using IP2Country;
using Newtonsoft.Json;
using NetTools;
using swz.SurveyPlus.Application;
using System.Linq;
using System.Threading.Tasks;
using System.Net;
using Microsoft.Extensions.Caching.Memory;
using swz.Clover.Core;

namespace swz.SurveyPlus.InternetWeb.Controllers
{
    public static class IPRestrictionLogic
    {
        public const string resolverCacheKey = "IP2CountryResolverCache";

        //How to setup the IP2CountryResolver?
        //  Set "Ip":  "True"  in the Restrictions block of appsettings.json to add the resolver
        //  and then can get it from memory cache. 
        //  eg: var iP2CountryResolver = _cache?.Get<IP2CountryResolver>("IP2CountryResolverCache");
        //  See DataController, UserInterfaceController, RespDashboardController for examples

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(IPRestrictionLogic));

        public static async Task<bool> IsUserBlockedAsync(
            HttpContext httpContext, 
            IMemoryCache cache, 
            IPRestriction ipRules)
        {
            if (httpContext == null) throw new ArgumentNullException(nameof(httpContext));
            if (cache == null) throw new ArgumentNullException(nameof(cache));
            if (ipRules == null) throw new ArgumentNullException(nameof(ipRules));

            if (!ipRules.RestrictIp)
                return false;

            IP2CountryResolver iP2CountryResolver = cache?.Get<IP2CountryResolver>(resolverCacheKey);
            if (iP2CountryResolver != null)
            {
                IPAddress ipAddress = httpContext.Connection.RemoteIpAddress;
                bool ipAllowed = IpAllowed(ipAddress, iP2CountryResolver, ipRules);
                return (ipAllowed == false);
            }
            else
            {
                //If "Ip" is not true in appsettings (enables the IP Restriction feature) then the resolver
                //isn't available so we don't enforce the restriction
                return false;
            }
        }

        private static bool IpAllowed(
            IPAddress ipAddress,
            IP2CountryResolver iP2CountryResolver, 
            IPRestriction ipRules)
        {
            //nb: not checking ipAddress
            if (iP2CountryResolver == null) throw new ArgumentNullException(nameof(iP2CountryResolver));
            if (ipRules == null) throw new ArgumentNullException(nameof(ipRules));

            //Code here was factored out of UserInterfaceController to centralise 
            //for sharing with code in RespDashboardController et al that needs to perform this check too
            //(TODO - There is still one or two places with similar code that doesnt share and needs updating, eg in DataController)
            //IP restriction logic
            if (ipRules.RestrictIp)
            {
                
                try
                {
                    var country = iP2CountryResolver.Resolve(ipAddress)?.Country;
                    var ipAllowed = true;
                    if (ipRules.RestrictIpInclusive)
                    {

                        if (ipRules.IpCountry != null) //if db has country set, but ip is local/reserved ip, add it; or country matched, add it;
                        {
                            List<string> ipCountries = JsonConvert.DeserializeObject<List<string>>(ipRules.IpCountry);
                            if (country != null && !ipCountries.Contains(country, StringComparer.OrdinalIgnoreCase))
                            {
                                ipAllowed = false;
                            }

                        }
                        else if (ipRules.IpRange != null)
                        {
                            List<string> ipRanges = JsonConvert.DeserializeObject<List<string>>(ipRules.IpRange);
                            foreach (string ipRange in ipRanges)
                            {
                                try
                                {
                                    IPAddressRange rangeA = IPAddressRange.Parse(ipRange);
                                    if (rangeA.Contains(ipAddress))
                                    {
                                        ipAllowed = true;
                                        break;
                                    }

                                    ipAllowed = false;

                                }
                                catch (Exception e)
                                {
                                    logger.LogWarning(e, nameof(IpAllowed) + " - [A] caught exception checking ipRange={0}", ipRange);
                                }

                            }

                        }

                    }
                    else //Exclusive IP Ranges
                    {
                        if (ipRules.IpCountry != null) //if db has country set, but ip is local/reserved ip, add it; or country matched, add it;
                        {
                            List<string> ipCountries = JsonConvert.DeserializeObject<List<string>>(ipRules.IpCountry);
                            if (country != null && ipCountries.Contains(country, StringComparer.OrdinalIgnoreCase))
                            {
                                ipAllowed = false;
                            }

                        }
                        else if (ipRules.IpRange != null)
                        {
                            List<string> ipRanges = JsonConvert.DeserializeObject<List<string>>(ipRules.IpRange);
                            foreach (var ipRange in ipRanges)
                            {
                                try
                                {
                                    IPAddressRange rangeA = IPAddressRange.Parse(ipRange);
                                    if (rangeA.Contains(ipAddress))
                                    {
                                        ipAllowed = false;
                                        break;
                                    }

                                }
                                catch (Exception e)
                                {
                                    logger.LogWarning(e, nameof(IpAllowed) + " - [B] caught exception checking ipRange={0}", ipRange);
                                }
                            }

                        }

                    } //end if exclusive
                    return ipAllowed;
                }
                catch (Exception e)
                {
                    logger.LogWarning(e, nameof(IpAllowed) + " - caught unexpected exception");

                    //The logic here is taken from UserInterfaceController which would just continue on 
                    //after logging the exception here, so returning true to preserve this logic
                    return true;
                }
            }
            else //RestrictIp == false
            {
                return true;
            }
        }


    }
}
