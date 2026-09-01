using System.Collections.Generic;

namespace swz.Workflow.Core.Runtime
{
    public enum SuggestionCategory
    {
        RuleParameter, ActionParameter, ConditionParameter
    }

    public interface IDesignerAutocompleteProvider
    {
        List<string> GetAutocompleteSuggestions(SuggestionCategory category, string value);
    }
}
