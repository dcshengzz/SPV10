using System;
using System.Collections.Generic;
using System.Management;
using System.Security.Cryptography;
using System.Text;

namespace swz.Clover.Core.Utils
{
#pragma warning disable CA1416 // Validate platform compatibility (Currently we only release SurveyPlus for Windows)
    public static class HardwareInfo
    {

        private static string _fingerPrint = string.Empty;

        /// <summary>
        /// Hashed hardware signature in string form
        /// </summary>
        /// <returns></returns>
        public static string Value()
        {
            if (string.IsNullOrEmpty(_fingerPrint))
            {
                _fingerPrint = GetHash(HardwareSignature());
            }
            return _fingerPrint;
        }

        /// <summary>
        /// Usng System.Management.ManagementClass, extract hardware information. The 'safely' indicates that exeptions thrown reading individual
        /// properties will be ignored (such properties will be read as null). 
        /// The path must be valid. If the path is not valid an exception will be thrown.
        /// </summary>
        /// <param name="path">A path for a ManagementClass whose instances will be enumerated</param>
        /// <param name="wmiMustBeTrue">specifies a property whose value must be True for the ManagementObject to be considered</param>
        /// <param name="wmiProperties">(optional) specific properties to retrieve, if not specified will try to retrieve all properties</param>
        /// <returns>data extracted from the ManagementClass in the order it was retrieved</returns>
        public static List<List<Tuple<string, object>>> EnumerateSafely(string path, string wmiMustBeTrue, params string[] wmiProperties)
        {
            try
            {
                List<List<Tuple<string, object>>> items = new List<List<Tuple<string, object>>>();
                ManagementClass mc = new ManagementClass(path);
                ManagementObjectCollection moc = mc.GetInstances();
                foreach (ManagementBaseObject mbo in moc)
                {
                    if (mbo is ManagementObject)
                    {
                        ManagementObject mo = (ManagementObject)mbo;
                        if ((wmiMustBeTrue == null) || FlagIsSet(mo, wmiMustBeTrue)) //TODO - still check as string ?
                        {
                            List<Tuple<string, object>> item = new List<Tuple<string, object>>();
                            List<string> propertyNames = (wmiProperties.Length == 0)
                                ? PropertyNames(mo)
                                : new List<string>(wmiProperties);
                            for (int i = 0; i < propertyNames.Count; i++)
                            {
                                string property = propertyNames[i];
                                object value = ReadSafely(mo, property);
                                item.Add(new Tuple<string, object>(property, value)); //value will be null if doesn't exist or couldn't be read
                            }
                            items.Add(item);
                        }
                    }
                }
                return items;
            }
            catch (Exception e)
            {
                //Would get this if the path is invalid or for other unexpected exceptions.
                //We will wrap the exception to make sure the bad path is included in our stacktrace
                //Caller can refer to InnerException for details
                throw new Exception($"Failed to enumerate ManagementClass for {path}", e);
            }
        }

        /// <summary>
        /// Formats the desired hardware information in a human readable format.
        /// </summary>
        /// <param name="items"Data structure as retrieved using EnumerateSafely></param>
        /// <param name="propertyDelimiter"delimiter to separate properties in the output string (default is ",")></param>
        /// <param name="itemDelimiter">delimiter to separate hardware instance in the output string (default is "||") </param>
        /// <param name="prefix">optional prefix for each property, if specified the item index would also be included (default is null)</param>
        /// <returns>hardware information in string form</returns>
        public static string FormatHardwareInfo(
            List<List<Tuple<string, object>>> items,
            string propertyDelimiter = ",",
            string itemDelimiter = "||",
            string prefix = null)
        {
            StringBuilder b = new StringBuilder();
            int itemCount = items.Count;
            for (int itemIndex = 0; itemIndex < itemCount; itemIndex++)
            {
                List<Tuple<string, object>> item = items[itemIndex];
                int propertyCount = item.Count;
                for (int propIndex = 0; propIndex < propertyCount; propIndex++)
                {
                    Tuple<string, object> property = item[propIndex];
                    if (prefix != null)
                    {
                        b.Append(prefix);
                        b.Append('[');
                        b.Append(itemIndex);
                        b.Append("].");
                    }
                    b.Append(property.Item1);
                    b.Append('=');
                    b.Append(FormatAsString(property.Item2));
                    if (propIndex + 1 < propertyCount) b.Append(propertyDelimiter);
                }
                if (itemIndex + 1 < itemCount) b.Append(itemDelimiter);
            }
            return b.ToString();
        }

