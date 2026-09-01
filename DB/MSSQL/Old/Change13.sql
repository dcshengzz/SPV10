create function IsFileToken ( @testString varchar(32))
returns int
as
begin
    declare @ret int
    select  @ret = 0,
            @testString = replace(replace(@testString, '{', ''), '}', '')
    if len(isnull(@testString, '')) = 32 and
       @testString NOT LIKE '%[^0-9A-Fa-f-]%'
        	set @ret = 1


	return @ret
end

GO


create function StrToGuid(@s varchar(50)) returns uniqueidentifier as begin
    set @s = replace(replace(@s,'0x',''),'-','')
    set @s = stuff(stuff(stuff(stuff(@s,21,0,'-'),17,0,'-'),13,0,'-'),9,0,'-')
    return cast(@s as uniqueidentifier)
end

GO


CREATE PROCEDURE [dbo].[spSP_GetDplyUploadedFiles]
		@DplyId NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ra.AnsVal as Token, concat(ra.AnsVal COLLATE DATABASE_DEFAULT,'_',uf.Name COLLATE DATABASE_DEFAULT) as Filename
	FROM   QNN_RESP_ANS ra
	inner join QNN_RESP r on r.Id = ra.RespId
	inner join QNN_DPLY d on d.Id = r.DplyId
	inner join QNN_QNN_FIELD f on f.Id = ra.QnnFieldId
	inner join dwUploadedFiles uf on uf.Id = upper(dbo.StrToGuid(ra.AnsVal))
	WHERE d.Id = @DplyId and 
	f.Type = 'input' and dbo.IsFileToken(ra.AnsVal)=1
END 

GO
 
GO