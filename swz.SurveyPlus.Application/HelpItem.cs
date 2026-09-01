using System;
using System.Collections.Generic;

namespace swz.SurveyPlus.Application
{
    /// <summary>
    /// Represents an item of help information.
    /// Instances of this class are immutable.
    /// </summary>
    public class HelpItem
    {
        // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add setters. //
        // // // // // // // // // // // // // // // // // // // // // // // //

        public Guid Id { get; private set; }
        public string Topic { get; private set; }
        public string Heading { get; private set; }
        public string Content { get; private set; }

        /// <summary>
        /// Constructor.
        /// Guid may not be null
        /// </summary>
        /// <param name="id"></param>
        /// <param name="topic"></param>
        /// <param name="heading"></param>
        /// <param name="content"></param>
        public HelpItem(
            Guid id,
            string topic,
            string heading,
            string content)
        {
            Id = id;
            Topic = topic;
            Heading = heading;
            Content = content;
        }

        /// <summary>
        /// Returns a new dictionary with Id, Topic, Heading, Content entries
        /// </summary>
        /// <returns>dictionary representing the item</returns>
        public Dictionary<string, object> ToDictionary()
        {
            Dictionary<String, Object> dictionary = new Dictionary<string, object>();
            dictionary.Add("Id", Id);
            dictionary.Add("Topic", Topic);
            dictionary.Add("Heading", Heading);
            dictionary.Add("Content", Content);
            return dictionary;
        }

    } //end of HelpItem
}
