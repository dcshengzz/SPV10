

create function [dbo].[StrToGuid](@s varchar(50)) returns uniqueidentifier as begin
    set @s = replace(replace(@s,'0x',''),'-','')
    set @s = stuff(stuff(stuff(stuff(@s,21,0,'-'),17,0,'-'),13,0,'-'),9,0,'-')
    return cast(@s as uniqueidentifier)
end

