using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.Loader;
using System.Text;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.Emit;
using Microsoft.Extensions.Logging;
using swz.Clover.Core.Metadata;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;
using swz.Workflow.Core;

namespace swz.Clover.Core.CodeActions
{
    public class CodeActionsCompiler
    {
        private static readonly ILogger _logger = DefaultApplicationLogging.CreateLogger<CodeActionsCompiler>();
        private static readonly Lazy<ConcurrentDictionary<string, byte>> LazyLocations = new Lazy<ConcurrentDictionary<string, byte>>(FillDefaultLocations);
        private static readonly Lazy<ConcurrentDictionary<string, byte>> LazyUsings = new Lazy<ConcurrentDictionary<string, byte>>(FillDefaultUsings);
        
        public static IEnumerable<string> Usings => LazyUsings.Value.Keys;
        public static IEnumerable<string> Locations => LazyLocations.Value.Keys;
        
        /// <summary>
        /// Called in a static initialiser at application startup to initialise the LazyLocations dictionary
        /// </summary>
        /// <returns>dictionary keyed by assembly location with 0 for the value</returns>
        private static ConcurrentDictionary<string, byte> FillDefaultLocations()
        {
            HashSet<string> locations = new HashSet<string>();
            List<Assembly> loadedAssemblies = System.AppDomain.CurrentDomain.GetAssemblies().ToList();

            _logger.LogTrace("FillDefaultLocations: there are {0} assemblies loaded into the execution context of this application domain", loadedAssemblies.Count);

            foreach (Assembly loadedAssembly in loadedAssemblies)
            {
                try
                {
                    //nb: Location is not supported in a dynamic assembly so ignore those (at time of writing there's 1 on my machine)
                    if (!loadedAssembly.IsDynamic)
                    {
                        string loadedAssemblyLocation = loadedAssembly.Location;
                        locations.Add(loadedAssemblyLocation);
                    } 
                    else
                    {
                        //I don't think this is important but will log at trace level for future troubleshooting just in case
                        _logger.LogTrace("FillDefaultLocations: ignoring dynamic assembly {0}", loadedAssembly.FullName);
                    }
                }
                catch (Exception e)
                {
                    //20220627AH
                    //This used to be an empty catch block and there was no IsDynamic check, so dynamic assemblies
                    //were just ignored (as desired since they don't have a location) however this was flagged in
                    //a code review so we added a critical logging statement here - important as it would catch other
                    //exceptions we might not be expecting) - but also means that every time the application starts
                    //there is an unuseful exception cluttering the logs because of the dynamic assembly.
                    //Therefore I've added a check for dynamic assemblies to avoid the throw altogether,
                    //and we will also now log unexpected exceptions caught here at error level instead of critical.
                    _logger.LogError(e, nameof(FillDefaultLocations) + " - caught exception");
                }
            }

            _logger.LogTrace("FillDefaultLocations: found locations for {0} assemblies", locations.Count);
            ConcurrentDictionary<string, byte> defaultLocations 
                = new ConcurrentDictionary<string, byte>(locations.Select(l=>new KeyValuePair<string, byte>(l,0)));
            return defaultLocations;
        }
        
        private static ConcurrentDictionary<string, byte> FillDefaultUsings()
        {
            return new ConcurrentDictionary<string, byte>(DefaultUsings.Select(l => new KeyValuePair<string, byte>(l, 0)));
        }
        
        
        public static List<string> DefaultUsings = new List<string>
        {
            "System",
            "System.Collections",
            "System.Collections.Generic",
            "System.Linq",
            "System.Threading",
            "System.Threading.Tasks",
            "Microsoft.CSharp",
            "System.Dynamic",
            typeof(Microsoft.CSharp.RuntimeBinder.CSharpArgumentInfo).Namespace,
            typeof(Filter).Namespace,
            typeof(EntityModel).Namespace
        };

        static CodeActionsCompiler()
        {
            CompilationEnabled = true;
            DebugMode = false;
        }
        
        protected CodeActionsCompiler()
        {}

        public static bool CompilationEnabled { get; set; }
        public static bool DebugMode { get; set; }
        
        public static string TempDirectory { get; set; }

        public static void RegisterAssembly(string longName)
        {
            var assembly = Assembly.Load(new AssemblyName(longName));
            RegisterAssembly(assembly);
        }
        
        public static void RegisterAssembly(Assembly assembly)
        {
            if (assembly != null && !string.IsNullOrEmpty(assembly.Location))
            {
                LazyLocations.Value.AddOrUpdate(assembly.Location, 0, (s, b) => 0);
                GetAllNamespacesFromAssembly(assembly).ToList().ForEach(ns=>LazyUsings.Value.AddOrUpdate(ns,0,(s, b) => 0));
            }
        }
        
        private static IEnumerable<string> GetAllNamespacesFromAssembly(Assembly loadedAssembly)
        {
            return loadedAssembly.GetTypes()
                .Select(t => t.Namespace)
                .Distinct().Where(n => !string.IsNullOrEmpty(n) && !n.StartsWith("<"));
        }

