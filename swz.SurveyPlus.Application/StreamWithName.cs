using System;
using System.IO;

namespace swz.SurveyPlus.Application
{
    /// <summary>
    /// Simple object to facilitate passing a reference to a stream together with some name and contentType information.
    /// (n.b. This object says nothing about disposal of the referenced stream, its just for passing that reference together with name
    /// and users should take the usual care to determine and manage the responsibility for stream disposal)
    /// </summary>
    public class StreamWithName
    {
        // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add setters.
        //      but also note that the referenced stream's properties can and will change
        // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// Get the stream reference. 
        /// Note that the immutability contraints of StreamWithName wrapper object DO NOT apply to the referenced stream itself
        /// </summary>
        public Stream Stream { get; private set; }

        public string ContentType { get; private set; }

        public string Name { get; private set; }

        public StreamWithName(Stream stream, string contentType, string name)
        {
            if (stream == null) throw new ArgumentNullException(nameof(stream));
            if (string.IsNullOrWhiteSpace(contentType)) throw new ArgumentException(nameof(contentType));
            if (string.IsNullOrWhiteSpace(name)) throw new ArgumentException(nameof(name));
            Stream = stream;
            ContentType = contentType;
            Name = name;
        }
    }
}
