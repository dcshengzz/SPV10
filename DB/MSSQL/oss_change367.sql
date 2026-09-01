							
IF NOT EXISTS(SELECT 1 FROM QNN_STATUS_FLOW                                                              
	WHERE Id = N'8AEF7979-14F0-4B91-BF93-9F2038CF209D')                                                  
BEGIN                                                                                                    
PRINT('Adding new status flow "Acknowledged to Exempted-NIO"...');                                            
INSERT [dbo].[QNN_STATUS_FLOW] ([Id], [FromStatus], [ToStatus], [CreateBy], [CreateOn]) VALUES (N'8AEF7979-14F0-4B91-BF93-9F2038CF209D', N'19a0c4ff-be69-4011-a135-3c05a5429616', N'9731de1d-2b6a-484c-bf10-44f842a3140e' ,NULL ,NULL)
END                                                                                                     
																
IF NOT EXISTS(SELECT 1 FROM QNN_STATUS_FLOW                                                              
	WHERE Id = N'43F560AB-4936-45DC-A3A5-58AA7ACACB5E')                                                  
BEGIN                                                                                                    
PRINT('Adding new status flow "Acknowledged to Exempted-CR"...');                                            
INSERT [dbo].[QNN_STATUS_FLOW] ([Id], [FromStatus], [ToStatus], [CreateBy], [CreateOn]) VALUES (N'43F560AB-4936-45DC-A3A5-58AA7ACACB5E', N'19a0c4ff-be69-4011-a135-3c05a5429616', N'3FE8F2F4-4DEE-4A4A-B93C-B3FA12EA35D2' ,NULL ,NULL)
END                                                                                                     
																
IF NOT EXISTS(SELECT 1 FROM QNN_STATUS_FLOW                                                              
	WHERE Id = N'45EA30BD-6CD7-4395-A43D-F1B9317F68F9')                                                  
BEGIN                                                                                                    
PRINT('Adding new status flow "Acknowledged to Exempted-Ex"...');                                            
INSERT [dbo].[QNN_STATUS_FLOW] ([Id], [FromStatus], [ToStatus], [CreateBy], [CreateOn]) VALUES (N'45EA30BD-6CD7-4395-A43D-F1B9317F68F9', N'19a0c4ff-be69-4011-a135-3c05a5429616', N'C14F238B-C28C-44F4-A8A4-105704F2BD85', NULL, NULL)
END                                                                                                     
																
IF NOT EXISTS(SELECT 1 FROM QNN_STATUS_FLOW                                                              
	WHERE Id = N'27B06727-8D26-4FD9-94DA-40F030426141')                                                  
BEGIN                                                                                                    
PRINT('Adding new status flow "Acknowledged to Exempted-OS"...');                                            
INSERT [dbo].[QNN_STATUS_FLOW] ([Id], [FromStatus], [ToStatus], [CreateBy], [CreateOn]) VALUES (N'27B06727-8D26-4FD9-94DA-40F030426141', N'19a0c4ff-be69-4011-a135-3c05a5429616', N'16B54BE9-3418-4E7D-8E35-C8BFCF26FC95', NULL, NULL)
END                                                                                                     
						