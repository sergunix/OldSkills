rem ��������� � ���������� �������������� ����� � �����

rem Diagnostics Tracking Service
rem ��������� �������������
rem ������ ������ IPsec ��� ������ ������� � ��������� � ��������� IP � ��������� �����������
rem ��������������� ������ IP
rem ����� �������� IPsec
rem �����-�����
rem �������� �������� �����-����
rem ��������� ���� � �������
rem ��������� ������� ��������� ������� ������
rem ����������� SSDP
rem ������ SSTP
rem �������� Windows
rem ������ ������������� WLAN
rem ������������� WWAN



sc config DiagTrack start= disabled
sc config dot3svc start= disabled
sc config IKEEXT start= disabled
sc config iphlpsvc start= disabled
sc config PolicyAgent start= disabled
sc config SCardSvr start= disabled
sc config SCPolicySvc start= disabled
sc config seclogon start= disabled
sc config SessionEnv start= disabled
sc config SSDPSRV start= disabled
sc config SstpSvc start= disabled
sc config WinDefend start= disabled
sc config Wlansvc start= disabled
sc config WwanSvc start= disabled



sc stop DiagTrack
sc stop dot3svc
sc stop IKEEXT
sc stop iphlpsvc
sc stop PolicyAgent
sc stop SCardSvr
sc stop SCPolicySvc
sc stop seclogon
sc stop SessionEnv
sc stop SSDPSRV
sc stop SstpSvc
sc stop WinDefend
sc stop Wlansvc
sc stop WwanSvc