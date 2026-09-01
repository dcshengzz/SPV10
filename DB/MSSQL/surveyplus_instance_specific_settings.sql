--Script to update some instance-specific settings that commonly need to be configured
--Edit with the appropriate values for your environment. Backup existing database before running.
--Last updated 2022-07-07

--Application Name
UPDATE [dwAppSettings] SET [Value]='SurveyPlus' WHERE [Name]='ApplicationName' AND [GroupName]='Application settings';
UPDATE [dwAppSettings] SET [Value]='SurveyPlus' WHERE [Name]='ApplicationDesc' AND [GroupName]='Application settings';

--Application domains (mainly used in generated email links), please set appropriate domain names here
--eg: http://survey-uat.mpa.gov.sg/ for internet
UPDATE [dwAppSettings] SET [Value]='localhost:28800' WHERE [Name]='InternetDomainAuthority' AND [GroupName]='Internet Settings';
UPDATE [dwAppSettings] SET [Value]='localhost:48800' WHERE [Name]='IntranetDomainAuthority' AND [GroupName]='Intranet Settings';

--Administrative user emails (change to one of your own administrators)
UPDATE [dwAppSettings] SET [Value]='mispadmin@softworkz.net' WHERE [Name]='HostEmails' AND [GroupName]='Security';

--3PA JWT Lifetime in minutes (Recommend just long enough to extract data in one session)
UPDATE [dwAppSettings] SET [Value]='60' WHERE [Name]='3PAJwtRenewalTokenExpiry' AND [GroupName]='Security';
UPDATE [dwAppSettings] SET [Value]='45' WHERE [Name]='3PAJwtSessionTokenExpiry' AND [GroupName]='Security';

--Resp U@App JWT Lifetime in minutes (Recommend 1 year in current version 20220707, ie 545760 minutes)
UPDATE [dwAppSettings] SET [Value]='545760' WHERE [Name]='RespJwtRenewalTokenExpiry' AND [GroupName]='Security';
UPDATE [dwAppSettings] SET [Value]='545760' WHERE [Name]='RespJwtSessionTokenExpiry' AND [GroupName]='Security';

--User dormancy settings (Will lock inactive users, -1 to disable)
UPDATE [dwAppSettings] SET [Value]='example1@softworkz.net, example2@softworkz.net' WHERE [Name]='UserDormancyReportEmails' AND [GroupName]='Security';
UPDATE [dwAppSettings] SET [Value]='-1' WHERE [Name]='UserLockWarnDays' AND [GroupName]='Security';
UPDATE [dwAppSettings] SET [Value]='-1' WHERE [Name]='UserLockInactiveDays' AND [GroupName]='Security';
UPDATE [dwAppSettings] SET [Value]='swzadmin, mispadmin' WHERE [Name]='UserDormancyExcludeLogins' AND [GroupName]='Security';

SELECT [GroupName], [Name], [Value], [ParamName] FROM dwAppSettings WHERE [Name] IN ( 
	'ApplicationName','ApplicationDesc','InternetDomainAuthority','IntranetDomainAuthority','HostEmails',
	'3PAJwtRenewalTokenExpiry', '3PAJwtSessionTokenExpiry', 'RespJwtRenewalTokenExpiry', 'RespJwtSessionTokenExpiry',
	'UserDormancyReportEmails', 'UserLockWarnDays', 'UserLockInactiveDays', 'UserDormancyExcludeLogins'
	)
	ORDER BY [GroupName], [Name];
