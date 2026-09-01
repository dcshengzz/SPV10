namespace swz.SurveyPlus.Application
{
    //This used to be UserType in SurveyResponseUpdate and now promoted to a public enum as we need it in more places
    //Renamed to SurveyUserType as the more general context doesn't make this clear.
    //Don't add other types here! This is specifically for things that need to alter their logic when working with the response.

    /// <summary>
    /// Indicates if the user who is accessing the survey / survey reponse is 
    /// an intranet Data Editor 
    /// or
    /// an internet Respondent.  
    /// </summary>
    public enum SurveyUserType { DataEditor, Respondent }
}
