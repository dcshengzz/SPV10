using System;

//Some SurveyPlus exception types
//TODO - consider breaking these out into their own files to make it easier to locate them.
//Putting together here was an attempt to reduce clutter, but maybe it isnt helping?
namespace swz.SurveyPlus.Application
{
    /// <summary>
    /// A generic exception that can be used for when something is not found (useful if you want to catch this). 
    /// A static factory method for use with ModelName is provided for convenience.
    /// </summary>
    public class NotFoundException : Exception
    {
        /// <summary>
        /// Convenience factory method that assembles a message including the id and model/table/etc name.
        /// The Id is recorded.
        /// </summary>
        /// <param name="modelName"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static NotFoundException ForModelName(string modelName, Guid id)
        {
            return new NotFoundException($"Failed to find {modelName} with Id={id}", id);
        }

        /// <summary>
        /// In some cases this will contain an identifier that was being used to locate the thing that was not found.
        /// Nature of this identifier depends on the context of the error. 
        /// </summary>
        public object Id { get; private set; } 

        public NotFoundException() : base() { }

        /// <summary>
        /// Constructor that records no Id or InnerException
        /// </summary>
        public NotFoundException(string message) : base(message) { }

        /// <summary>
        /// Constructor that records Id, note that it is not included in the message by default. Caller would
        /// need to put it in the message.
        /// </summary>
        public NotFoundException(string message, object id) : base(message) { }


        /// <summary>
        /// Constructor that records Id and wraps an InnerException.
        /// Note that Id is not included in the message by default. Caller would need to put it in the message.
        /// </summary>
        public NotFoundException(string message, Exception innerException) : base(message, innerException) { }
    }

    /// <summary>
    /// The maximum number of responses have been reached for a dlsi
    /// </summary>
    public class MaxResponsesException : Exception
    {
        public const string MaxResponseMessage = "Survey has reached maximum responses";

        public int? MaxResponse { get; }
        public int CurrentResponse { get; }

        public MaxResponsesException(int? maxResponse, int currentResponses) : base(MaxResponseMessage) 
        {
            this.MaxResponse = maxResponse;
            this.CurrentResponse = currentResponses;
        }
    }

    /// <summary>
    /// Exception that can be throw when an access check fails
    /// </summary>
    public class PermissionException : Exception
    {
        public PermissionException() : base(Constants.Message.YouDontHaveThePermission) { }

        public PermissionException(string message) : base(message) { }

        public PermissionException(string message, Exception innerException) : base(message, innerException) { }
    }

    /// <summary>
    /// Indicates the session is no longer to be considered valid. 
    /// (Where practical, controllers catching this should invalidate their respondent aspnet session and redirect to login or indicate
    /// to clientside JS that such a redirect is required).
    /// </summary>
    public class SessionInvalidException : PermissionException
    {
        private const string msg = "Session is invalid or was invalidated";

        public SessionInvalidException() : base(msg) { }

        public SessionInvalidException(Exception innerException) : base(msg, innerException) { }

        public SessionInvalidException(string message) : base(message) { }

        public SessionInvalidException(string message, Exception innerException) : base(message, innerException) { }
    }

    /// <summary>
    /// Thrown when the u@app API finds that a respondent's JWT accessToken is not valid
    /// (e.g. when it was invalidated by another login session when using single-session handling etc)
    /// </summary>
    public class InvalidRespondentTokenException : SessionInvalidException
    {
        public InvalidRespondentTokenException() : base() { }

        public InvalidRespondentTokenException(string msg) : base(msg) { }
    }

    /// <summary>
    /// Exception to indicate that a status or something specifying a status is invalid
    /// </summary>
    public class InvalidStatusException : Exception
    {
        public InvalidStatusException() : base() { }

        public InvalidStatusException(string message) : base(message) { }
    }

    /// <summary>
    /// Generic exception type for use when you want to wrap an error with more information or report some error condition.
    /// Its called 'internal' because it should be used internally in 'things', for example: if some method deep inside the FooImporter
    /// wants to wrap some low level IO exception its caught to add some usefull troubleshooting info like the FooId and then throw up 
    /// for something else in the FooImporter to catch or handle. For the exceptions thrown to callers outside the thing you should 
    /// be using a more appropriate exception type like FooImportFailureException  which you would create to represent such errors 
    /// (and it might take this as its own innerException). 
    /// But internally, inside the thing, creating a lot of such exceptions for generic error catching+wrapping that will be wrapped again or 
    /// handled internally one level up in one place only can add unnecessary verbosity. 
    /// My own instinct would have just been to use Exception itself for such cases but the MS docs pretty clearly say don't do that. 
    /// See: https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/using-standard-exception-types
    /// So ideally, when you use this inside your thing, things outside you thing wouldn't see this exception in the raw (but only as an innerException
    /// to a more specific exception type).
    /// </summary>
    public class InternalException : Exception
    {
        public InternalException(string message) : base(message) { }

        public InternalException(string message, Exception innerException) : base(message, innerException) { }
    }

    /// <summary>
    /// Thrown by things that check uploaded files to see if they are valid for a certain use
    /// </summary>
    public class InvalidUploadedFileException : Exception
    {
        public string Token { get; private set; }

        public InvalidUploadedFileException(string message, string token) : base(message) { this.Token = token; }

        public InvalidUploadedFileException(string message, string token, Exception innerException) : base(message, innerException) { this.Token = token; }
    }

    /// <summary>
    /// Exception that can be thrown when execution reaches a line that it should never reach.
    /// When this is thrown it usually indicates that changes to code have rendered that assumption invalid.
    /// (This can be particularly useful after a while(true) where the loop is always meant to be exited via a return) 
    /// </summary>
    public class YouCantGetHereException : InternalException
    {
        public YouCantGetHereException() : base("Unexpected execution path") { }

        public YouCantGetHereException(string message) : base(message) { }
    }
}
