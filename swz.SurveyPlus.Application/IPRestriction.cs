using System;

namespace swz.SurveyPlus.Application
{
    public class IPRestriction
    {
        /// <summary>
        /// Construct an instance of IPRestriction from a QNN_DPLY or vSP_ListSampleInfo entity or swagger object, or other object having
        /// the properties: RestrictIp, RestrictIpInclusive, IpCountry, IpRange
        /// </summary>
        /// <param name="source"></param>
        /// <returns></returns>
        public static IPRestriction FromDynamic(dynamic source)
        {
            try
            {
                //n.b. the explicit conversions are necessary for some flavours of dynamic
                bool restrictIp = Convert.ToBoolean(source.RestrictIp);
                bool restrictIpInclusive = Convert.ToBoolean(source.RestrictIpInclusive);
                string ipCountry = source.IpCountry;
                string ipRange = source.IpRange;
                return new IPRestriction(restrictIp, restrictIpInclusive, ipCountry, ipRange);
            }
            catch(Exception e)
            {
                throw new ArgumentException("Invalid source", e);
            }            
        }

        // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add setters. //
        // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// Flag to indicate if IP restrictions are active
        /// </summary>
        public bool RestrictIp { get; private set; }

        /// <summary>
        /// Indicates if the IP Range is inclusive (as opposed to exclusive)
        /// </summary>
        public bool RestrictIpInclusive { get; private set; }

        /// <summary>
        /// A string of raw json containing country restriction information
        /// </summary>
        public string IpCountry { get; private set; }

        /// <summary>
        /// A string of raw json containing IP range restriction information
        /// </summary>
        public string IpRange { get; private set; }

        public IPRestriction(bool restrictIp, bool restrictIpInclusive, string ipCountry, string ipRange)
        {
            this.RestrictIp = restrictIp;
            this.RestrictIpInclusive = restrictIpInclusive;
            this.IpCountry = ipCountry;
            this.IpRange = ipRange;
        }
    }
}