        /// <summary>
        /// Returns a string that includes some information about the hardware, intended to be used to identify the local machine.
        /// For licensing purposes you would use Value() to get a hashed identifier based on this. 
        /// </summary>
        /// <returns></returns>
        public static string HardwareSignature()
        {
            //20220813 - As many of the things we have tried to key on are variable the hardware signature isnt very strong,
            //however in practice we will also be licensing on the domain. 
            //As of 2022-08-13 we are also removing the VideoId from the signature as this too has proven quite unstable,
            //both in terms of the driver versions, and also in which hardware is actually shown as present.
            //If you need visibility on what hardware is being enumerated on your development machine, dwdb has a hardware command.
            //As of 2022-08-16 we sort the enumerations ourselves. However in practice only CPU is likely to have more than one
            //and we'd expect biod and motherboard to be single.
            string cpuId = CpuId();
            string biosId = BiosId();
            string baseId = BaseId();
            string hardwareSignature = $"CPU >> {cpuId}\nBIOS >> {biosId}\nBASE >> {baseId}";
            return hardwareSignature;
        }

        private static string GetHash(string s)
        {
            using(SHA256 sec = SHA256.Create())
            {
                ASCIIEncoding enc = new ASCIIEncoding();
                byte[] bt = enc.GetBytes(s);
                return GetHexString(sec.ComputeHash(bt));
            }
        }

        private static string GetHexString(byte[] bt)
        {
            string s = string.Empty;
            for (var i = 0; i < bt.Length; i++)
            {
                var b = bt[i];
                var n = (int)b;
                var n1 = n & 15;
                var n2 = (n >> 4) & 15;
                if (n2 > 9)
                    s += ((char)(n2 - 10 + 'A')).ToString();
                else
                    s += n2.ToString();
                if (n1 > 9)
                    s += ((char)(n1 - 10 + 'A')).ToString();
                else
                    s += n1.ToString();
                if ((i + 1) != bt.Length && (i + 1) % 2 == 0) s += "-";
            }
            return s;
        }

        /// <summary>
        /// Convenience method that will check if a flag property is set in the specified ManagementObject
        /// </summary>
        /// <param name="mo">The ManagementObject to look in</param>
        /// <param name="flagProperty">name of property in the ManagementObject</param>
        /// <returns>true if the string representation of the value in flagProperty is "True" (case-sensitive)</returns>
        private static bool FlagIsSet(ManagementObject mo, string flagProperty)
        {
            //(Part of a behaviour-preserving refactoring in response to SVP-08 in the MPA SCR Report of 2022-04-29)
            //The code this was refactored from used: if (mo[wmiMustBeTrue].ToString() == "True")
            //so here I continue to convert to a String and check against that and I preserve the
            //old behaviour of doing so in an exact and case-sensitive manner as the old code did
            //not indicate why it was case-sensitive. 
            return Boolean.TrueString.Equals(ReadSafelyAsString(mo, flagProperty));
        }

        /// <summary>
        /// Convenience method that attempts to read a property value from a ManagementObject, 
        /// and return it as a string (uses ToString). 
        /// If this fails for any reason (i.e. missing, unreadable, cannot use ToString, or any other) then it will return null.
        /// </summary>
        /// <param name="mo"></param>
        /// <param name="wmiProperty"></param>
        /// <returns>value of the wmiProperty in this ManagementObject or null if missing or unreadable/convertable</returns>
        private static string ReadSafelyAsString(ManagementObject mo, string wmiProperty)
        {
            //(Part of a behaviour-preserving refactoring in response to SVP-08 in the MPA SCR Report of 2022-04-29)
            //An observation of 'Detection of Error Condition Without Action'
            //In fact the old code did take action - it would continue the search for a readable property and the catch was clearly labelled "ignored"
            //so the finding was a false positive from the tool, however I have taken the liberty of refactoring the old code to make the behaviour
            //more clear to readers.
            object value = ReadSafely(mo, wmiProperty); //20220814 - Extracted the reading code to its own method for use with new Enumerate method
            return value?.ToString();
        }

        /// <summary>
        /// Try to read the specified property from the ManagementObject, but if it cannot be read (due to a security or other exception)
        /// or it has no value then this method will return null rather than throw an exception (hence the 'Safely' in its name). 
        /// Callers that need to see the underlying exception should read the management object themselves.
        /// </summary>
        /// <param name="mo">ManagementObject to read a property value from</param>
        /// <param name="wmiProperty">name of the property to read</param>
        /// <returns>the specified property value or null if property doesn't exist or cannot be read for any reason</returns>
        private static object ReadSafely(ManagementObject mo, string wmiProperty)
        {
            if (mo == null) throw new ArgumentNullException(nameof(mo));
            if (string.IsNullOrEmpty(wmiProperty)) throw new ArgumentException(nameof(wmiProperty));
            try
            {
                object value = mo[wmiProperty];
                return value;
            }
            catch
            {
                //If the property can't be read (likely we lack sufficient access) then return null 
                return null;
            }
        }

        /// <summary>
        /// Simple implementation of a comparator for sorting the hardware enumeration. Uses string value to compare, and can handle nulls.
        /// </summary>
        public class ChainedPropertyStringComparator : Comparer<List<Tuple<string, object>>>
        {
            private readonly string property;
            private readonly ChainedPropertyStringComparator next;

