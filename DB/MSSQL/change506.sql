-- Based on 476 (specific to a certain customised build), 
-- but does not set LastResponseVia to 'Online' for those with 'Unknown'.
-- If 476 has already been run this will probably not update any rows because the 
-- complete responses should have a non-unknown origin indicator already. 

-- Set some initial values for the new origin indicators (introduced in 474 or 505) 
-- in existing responses where it should be different from what is set by the default 
-- constraint added to the table.
-- Sets an 'Unknown' value (instead of null) for the completion origin indicators 
-- of existing complete responses (n.b this is in contrast to 476 which would have set
-- CompletedResponseVia and LastResponseVia to 'Online')

UPDATE 
	r
SET
	r.CompletedResponseAs='Unknown',
	r.CompletedResponseBy='Unknown',
	r.CompletedResponseVia='Unknown'
FROM
	QNN_RESP r
WHERE
	DateComplete IS NOT NULL  --Completed Response
	AND CompletedResponseAs IS NULL
	AND CompletedResponseBy IS NULL
	AND CompletedResponseVia IS NULL
	AND CompletedResponseUserId IS NULL
;