        public static CodeActionsInvoker GetCodeActionsInvoker(List<CodeAction> codeActionDefinitions, out Dictionary<string, string> compilationErrors, bool ignoreNotCompiled,
            string namespacePostfix = null)
        {
            if (!codeActionDefinitions.Any() || !CompilationEnabled)
            {
                compilationErrors = new Dictionary<string, string>();
                return new CodeActionsInvoker();
            }

            return Compile(codeActionDefinitions, namespacePostfix, out compilationErrors, ignoreNotCompiled);
        }

           private static CodeActionsInvoker Compile( List<CodeAction> codeActionDefinitions, string namespacePostfix,
            out Dictionary<string, string> compileErrors,bool ignoreNotCompiled, List<(CodeActionType type, string name)> excludes =  null)
        {

            //SFWKZ - 06   Path Manipulation
            //Fixed by settting a fixed directory name as a temp folder without using GetEnvironmentVariable method
            var directory = !string.IsNullOrEmpty(TempDirectory) ? Path.Combine(Directory.GetCurrentDirectory(), TempDirectory) : null;

            if (DebugMode && string.IsNullOrEmpty(directory))
                throw new Exception("Code action compiler. The Debug mode requires to specify Temp directory.");

            var assemblyName = $"{CodeActionUtils.GetNamespaceName(namespacePostfix)}_{Guid.NewGuid():N}";

            var trees = new List<(SyntaxTree tree, int lineShift, CodeAction codeAction)>();

            foreach (var codeActionDefinition in codeActionDefinitions)
            {
                if (excludes != null && excludes.Any(e=> e.name.Equals(codeActionDefinition.Name,StringComparison.Ordinal) && e.type == codeActionDefinition.Type))
                    continue;
                
                var (codeToCompile, lineshift) = GetCodeToCompile(codeActionDefinition, namespacePostfix);

                SyntaxTree syntaxTree;
                if (DebugMode && !string.IsNullOrEmpty(directory))
                {
                    var combine = Path.Combine(directory, $"{assemblyName}_{CodeActionUtils.GetClassName(codeActionDefinition.Name, codeActionDefinition.Type)}.cs");
                    File.WriteAllText(combine, codeToCompile, Encoding.UTF8);
                    syntaxTree = CSharpSyntaxTree.ParseText(codeToCompile, CSharpParseOptions.Default, combine, Encoding.UTF8);
                }
                else
                {
                    syntaxTree = CSharpSyntaxTree.ParseText(codeToCompile);
                }

                trees.Add((tree: syntaxTree, lineShift: lineshift, codeAction: codeActionDefinition));
            }
           

            var references = Locations.Select(l => MetadataReference.CreateFromFile(l)).ToList();

            var options = new CSharpCompilationOptions(OutputKind.DynamicallyLinkedLibrary, optimizationLevel: DebugMode ? OptimizationLevel.Debug : OptimizationLevel.Release);

            var method = typeof(CSharpCompilationOptions).GetMethod("WithTopLevelBinderFlags", BindingFlags.NonPublic | BindingFlags.Instance);
            // we need to pass BinderFlags.IgnoreCorLibraryDuplicatedTypes, but it's an internal class 
            if (method != null)
            {
                options = (CSharpCompilationOptions) method.Invoke(options, new object[] {1u << 26});
            }

            var compilation = CSharpCompilation.Create(assemblyName, syntaxTrees: trees.Select(t => t.Item1), references: references,
                options: options);

            EmitResult result;
            Assembly compiledAssembly = null;

            if (DebugMode)
            {
                var dllName = $"{assemblyName}.dll";
                var pdbName = $"{assemblyName}.pdb";
                 
                result = compilation.Emit(Path.Combine(directory, dllName), Path.Combine(directory, pdbName));

                if (result.Success)
                {
                    compiledAssembly = AssemblyLoadContext.Default.LoadFromAssemblyPath(Path.Combine(directory, dllName));
                }
            }
            else
            {
                using (var ms = new MemoryStream())
                {
                    result = compilation.Emit(ms);

                    if (result.Success)
                    {
                        ms.Seek(0, SeekOrigin.Begin);
                        compiledAssembly = AssemblyLoadContext.Default.LoadFromStream(ms);
                    }
                }
            }

            if (!result.Success)
            {
                var newExcludes = new List<(CodeActionType type, string name)>();
                var errorBuilder = new StringBuilder();
                bool forceThrow = false;
                
                var groopedErrors = new Dictionary<string,StringBuilder>();
                
                foreach (var diagnostic in result.Diagnostics.Where(d => d.Severity == DiagnosticSeverity.Error))
                {
                    var tuple = trees.FirstOrNull(t => t.tree.IsEquivalentTo(diagnostic.Location.SourceTree));
                   
                    if (tuple == null)
                    {
                        errorBuilder.AppendLine(diagnostic.GetMessage());
                        forceThrow = true;
                    }
                    else
                    {
                        var exclude = (type: tuple.Value.codeAction.Type, name: tuple.Value.codeAction.Name);
                        if (!newExcludes.Contains(exclude))
                        {
                            newExcludes.Add(exclude);
                        }
                        
                        var errorName = $"{tuple.Value.codeAction.Type}_{tuple.Value.codeAction.Name}";
                        if (!groopedErrors.ContainsKey(errorName))
                            groopedErrors.Add(errorName, new StringBuilder());
                        
                        var shift = tuple.Value.lineShift;
                        var position = diagnostic.Location.GetLineSpan().StartLinePosition;
                        var lineNumber = position.Line - shift;
                        if (lineNumber >= 0)
                        {
                            var errorInCode = $"({lineNumber}:{position.Character}): error {diagnostic.Descriptor.Id}: {diagnostic.GetMessage()}";
                            groopedErrors[errorName].AppendLine(errorInCode);
                            errorBuilder.AppendLine(errorInCode);
                        }
                        else
                        {
                            var errorInUsings = String.Format("({0}): error {1}: {2}", "Using section", diagnostic.Descriptor.Id, diagnostic.GetMessage());
                            groopedErrors[errorName].AppendLine(errorInUsings);
                            errorBuilder.AppendLine(errorInUsings);
                        }
                    }
                }

                if (!ignoreNotCompiled || forceThrow || excludes != null)
                    throw new InvalidOperationException(errorBuilder.ToString());

                compileErrors = groopedErrors.ToDictionary(kvp => kvp.Key, kvp => kvp.Value.ToString());
                return Compile(codeActionDefinitions,namespacePostfix, out _, true, newExcludes);
            }

            var invoker = new CodeActionsInvoker();

            if (compiledAssembly != null)
                foreach (var type in compiledAssembly.GetTypes())
                {
                    invoker.AddCompiledType(type);
                }

            compileErrors = new Dictionary<string, string>();

            return invoker;
        }
        

