Some of the dependencies will declare transitive dependencies on versions of packages that may be too old or have a vulnerability. To deal with this we need to override this behaviour by declaring an explicit dependency on the appropriate version of the package to use instead.

As of 2024-08-21 we are doing this for:
- Azure.Identity <-- this gets pulled in by Microsoft.Data.SqlClient
- System.Data.SqlClient <-- this gets pulled in by Hangfire (to revisit this after updating hangfire)
- Microsoft.AspNetCore.Mvc.Razor.Extensions <-- pulled in by Microsoft.AspNetCore.Mvc.Razor.RuntimeCompilation
- Microsoft.CodeAnalysis.Razor <-- pulled in by Microsoft.AspNetCore.Mvc.Razor.RuntimeCompilation