using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;

namespace swz.SurveyPlus.IntranetApplication.Utilities
{
    public static class IndexingUtils
    {
        public class ElementNotUniqueException : ArgumentException
        {
            public int Index { get; private set; }
            public int PreviousIndex { get; private set; }
            public string ElementValue { get; private set; }

            public ElementNotUniqueException(string element, int index, int previousIndex)
                : base($"element at index {index} already found at index {previousIndex}")
            {
                this.ElementValue = element;
                this.Index = index;
                this.PreviousIndex = previousIndex;
            }
        }

        // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// Build a lookup table mapping the elements in the array to their index in the array.
        /// Useful for things like building a column name to index lookup table etc.
        /// Will throw an ArgumentException if any element is not unique or if any are null.
        /// </summary>
        /// <param name="elements">an array of non-null unique strings to be indexed</param>
        /// <param name="caseInsensitive">if true the lookup table will be case-insensitive (default is false)</param>
        /// <returns>lookup table of element value to its index in the array</returns>
        public static Dictionary<string, int> IndexUniqueElements(string[] elements, bool caseInsensitive = false)
        {
            if (elements == null) throw new ArgumentNullException("required", nameof(elements));
            Dictionary<string, int> index
                = new Dictionary<string, int>(caseInsensitive ? Constants.Comparers.ObjectNameCaseInsensitive : Constants.Comparers.ObjectNameCaseSensitive);
            for (int i = 0; i < elements.Length; i++)
            {
                string element = elements[i];

                //note that the following throws an ArgumentException rather than ArgumentNullException because the
                //particular element in the argument is null but the argument itself is not
                if (element == null)
                    throw new ArgumentException($"element at index {i} is null", nameof(elements));

                //fail if any element is not actually unique
                if (index.ContainsKey(element))
                    throw new ElementNotUniqueException(element, i, index[element]);
                index.Add(element, i);
            }
            return index;
        }
    }
}
