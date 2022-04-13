Select * From Win32_NTLogEvent Where
(Logfile = 'SYSTEM' Or Logfile = 'APPLICATION' Or Logfile = 'SECURITY' Or Logfile = 'File Replication Service' Or Logfile = 'Directory Service') And
(EventType = '1' Or EventCode = '36' Or EventCode = '644' Or EventCode = '4015' Or EventCode = '13508' Or EventCode = '13568') And
(SourceName <> 'Microsoft-Windows-CertificateServicesClient-AutoEnrollment' And EventCode <> '6') And
(SourceName <> 'NTDS Replication' And EventCode <> '1864') And
(SourceName <> 'DCOM' And EventCode <> '10005')