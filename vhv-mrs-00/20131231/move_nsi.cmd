@echo off
REM []-------------------------------------------------------------------------
REM    �������� 䠩� ���:
REM    ��७�� ��ନ஢����� ����⮢ ��� �� FTP-�ࢥ� ����
REM
REM     (C) 䨫��� ��� "����஬ �࠭ᣠ� �����-������" - ���客᪮� �����
REM                               2002-2013
REM ---------------------------------------------------------------------------

REM ��⠭�������� ������� ����� ��६�����
setlocal

REM ��� ��� �� �����䨪�樨 ����
set LPU=13

REM ���� SMTP �ࢥ� ���஭��� �����
set SMTP=vhv-dc-01.corp.it.ltg.gazprom.ru

REM �����⥫� ���� � ����㧪� 䠩���
set MAIL_TO=sysadmin@vhv.ltg.gazprom.ru

REM ��ࠢ�⥫� ����
set MAIL_FROM=move_nsi.cmd mics@vhv.ltg.gazprom.ru

REM ���� ᮮ�饭��
set THEME=��७�� ��ନ஢����� ����⮢ ��� �� FTP-�ࢥ� ����

REM ���� ᮮ�饭��
set BODY=��७�c 䠩��� ���� �믮���� �� ��稭� ������㯭��� ��⠫���� �� FTP-�ࢥ�! ������� ��� V: �ࢥ� vhv-mrs-00!!!

REM ���� ᮮ�饭��
set BODYSEND="���᮪ 䠩��� ��।����� move_nsi.cmd �� FTP-�ࢥ� ����"

REM ����饭�� � ����୮� ����᪥ ⮣� �� ��⭨��
set BODYSENDLOCK="��������! �� �����訫�� ���� ����� move_nsi.cmd,��������, ����� �����! "

REM ��� 䠩�� �����஢��
set LOCKFILE=D:\ARM_UPDATES\MOVE_NSI_LCK.TXT

REM ��� 䠩�� ��⮪��� ��ନ஢����� 䠩��� ��� ��।��
set LOGFILE=D:\ARM_UPDATES\log_makensi.txt

REM ���� � ࠡ�祬� ��⠫��� � ����⠬�
set NSIDISK=D:
set NSIPATH=\ARM_UPDATES\_Replication
set NSIFONDPATH=Y:\#Volhov\ARM_UPDATES\_Replication\MRS_SF

REM ��ப� ��� �᪫�祭�� �� ���-䠩�� ��譥� ���ଠ樨
set NSISTRING=_Replication

REM =============================================
REM ������� 䠩� �����஢�� ����୮�� ����᪠
if exist %LOCKFILE% goto LOCK
echo. > %LOCKFILE%
echo File %LOCKFILE% locked!  >> %LOCKFILE%
date /t >>  %LOCKFILE%
time /t >> %LOCKFILE%

REM ������砥� ��� ����㠫쭮�� FTP-�ࢥ�
FTPUSE V: 10.9.14.9 2fwy5jpy /USER:miks 
v:
cd \Mrs\ORACLE
if not exist v:\Mrs\ORACLE goto NOFTP

REM =============================================
REM ���室�� � ࠡ�稩 ��⠫��
%NSIDISK%
cd %NSIPATH%

REM ��७�ᨬ MRS-䠩�� �� ��� ����㠫쭮�� FTP-�ࢥ�
REM ��ନ�㥬 ᯨ᮪ ᤥ������ 䠩��� mrs (��� ��� 1251 ��� ������� DIR)
chcp 1251
del /q %LOGFILE%
@echo : >  %LOGFILE%
@echo. >>  %LOGFILE%

