using swz.Clover.Core;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core.CodeActions
{
    public static class CodeActionUtils
    {
        public static string GetNamespaceName(string namespacePostfix)
        {
            return $"{NamespaceForCodeActions}_{namespacePostfix}".ToValidCSharpIdentifierName();
        }

        public static string GetClassName(string name, CodeActionType type)
        {
            return $"{name}_{type}_Class".ToValidCSharpIdentifierName();
        }
        
        public static string GetMethodName(string name, CodeActionType type, bool isAsync)
        {
            return $"{name}_{type}{(isAsync ? "Async" : string.Empty)}".ToValidCSharpIdentifierName();
        }

        public static string NamespaceForCodeActions = "CodeActions";
    }
}