        private static (string Code, int LineShift) GetCodeToCompile(CodeAction codeActionDefinition, string namespacePostfix)
        {
            var lineshift = 0;
            var codeToCompile = new StringBuilder();
            var usings = codeActionDefinition.Usings.Replace("/r",string.Empty).Replace("/n",string.Empty).Split(';').Select(s=>s.Trim())
                .Concat(DefaultUsings).Distinct();

            foreach (var use in usings)
            {
                if (string.IsNullOrEmpty(use))
                    continue;
                codeToCompile.Append($"using {use};\r\n");
                lineshift++;
            }

            var namespaceName = CodeActionUtils.GetNamespaceName(namespacePostfix);
            codeToCompile.AppendFormat(@"namespace {0} {{", namespaceName);
            codeToCompile.Append("\r\n");
            lineshift++;

            var className = CodeActionUtils.GetClassName(codeActionDefinition.Name, codeActionDefinition.Type);
            codeToCompile.AppendFormat("public static class {0} {{", className);
            codeToCompile.Append("\r\n");
            lineshift++;


            var methodName = CodeActionUtils.GetMethodName(codeActionDefinition.Name, codeActionDefinition.Type, codeActionDefinition.IsAsync);

            var actionCode = codeActionDefinition.Source;

            if (DebugMode)
            {
                actionCode = actionCode.Replace(@"/*break*/", @"if (System.Diagnostics.Debugger.IsAttached) {
System.Diagnostics.Debugger.Break();
}");
            }
            
            if (codeActionDefinition.Type == CodeActionType.Filter)
            {
                codeToCompile.Append(
                    codeActionDefinition.IsAsync
                        ? $"public static async Task<{nameof(Filter)}> {methodName} ({nameof(EntityModel)} model, List<dynamic> entities, dynamic options) {{"
                        : $"public static {nameof(Filter)} {methodName} ({nameof(EntityModel)} model, List<dynamic> entities, dynamic options) {{");


            }
            else if (codeActionDefinition.Type == CodeActionType.Trigger)
            {
                codeToCompile.Append(
                    codeActionDefinition.IsAsync
                        ? $"public static async Task<(string Message, bool IsCancelled)> {methodName} ({nameof(EntityModel)} model, List<dynamic> entities, dynamic options) {{"
                        : $"public static (string Message, bool IsCancelled) {methodName} ({nameof(EntityModel)} model, List<dynamic> entities, dynamic options) {{");

            }
            else if (codeActionDefinition.Type == CodeActionType.Action)
            {
                codeToCompile.Append(
                    codeActionDefinition.IsAsync
                        ? $"public static async Task<dynamic> {methodName} (dynamic request) {{"
                        : $"public static dynamic {methodName} (dynamic request) {{");
            }


            codeToCompile.Append("\r\n");
            codeToCompile.Append(actionCode);
            codeToCompile.Append("\r\n}\r\n");


            codeToCompile.Append("}");
            codeToCompile.Append("\r\n}");
            return (codeToCompile.ToString(), lineshift);
        }

    }
}