ECHO ��७�ᨬ ��� ��� ���������樨 ����⢠
REM =============================================
ECHO ��७�ᨬ ���, ��ॣ��.SQL, ��ॣ��.Oracle � .\ORACLE 
dir     .\ORACLE\*.* | grep -i ora >> %LOGFILE%
move /Y .\ORACLE\*.*    v:\Mrs\ORACLE
dir v:\Mrs\ORACLE\*$ORA%LPU%(*.*      | grep -i ora  >> %LOGFILE%
ECHO.

ECHO ��७�ᨬ ASBU � ASBU - ��⮬. ���. ��⭮�� ���
dir     .\ASBU\*ASBU99$*ORA%LPU%*.* | grep -i ASBU >> %LOGFILE%
move /Y .\ASBU\*ASBU99$*ORA%LPU%*.*    v:\Mrs\ASBU
dir v:\Mrs\ASBU\*ASBU99$*ORA%LPU%*.*  | grep -i ASBU >> %LOGFILE%
ECHO.

ECHO ��७�ᨬ ��� - �������� � MRS_Dogovor
dir     .\MRS_Dogovor\DGD*(%LPU%)*.* | grep -i mrs >> %LOGFILE%
move /Y .\MRS_Dogovor\DGD*(%LPU%)*.*   v:\Mrs\MRS_Dogovor
dir v:\Mrs\MRS_Dogovor\DGD*(%LPU%)*.* | grep -i mrs  >> %LOGFILE%
ECHO.

ECHO ��७�ᨬ �������� ��� ��㣨� 䨫����� � ���������樨 � MRS_NAKL
dir     .\MRS_NAKL\BNZ*(%LPU%)*	.* | grep -i mrs >> %LOGFILE%
move /Y .\MRS_NAKL\BNZ*(%LPU%)*.*   v:\Mrs\MRS_NAKL
dir v:\Mrs\MRS_NAKL\BNZ*(%LPU%)*.*    | grep -i mrs  >> %LOGFILE%
ECHO.

ECHO ��७�ᨬ ����� ���㯮� � �த�� � MRS_SF (�� �ନ��� ��壠��� �� ����� ���-䠪����)
if not exist %NSIFONDPATH% goto NOFOND
dir %NSIFONDPATH%\SFB99(%LPU%)*.* | grep -i mrs >> %LOGFILE%
move /Y %NSIFONDPATH%\SFB99(%LPU%)*.*  v:\Mrs\MRS_SF
dir v:\Mrs\MRS_SF\SFB99(%LPU%)*.*     | grep -i mrs  >> %LOGFILE%
ECHO.

ECHO ��७�ᨬ ���㬥��� ��� �� (�᭮���� � ��������. ��⮪)
REM ��⠭������ 01.06.2011, ⠪ ��� �� ࠡ�⠥� � 28.10.2010 � ���. ��⮪ � 22.10.2011
rem dir     .\XI\*.* | grep -i xi >> %LOGFILE%
rem move /Y .\XI\*.*    v:\Mrs\XI
REM dir v:\Mrs\XI\*MS%LPU%*.*             | grep -i xi   >> %LOGFILE%
rem ECHO.

chcp 866                                 
REM ����� �����஢�� ����᪠ �⮣� ���������� 䠩��
del /F /Q %LOCKFILE%

goto DONE

:NOFOND   
chcp 866                      
REM ����� �����஢�� ����᪠ �⮣� ���������� 䠩��
del /F /Q %LOCKFILE%
set BODY=��७�c 䠩��� ���� �믮���� �� ��稭� ������㯭��� ��⠫��� %NSIFONDPATH% ������� ������祭�� � ���� �ࢥ� vhv-mics-01!!!

:NOFTP
REM =============================================
REM ��᫠�� ���䠩� ������㯥� ftp
REM ���室�� � ࠡ�稩 ��⠫��
%NSIDISK%
cd %NSIPATH%
cd ..

zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"Not Executed! %THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" %BODY%

echo %BODY%

goto END


:LOCK
REM =============================================
REM ��᫠�� ᮮ�饭�� � �����襩 ����窥 �� ����������� ��
REM ���室�� � ࠡ�稩 ��⠫��
%NSIDISK%
cd %NSIPATH%
cd ..

echo LOCK

zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" %BODYSENDLOCK% %%PUT="%LOCKFILE%"
rem charset=CP-866

REM ������ ����� "echo 0x007" (�⠭��p�� ���)
REM echo 

goto END

:DONE

REM =============================================
REM ��᫠�� ���䠩� � ��६�饭��� 䠩���
%NSIDISK%
cd %NSIPATH%
cd ..
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" %BODYSEND%%%PUT="%LOGFILE%"


:END
REM �⪫�砥� ��� ����㠫쭮�� FTP-�ࢥ�
FTPUSE V: /delete 

