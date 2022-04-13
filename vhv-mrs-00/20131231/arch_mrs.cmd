@echo off
REM --------------------------------------------------------------------------
REM   �������� 䠩� ���:
REM
REM   ��娢�஢���� �ਭ���� ��� 䠩��� (mrs) � �ࢥ� MICS 
REM
REM   (�) 䨫��� ��� "����஬ �࠭ᣠ� �����-������" - ���客᪮� �����
REM                               2009-2011
REM --------------------------------------------------------------------------

REM ��⠭�������� ������� ����� ��६�����
setlocal

REM ���� �ࢥ� ���஭��� �����
set SMTP=vhv-dc-01.corp.it.ltg.gazprom.ru

REM �����⥫� ����� � ����� 䠩���
set MAIL_TO=sysadmin@vhv.ltg.gazprom.ru

REM ��ࠢ�⥫� �����
set MAIL_FROM=arch_mrs.cmd mics@vhv.ltg.gazprom.ru

REM ���� ᮮ�饭��
set THEME=ArchiveMRS: ��娢��� �ਭ���� MRS-䠩��� �� �ࢥ� ����

REM ��� 䠩�� a�娢� 
set ARCHDOG=_MrsDog
set ARCHNAKL=_MrsNkl
set ARCHMRS=_MrsNSI
set ARCHSYNC=_MrsSync

REM ��� ���-䠩��
set ARCHLOG=..\log%ARCHMRS%.txt

REM []-----------------------------------------------------------------
REM     ���室�� � ࠡ�稩 ��⠫��
if not exist .\_Replication goto NOWORKPATH
cd _Replication

REM []--- ��ନ�㥬 �� ������� Date ��६���� ��� � �����
set MONTH=%date:~3,2%

REM []--- ������� ��諮������ 䠩�� ����筮�� ��娢�
del /Q /F %ARCHMRS%%MONTH%
del /Q /F .\MRS_Dogovor\%ARCHDOG%%MONTH%
del /Q /F .\MRS_NAKL\%ARCHNAKL%%MONTH%
del /Q /F .\MRS_SYNC_ORACLE\%ARCHSYNC%%MONTH%

REM []--- ��娢�஢���� MRS � ����� _Replication
rar m0 -y %ARCHMRS%%MONTH% *.mrs *.old *.yes

REM []--- ��娢�஢���� MRS � ����� _Replication\MRS_Dogovor
rar m -y .\MRS_Dogovor\%ARCHDOG%%MONTH% .\MRS_Dogovor\*.mrs .\MRS_Dogovor\*.yes .\MRS_Dogovor\*.old

REM []--- ��娢�஢���� MRS � ����� _Replication\MRS_NAKL
rar m -y .\MRS_NAKL\%ARCHNAKL%%MONTH% .\MRS_NAKL\*.mrs .\MRS_NAKL\*.yes .\MRS_NAKL\*.old 

REM []--- ��娢�஢���� ����⮢ ᨭ�஭���樨 MRSSYNC � ����� _Replication\MRS_SYNC_ORACLE
rar m -y .\MRS_SYNC_ORACLE\%ARCHSYNC%%MONTH% .\MRS_SYNC_ORACLE\*.mrs .\MRS_SYNC_ORACLE\*.yes .\MRS_SYNC_ORACLE\*.old 

REM []--- �뤥����� ���ଠ樨 � 䠩��� ��娢�� MRS
chcp 1251
echo. > ..\log%ARCHMRS%.txt
dir               | find /I ".rar" >>  ..\log%ARCHMRS%.txt
dir .\MRS_Dogovor | find /I ".rar" >> ..\log%ARCHMRS%.txt
dir .\MRS_NAKL    | find /I ".rar" >> ..\log%ARCHMRS%.txt
dir .\MRS_SYNC_ORACLE    | find /I ".rar" >> ..\log%ARCHMRS%.txt
chcp 866

REM []--- ��ࠢ�� ᮮ�饭�� � ����஢���� 䠩���
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" �஢��� ���ﭨ� �ਥ��\��।�� ��� ��᫥ ��娢�樨 �� ��뫪� http://nsi/MRS_report.aspx %%PUT="..\log%ARCHMRS%.txt"
goto END

:NOWORKPATH
REM []--- ��ࠢ�� ᮮ�饭�� �� ������⢨� � ⥪�饬 ��⠫��� ��⠫��� _Replication
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" ��������! ����稩 ��⠫�� _Replication ������㯥�, ��娢�஢���� �ਭ���� ��� 䠩��� (mrs) �� �뫮 �믮�����.
goto END

:END