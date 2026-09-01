



CREATE     VIEW [dbo].[vSP_ListSampleRespInfo]
AS
SELECT lsi.Id AS PK, lso.UserId, lso.Id AS lsoId, dsu.Name AS Username, vlsis.Segment, lsi.NumberId, lsi.DplyId, lsi.ListSampleId, s.UID, s.Name, CASE WHEN s1.UID IS NULL THEN NULL WHEN s1.UID IS NOT NULL THEN Concat(s1.UID, ' (', s1.Name, ')') END AS PeerName, 
             qs.Title AS StatusTitle, s1.UID AS UIDPeer, d.DateStart AS DplyDateStart, d.DateEnd AS DplyDateEnd, 
			 CASE 
			 WHEN due.DueDate IS NOT NULL THEN due.DueDate
			 ELSE d.DateEnd END AS DueDate, 
			 r.DateStart AS RespDateStart, 
             d.StructDivisionId, r.DateComplete AS RespDateEnd
FROM   dbo.QNN_DPLY_SAMPLE_OWNER AS lso INNER JOIN
             dbo.QNN_DPLY_SAMPLE_INFO AS lsi ON lso.ListSampleId = lsi.ListSampleId INNER JOIN
             dbo.dwSecurityUser AS dsu ON lso.UserId = dsu.Id INNER JOIN
             dbo.QNN_LIST_SAMPLE AS ls ON lsi.ListSampleId = ls.Id LEFT OUTER JOIN
             dbo.vSP_ListSampleIdSegment AS vlsis ON lsi.ListSampleId = vlsis.ListSampleId INNER JOIN
             dbo.QNN_SAMPLE AS s ON ls.SampleId = s.Id LEFT OUTER JOIN
             dbo.QNN_SAMPLE AS s1 ON ls.SamplePeerId = s1.Id INNER JOIN
             dbo.QNN_DPLY AS d ON lsi.DplyId = d.Id AND lso.DplyId = d.Id LEFT OUTER JOIN
             dbo.QNN_RESP AS r WITH (NOLOCK) ON lsi.DplyId = r.DplyId AND lsi.ListSampleId = r.ListSampleId LEFT OUTER JOIN
             dbo.vSP_DplySampleDueDate AS due ON lsi.DplyId = due.DplyId AND lsi.ListSampleId = due.ListSampleId LEFT OUTER JOIN
             dbo.QNN_STATUS AS qs ON qs.Id = lsi.Status
WHERE (d.IsDeleted = 0) AND (d.Status = 1)
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vSP_ListSampleRespInfo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'        End
         Begin Table = "d"
            Begin Extent = 
               Top = 1341
               Left = 57
               Bottom = 1538
               Right = 332
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "r"
            Begin Extent = 
               Top = 1539
               Left = 57
               Bottom = 1736
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "due"
            Begin Extent = 
               Top = 1737
               Left = 57
               Bottom = 1907
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qs"
            Begin Extent = 
               Top = 1908
               Left = 57
               Bottom = 2105
               Right = 286
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vSP_ListSampleRespInfo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "lso"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 206
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lsi"
            Begin Extent = 
               Top = 207
               Left = 57
               Bottom = 404
               Right = 310
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dsu"
            Begin Extent = 
               Top = 405
               Left = 57
               Bottom = 602
               Right = 301
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls"
            Begin Extent = 
               Top = 603
               Left = 57
               Bottom = 800
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vlsis"
            Begin Extent = 
               Top = 801
               Left = 57
               Bottom = 944
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 945
               Left = 57
               Bottom = 1142
               Right = 296
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s1"
            Begin Extent = 
               Top = 1143
               Left = 57
               Bottom = 1340
               Right = 296
            End
            DisplayFlags = 280
            TopColumn = 0
 ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vSP_ListSampleRespInfo';

