----------------------
--fix slow loading of survey ans
CREATE INDEX [IDX_NumberId] ON [dbo].[QNN_QNN_FIELD]
([NumberId] ASC) 
GO

------------
--fix list property not shown in edit/new list sample form; list property cannot be edited
update QNN_LIST_PROP set UsrVisibleYN = 1, RespVisibleYN = 1, UsrEditYN = 1, TxtRow = null
GO


---------------
--fix export list sample error
   
	ALTER PROCEDURE [dbo].[spSP_GetListSampleProfile]
		@ListId uniqueidentifier,
		@ListSampleId uniqueidentifier,
		@ListSampleIds NVARCHAR(MAX),
		@IncludePassword BIT = 1
	AS
	BEGIN
		--if @ListSampleId='' 
			--set @ListSampleId = null
		DECLARE @cols AS NVARCHAR(MAX),
		    @query_single  AS NVARCHAR(MAX),
		    @query_multiple  AS NVARCHAR(MAX),
		    @query_all  AS NVARCHAR(MAX)

		select @cols = STUFF((SELECT ',' + UPPER(QUOTENAME(Alias)) 
		                    from qnn_list_prop where ListId = @ListId
		                    group by Alias, NumberId
		                    order by NumberId
		            FOR XML PATH(''), TYPE
		            ).value('.', 'NVARCHAR(MAX)') 
		        ,1,1,'')

	  if(@cols is not NULL)
			Begin

					if (@IncludePassword=1)
								begin
								set @query_single = 'SELECT UID, NAME, EMAIL, ACTIVE, PASSWORD_RESET, PEER_UID, PASSWORD, ' + @cols + ' from
								(
								select a.ListSampleId,  s.UID, s2.UID as Peer_UID, s.Pwd as Password, s.Name, s.Email, s.ActiveYN as Active, s.PwdResetYN as Password_Reset, f.Alias as PropAlias, a.PropValue from qnn_list_sample r 
								left join qnn_list_sample_prop a on r.Id = a.ListSampleId
								left join qnn_list_prop f on f.Id = a.ListPropId							
								left join qnn_sample s on s.Id = r.SampleId
								left join qnn_sample s2 on s2.Id = r.SamplePeerId
								where r.Id = @ListSampleId
								) d 
								pivot
								(
								max(PropValue) 
								for PropAlias in (' + @cols + ')
														) p order by UID'


							set @query_all = 'SELECT UID, NAME, EMAIL, ACTIVE, PASSWORD_RESET, PEER_UID, PASSWORD, ' + @cols + ' from
							(
							select a.ListSampleId, s.UID, s2.UID as Peer_UID, s.Pwd as Password, s.Name, s.Email, s.ActiveYN as Active, s.PwdResetYN as Password_Reset, f.Alias as PropAlias, a.PropValue from qnn_list_sample r 
							left join qnn_list_sample_prop a on r.Id = a.ListSampleId
							left join qnn_list_prop f on f.Id = a.ListPropId							
							left join qnn_sample s on s.Id = r.SampleId
							left join qnn_sample s2 on s2.Id = r.SamplePeerId
							where r.ListId = @ListId
							) d 
							pivot
							(
							max(PropValue) 
							for PropAlias in (' + @cols + ')
													) p order by UID'


						
						set @query_multiple = 'SELECT UID, NAME, EMAIL, ACTIVE, PASSWORD_RESET, PEER_UID, PASSWORD, ' + @cols + ' from
						(
						select a.ListSampleId,  s.UID, s2.UID as Peer_UID, s.Pwd as Password, s.Name, s.Email, s.ActiveYN as Active, s.PwdResetYN as Password_Reset, f.Alias as PropAlias, a.PropValue from qnn_list_sample r
						left join qnn_list_sample_prop a on r.Id = a.ListSampleId
						left join qnn_list_prop f on f.Id = a.ListPropId
						left join qnn_sample s on s.Id = r.SampleId
						left join qnn_sample s2 on s2.Id = r.SamplePeerId
						where r.Id in (' +@ListSampleIds+ ')
						) d 
						pivot
						(
						max(PropValue) 
						for PropAlias in (' + @cols + ')
												) p order by UID'
					END
				ELSE
								begin
								set @query_single = 'SELECT UID, NAME, EMAIL, ACTIVE, PASSWORD_RESET, PEER_UID, ' + @cols + ' from
								(
								select a.ListSampleId,  s.UID, s2.UID as Peer_UID, s.Pwd as Password, s.Name, s.Email, s.ActiveYN as Active, s.PwdResetYN as Password_Reset, f.Alias as PropAlias, a.PropValue from qnn_list_sample r
								left join qnn_list_sample_prop a on r.Id = a.ListSampleId
								left join qnn_list_prop f on f.Id = a.ListPropId
								left join qnn_sample s on s.Id = r.SampleId
								left join qnn_sample s2 on s2.Id = r.SamplePeerId
								where r.Id = @ListSampleId 
								) d 
								pivot
								(
								max(PropValue) 
								for PropAlias in (' + @cols + ')
														) p order by UID'


							set @query_all = 'SELECT UID, NAME, EMAIL, ACTIVE, PASSWORD_RESET, PEER_UID, ' + @cols + ' from
							(
							select a.ListSampleId, s.UID, s2.UID as Peer_UID, s.Pwd as Password, s.Name, s.Email, s.ActiveYN as Active, s.PwdResetYN as Password_Reset, f.Alias as PropAlias, a.PropValue from qnn_list_sample r
							left join qnn_list_sample_prop a on r.Id = a.ListSampleId
							left join qnn_list_prop f on f.Id = a.ListPropId
							left join qnn_sample s on s.Id = r.SampleId
							left join qnn_sample s2 on s2.Id = r.SamplePeerId
							where r.ListId = @ListId
							) d 
							pivot
							(
							max(PropValue) 
							for PropAlias in (' + @cols + ')
													) p order by UID'


						
						set @query_multiple = 'SELECT UID, NAME, EMAIL, ACTIVE, PASSWORD_RESET, PEER_UID, ' + @cols + ' from
						(
						select a.ListSampleId,  s.UID, s2.UID as Peer_UID, s.Pwd as Password, s.Name, s.Email, s.ActiveYN as Active, s.PwdResetYN as Password_Reset, f.Alias as PropAlias, a.PropValue from qnn_list_sample r
						left join qnn_list_sample_prop a on r.Id = a.ListSampleId
						left join qnn_list_prop f on f.Id = a.ListPropId
						left join qnn_sample s on s.Id = r.SampleId
						left join qnn_sample s2 on s2.Id = r.SamplePeerId
						where r.Id in (' +@ListSampleIds+ ')
						) d 
						pivot
						(
						max(PropValue) 
						for PropAlias in (' + @cols + ')
												) p order by UID'
					END

								
			

			END
	ELSE


			if (@IncludePassword=1)
				Begin
						set @query_single = 'SELECT s.UID as UID, s.NAME, s.EMAIL, s.ActiveYN as ACTIVE, s.PwdResetYN as PASSWORD_RESET, s2.UID as PEER_UID, s.Pwd as PASSWORD from qnn_list_sample r
						inner join qnn_sample s on s.Id = r.SampleId
						left join qnn_sample s2 on s2.Id = r.SamplePeerId
						where r.Id = @ListSampleId 
						order by s.UID'

						set @query_all = 'SELECT s.UID as UID, s.NAME, s.EMAIL, s.ActiveYN as ACTIVE, s.PwdResetYN as PASSWORD_RESET, s2.UID as PEER_UID, s.Pwd as PASSWORD from qnn_list_sample r
						inner join qnn_sample s on s.Id = r.SampleId
						left join qnn_sample s2 on s2.Id = r.SamplePeerId
						where r.ListId = @ListId 
						order by s.UID'


						set @query_multiple = 'SELECT s.UID as UID, s.NAME, s.EMAIL, s.ActiveYN as ACTIVE, s.PwdResetYN as PASSWORD_RESET, s2.UID as PEER_UID, s.Pwd as PASSWORD from qnn_list_sample r
						inner join qnn_sample s on s.Id = r.SampleId
						left join qnn_sample s2 on s2.Id = r.SamplePeerId
						where r.Id in (' +@ListSampleIds+ ')
						order by UID'

				END

			ELSE
				Begin
						set @query_single = 'SELECT s.UID as UID, s.NAME, s.EMAIL, s.ActiveYN as ACTIVE, s.PwdResetYN as PASSWORD_RESET, s2.UID as PEER_UID from qnn_list_sample r
						inner join qnn_sample s on s.Id = r.SampleId
						left join qnn_sample s2 on s2.Id = r.SamplePeerId
						where r.Id = @ListSampleId 
						order by s.UID'

						set @query_all = 'SELECT s.UID as UID, s.NAME, s.EMAIL, s.ActiveYN as ACTIVE, s.PwdResetYN as PASSWORD_RESET, s2.UID as PEER_UID from qnn_list_sample r
						inner join qnn_sample s on s.Id = r.SampleId
						left join qnn_sample s2 on s2.Id = r.SamplePeerId
						where r.ListId = @ListId 
						order by s.UID'


						set @query_multiple = 'SELECT s.UID as UID, s.NAME, s.EMAIL, s.ActiveYN as ACTIVE, s.PwdResetYN as PASSWORD_RESET, s2.UID as PEER_UID from qnn_list_sample r
						inner join qnn_sample s on s.Id = r.SampleId
						left join qnn_sample s2 on s2.Id = r.SamplePeerId
						where r.Id in (' +@ListSampleIds+ ')
						order by UID'

				END



	--select @cols;
	if @ListSampleId is null and @ListSampleIds is null 
		begin
			execute sp_executesql @query_all, N'@ListId uniqueidentifier', @ListId;
		END
	ELSE
		if @ListSampleId is not null
			begin
				execute sp_executesql @query_single, N'@ListSampleId uniqueidentifier', @ListSampleId;
			END
		ELSE
			begin
				execute sp_executesql @query_multiple;
			END
	END

GO
--------------------