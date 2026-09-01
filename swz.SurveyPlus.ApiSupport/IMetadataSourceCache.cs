namespace swz.SurveyPlus.ApiSupport
{
    /// <summary>
    /// Interface for a cache of dwMetadata source. 
    /// Users of this cache are responsible for providing the data however.
    /// Implementations may be called from multiple threads but callers should not rely
    /// on implementations providing any kind of transactionality.
    /// </summary>
    public interface IMetadataSourceCache
    {
        /// <summary>
        /// Clear existing entries in the memory cache at the time this is called.
        /// This is primarily intended for troublehsooting and development purposes.
        /// </summary>
        void ClearCache();

        /// <summary>
        /// Try to write the requested metadata source to the output parameter 'source' and return true if
        /// this was successful, or false if not.
        /// n.b if SetNullSource was used to explicitly record a null value for this file then the output source will be null
        /// </summary>        
        bool TryGetSource(string file, string folder, out string source);

        /// <summary>
        /// Set the metadata source into the cache overwriting any previous value for it. 
        /// (This cannot be used to record a null value, for that you must explicitly 
        /// use SetNullSource so the intent is clear)
        /// </summary>
        void SetSource(string file, string folder, string source);

        /// <summary>
        /// For cases where we explicitly want to record the source as null (for example to avoid repeated
        /// attempts to lookup css metadata). (This has its own specific method so that the intent is quite
        /// clear in calling code)
        /// </summary>
        void SetNullSource(string file, string folder);
    }

    /// <summary>
    /// Like the goggles, it does nothing
    /// </summary>
    public class NullMetadataSourceCache : IMetadataSourceCache
    {
        /// <summary>
        /// No-Op implementation
        /// </summary>
        public void ClearCache() { }

        /// <summary>
        /// No-Op implementation, all arguments are ignored
        /// </summary>
        public void SetSource(string file, string folder, string source) { }

        /// <summary>
        /// No-Op implementation, all arguments are ignored
        /// </summary>
        public void SetNullSource(string file, string folder) { }

        /// <summary>
        /// Always return falses and outputs null for source, other arguments are ignored
        /// </summary>
        public bool TryGetSource(string file, string folder, out string source) { source = null; return false; }
    }
}
