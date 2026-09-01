SurveyPlus - 
Based on Clover 2.4.1

DEV-backend branch

------------------
Audit Trailer Feature Implementing Guide:

1. Run "swz-appbuilder-clover\DB\MSSQL\Change07.sql"
2. In Admin Panel, do a database sync and add AuditLog, vSP_auditlog, vSP_auditlog_EventType, vSP_auditlog_TableName. In Data Model, add Id attribute for vSP_auditlog, vSP_auditlog_EventType, vSP_auditlog_TableName
3. In dashboard, clear cache
4. Do Mapping Data Model for form AuditTrailer (Collection entity: vSP_auditlog, Collection filter: StructDivisionFilter, gridview_1
5. Do Mapping Data Model for form AuditLog (Main entity: vSP_auditlog. Do automapping)
--------------------------------
Improve low-end tablet accessing speed Feauture Implementing Guide:
1. Run "swz-appbuilder-clover\DB\MSSQL\Change10.sql" to update form DataEditorDeploymentList and DataEditorDeployment. This will make use of react redirect feature instead of using hyperlink. Stored procedures are added to delete records faster
2. Rebuild jsx 
3. Clear browser cache before visiting
---------------------
Trk List feature implementing guide:
1. rebuild jsx (there are changes in react route)
2. run change28.sql
3. In admin panel, sync with database to update model changes for table qnn_list, QNN_TRK_LIST, QNN_TRK_LIST_SAMPLE
4. Update data mapping for qnn_list, QNN_TRK_LIST, QNN_TRK_LIST_SAMPLE
5. reset cache in dashboard 
-------------------------