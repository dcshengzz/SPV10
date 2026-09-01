using System;

namespace swz.SurveyPlus.Application
{
    /// <summary>
    /// A piece of content for login screen or dashboard.
    /// These are stored in QNN_RESP_ADMIN and used to display messages to respondents.
    /// (QNN_RESP_ADMIN contains additional data such as the time range the message is valid for etc
    /// whereas this class is inteneded as a DTO with the internet side)
    /// Instances of this class are immutable.
    /// </summary>
    public class RespondentContentItem
    {
        // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add setters. //
        // // // // // // // // // // // // // // // // // // // // // // // //

        public Guid Id { get; private set; }
        public int NumberId { get; private set; }
        public string Name { get; private set; }
        public string EditorState { get; private set; }
        public string Type { get; private set; }

        public RespondentContentItem(
            Guid id,
            int numberId, 
            string name,
            string editorState,
            string type)
        {
            this.Id = id;
            this.NumberId = numberId;
            this.Name = name;
            this.EditorState = editorState;
            this.Type = type;
        }

    }
}
