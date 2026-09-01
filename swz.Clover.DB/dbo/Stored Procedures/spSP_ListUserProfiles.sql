

CREATE   PROCEDURE [dbo].[spSP_ListUserProfiles]
	@StructDivisionIds NVARCHAR(MAX) = null --comma delimited
AS
BEGIN
    SET XACT_ABORT, NOCOUNT ON;

    SELECT
		o.[Name] AS [Organisation],
		u.[Name],
		u.[IsLocked],		
		sc.[Login] AS [Login],						
		ad.[Login] AS [ADLogin],
		u.[LinkedDomainLogin],
		u.[LastLoginDate],
		u.[CreatedDate],
		cru.[Name] AS [CreatedBy],
		u.[UpdatedDate],
		upu.[Name] AS [UpdatedBy],
		u.[DormancyDate],
		u.[Email],
		STRING_AGG(r.[Code], ', ') WITHIN GROUP (ORDER BY r.[Code]) AS [Roles]
	FROM
		dwSecurityUser u
		LEFT JOIN StructDivision o ON u.[StructDivisionId]=o.[Id]
		LEFT JOIN dwSecurityCredential sc ON sc.[SecurityUserId]=u.[Id] AND sc.[AuthenticationType]=0
		LEFT JOIN dwSecurityCredential ad ON ad.SecurityUserId=u.[Id] AND ad.[AuthenticationType]=1
		LEFT JOIN dwSecurityUser cru ON cru.[Id]=u.[CreatedBy]
		LEFT JOIN dwSecurityUser upu ON upu.[Id]=u.[CreatedBy]
		LEFT JOIN dwSecurityUserToSecurityRole ur ON ur.[SecurityUserId]=u.[Id]
		LEFT JOIN dwSecurityRole r ON r.[Id]=ur.[SecurityRoleId]
	WHERE
		u.[Id] <> '00000000-0000-0000-0000-000000000000'
		AND u.[StructDivisionId] IN( SELECT Item FROM dbo.splitIds(@StructDivisionIds, ','))
	GROUP BY 
		o.[Name],
		u.[Name],
		u.[IsLocked],	
		sc.[Login],			
		ad.[Login],
		u.[LinkedDomainLogin],
		u.[LastLoginDate],
		u.[CreatedDate],
		cru.[Name],
		u.[UpdatedDate],
		upu.[Name],
		u.[DormancyDate],
		u.[Email];
END;