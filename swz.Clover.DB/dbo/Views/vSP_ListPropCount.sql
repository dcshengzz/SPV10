CREATE VIEW [dbo].[vSP_ListPropCount] AS 
select l.Id, count(*) as PropCount, STUFF((SELECT ',' + UPPER(Alias) 
		                    from qnn_list_prop where ListId = l.Id
		                    group by Alias, NumberId
		                    order by NumberId
		            FOR XML PATH(''), TYPE
		            ).value('.', 'NVARCHAR(MAX)') 
		        ,1,1,'') as Fields, STUFF((SELECT ',' + UPPER(Id) 
		                    from qnn_list_prop where ListId = l.Id
		                    group by Id, NumberId
		                    order by NumberId
		            FOR XML PATH(''), TYPE
		            ).value('.', 'NVARCHAR(MAX)') 
		        ,1,1,'') as FieldsId from QNN_LIST_PROP p
left join QNN_LIST l on l.Id = p.ListId
group by l.Id