            public ChainedPropertyStringComparator(string property, ChainedPropertyStringComparator next)
            {
                if (string.IsNullOrEmpty(property)) throw new ArgumentException(nameof(property), "Required");
                this.property = property;
                this.next = next;
            }

            public override int Compare(List<Tuple<string, object>> x, List<Tuple<string, object>> y)
            {
                object valueX = GetPropertyAsString(x);
                object valueY = GetPropertyAsString(y);

                int c = CompareCurrent(valueX, valueY);
                if (c == 0) c = (next==null) ? 0 : next.Compare(x, y); 
                return c;
            }

            private int CompareCurrent(object valueX, object valueY)
            {
                if (valueX == null && valueY == null) return 0;
                if (valueX != null && valueY == null) return 1;
                if (valueX == null && valueY != null) return -1;
                return valueX.ToString().CompareTo(valueY.ToString());
            }

            private object GetPropertyAsString(List<Tuple<string, object>> item)
            {
                foreach (Tuple<string, object> p in item)
                {
                    if (property.Equals(p.Item1, StringComparison.InvariantCulture)) return p.Item2;
                }
                return null;
            }
        }

        private static string CpuId()
        {
            List<List<Tuple<string, object>>> info 
                = EnumerateSafely("Win32_Processor", null, "ProcessorId", "Name", "Manufacturer", "MaxClockSpeed");
            if (info.Count > 1)
            {
                //I have been unable to confirm that the order returned from ManagementClass.GetInstances is always the same
                //(seems to be in practice, for now) so we will sort on all these (as strings) to ensure consistency if there are multiple processors. 
                ChainedPropertyStringComparator comparator
                    = new ChainedPropertyStringComparator("ProcessorId",
                        new ChainedPropertyStringComparator("Name",
                            new ChainedPropertyStringComparator("Manufacturer",
                                new ChainedPropertyStringComparator("MaxClockSpeed", null))));
                info.Sort(comparator);
            }
            return FormatHardwareInfo(info);
        }

        //BIOS Identifier
        private static string BiosId()
        {
            List<List<Tuple<string, object>>> info 
                = EnumerateSafely("Win32_Bios", null, "Manufacturer", "SMBIOSVersion", "IdentificationCode", "SerialNumber", "ReleaseDate", "Version");
            if (info.Count > 1)
            {  //I don't expect this
                ChainedPropertyStringComparator comparator
                    = new ChainedPropertyStringComparator("Manufacturer",
                        new ChainedPropertyStringComparator("SMBIOSVersion",
                            new ChainedPropertyStringComparator("IdentificationCode",
                                new ChainedPropertyStringComparator("SerialNumber",
                                    new ChainedPropertyStringComparator("ReleaseDate",
                                        new ChainedPropertyStringComparator("Version", null))))));
                info.Sort(comparator);
            }
            return FormatHardwareInfo(info);
        }

        //Motherboard ID
        private static string BaseId()
        {
            List<List<Tuple<string, object>>> info 
                = EnumerateSafely("Win32_BaseBoard", null, "Model", "Manufacturer", "Name", "SerialNumber");
            if (info.Count > 1)
            {   //Don't expect more than one though
                ChainedPropertyStringComparator comparator
                    = new ChainedPropertyStringComparator("Model",
                        new ChainedPropertyStringComparator("Manufacturer",
                            new ChainedPropertyStringComparator("Name",
                                new ChainedPropertyStringComparator("SerialNumber", null))));
            }
            return FormatHardwareInfo(info);
        }

        private static List<string> PropertyNames(ManagementObject mo)
        {
            List<string> names = new List<string>();
            foreach (var property in mo.Properties)
            {
                names.Add(property.Name);
            }
            return names;
        }

        private static string FormatAsString(object value)
        {
            if (value == null)
            {
                return "";
            }
            if (value is String[] values)
            {
                StringBuilder b = new StringBuilder();
                b.Append("[");
                for (int i = 0; i < values.Length; i++)
                {
                    b.Append(values[i]);
                    if (i + 1 < values.Length) b.Append(",");
                }
                b.Append("]");
                return b.ToString();
            }
            else if (value.GetType().IsArray)
            {
                if (value is System.Collections.IEnumerable e)
                {
                    List<object> list = new List<object>();
                    foreach (object o in e) list.Add(o);
                    StringBuilder b = new StringBuilder();
                    b.Append("[");
                    for (int i = 0; i < list.Count; i++)
                    {
                        b.Append(FormatAsString(list[i]));
                        if (i + 1 < list.Count) b.Append(",");
                    }
                    b.Append("]");
                    return b.ToString();
                }
                else
                {
                    return "";
                }
            }
            else
            {
                return value.ToString();
            }
        }

    }
#pragma warning restore CA1416 // Validate platform compatibility
}
