create function [dbo].[IsFileToken] ( @testString varchar(32))
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

