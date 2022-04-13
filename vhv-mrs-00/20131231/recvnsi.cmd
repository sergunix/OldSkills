@echo off
REM []-------------------------------------------------------------------------
REM    �������� 䠩� ���:
REM    �ਥ�� ����⮢ 䠩��� ��� �� ������� mrsOra.exe � mrsDocOra.exe
REM
REM     (C) 䨫��� ��� "����஬ �࠭ᣠ� �����-������" - ���客᪮� �����
REM                               2002-2011
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
set MAIL_FROM=mics@vhv.ltg.gazprom.ru

REM ��� 䠩�� ��⮪��� ��ନ஢����� 䠩��� ��� ��।��
set LOGFILE=log_recvnsi.txt

REM ���� ᮮ�饭��
set THEME=����� MRS - �訡�� ��� �१ recvnsi.cmd
set THEMEOK=�����襭 �ਥ� ����砭��� ����⮢ 䠩��� ���

REM ���� ᮮ�饭��
set BODY="���᮪ �� �ਭ���� 䠩��� MRS"

REM ����饭�� � ����୮� ����᪥ ⮣� �� ��⭨��
set BODYSENDLOCK="��������! �� �����訫�� ���� ����� recvnsi.cmd, ��������, �訡�� � �ਥ�� ����� ���!"

REM ���� � ��⠫��� � ����⠬� ���
set NSIDISK=D:
set NSIPATH=\ARM_UPDATES

REM ��� 䠩�� �����஢��
set LOCKFILE=%NSIDISK%%NSIPATH%\RECVNSI_LCK.TXT

REM ��⠫�� � �ᯮ��塞묨 䠩����
set RUNDISK=c:
set RUNPATH=\Apps\Mics

REM ��⠫�� � �ᯮ��塞묨 䠩���� � ��
set NETDISK=S:
set NETPATH=\mics\Oracle

REM �����᪠� ��६�����
set bool=0
ECHO []----- �ਥ� ����⮢ 䠩��� ��� �� ������� mrsOra.exe � mrsDocOra.exe

REM =============================================
REM �஢�ઠ ����㯭��� ��⥬� ���� �����쭮 � � ��
if not exist %RUNDISK%%RUNPATH%\mrsOra.exe (
   if not exist %NETDISK%%NETPATH%\mrsOra.exe goto NOMICS )
if not exist %RUNDISK%%RUNPATH%\mrsDocOra.exe (
   if not exist %NETDISK%%NETPATH%\mrsDocOra.exe goto NOMICS )
if not exist %RUNDISK%%RUNPATH%\info.key   goto NOMICS
if not exist %NETDISK%%NETPATH%\mrsOra.exe    (zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" ��������! ����� ���� mrsOra.exe ������㯥� � ��, �������� �ਥ� ����⮢ ��� �믮������ � ���ॢ訬 ���㫥�!)
if not exist %NETDISK%%NETPATH%\mrsDocOra.exe (zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" ��������! ����� ���� mrsDocOra.exe ������㯥� � ��, �������� �ਥ� ����⮢ ��� �믮������ � ���ॢ訬 ���㫥�!)

REM �஢�ઠ ����㯭��� ��⠫��� � ����⠬� ���, �⮡� �뫮 �㤠 �뫮���� ������ ���  
if not exist %NSIDISK%%NSIPATH% goto NO_Y

REM �ࠢ������ ��������� �� 䠩� mrsOra.exe � mrsDocOra.exe �� �⥢�� �����
echo N|comp.exe %RUNDISK%%RUNPATH%\mrsOra.exe %NETDISK%%NETPATH%\mrsOra.exe 1>nul 2>nul && set bool=1
if %bool%==0 (copy /Z /Y %NETDISK%%NETPATH%\mrsOra.exe %RUNDISK%%RUNPATH%\mrsOra.exe)
echo N|comp.exe %RUNDISK%%RUNPATH%\mrsDocOra.exe %NETDISK%%NETPATH%\mrsDocOra.exe 1>nul 2>nul && set bool=1
if %bool%==0 (copy /Z /Y %NETDISK%%NETPATH%\mrsDocOra.exe %RUNDISK%%RUNPATH%\mrsDocOra.exe)

REM �஢�ઠ ����㯭��� ���� ������ ��� �믮������ �ணࠬ�� (������祭�� � ��室)
REM ����塞 䠩� ��⮪��� ������祭��, ��ନ஢���� sqlplus.exe ࠭��
if not exist sqlnet.log goto NEXT1
del /F /Q sqlnet.log
:NEXT1
echo exit | sqlplus.exe -L "mics_%LPU%/1810vbrc_1313@micso%LPU%" 
if errorlevel 2 goto ERR2
if errorlevel 1 goto ERR1
if errorlevel 0 goto OK
:ERR2
:ERR1
REM ��᫠�� ��� � ������㯭��� ���� ������ ����
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" ��������! ���� ������ ���� Oracle ������㯭�, ��� ����⮢ 䠩��� ��� �� �� �믮����. ��� �஢�ન=%errorlevel%. %%PUT="sqlnet.log"
goto END

:OK
REM ������� 䠩� �����஢�� ����୮�� ����᪠
if exist %LOCKFILE% goto LOCK
echo. > %LOCKFILE%
echo File %LOCKFILE% locked!  >> %LOCKFILE%
date /t >>  %LOCKFILE% 
time /t >> %LOCKFILE% 

REM ����᪠�� ������ �ਥ� 䠩��� mrs
%RUNDISK%%RUNPATH%\mrsOra.exe /Ln /umics_13 /P1810vbrc_1313 /smicso13 /bmics_13 /TNSI_RECV
sleep.EXE 2
%RUNDISK%%RUNPATH%\mrsDocOra.exe /Ln /umics_13 /P1810vbrc_1313 /smicso13 /bmics_13 /TNAKL_RECV /TDOG_RECV
sleep.EXE 2

REM ����� �����஢�� ����᪠ �⮣� ���������� 䠩��
del /F /Q %LOCKFILE%

REM ��᫠�� ��� � �����襭�� ����� ��� ����⮢ ��� � �� ����
%NSIDISK%%NSIPATH%\zerat smtphost:%SMTP% from:"%0 %MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEMEOK%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" �� ������� mrsOra.exe � mrsDocOra.exe

REM =============================================
REM �஢��塞, �� �� ������ �ਭ��� �ᯥ譮
%NSIDISK%
cd %NSIPATH%

if exist     .\_Replication\Attention*.err 	       goto MAKELST
if exist     .\_Replication\MRS_Dogovor\Attention*.err goto MAKELST
if not exist .\_Replication\MRS_NAKL\Attention*.err    goto END

:MAKELST
REM ��ନ�㥬 ᯨ᮪ �� �ਭ���� 䠩��� mrs (��� ��� 1251 ��� ������� DIR)
chcp 1251
REM ����塞 ��� ��� ����饭�� ��� � ��২�� 11-11-2010
del /q %LOGFILE%
@echo : >  %LOGFILE%
dir /B %NSIDISK%%NSIPATH%\_Replication 		   | grep -i .err >> %LOGFILE%
dir /B %NSIDISK%%NSIPATH%\_Replication\MRS_Dogovor | grep -i .err >> %LOGFILE%
dir /B %NSIDISK%%NSIPATH%\_Replication\MRS_NAKL    | grep -i .err >> %LOGFILE%
REM dir /B %NSIDISK%%NSIPATH%\_Replication\MRS_FOND    | grep -i .err >> %LOGFILE%
chcp 866

REM ��᫠�� ���䠩� � ���ਭ���� 䠩���
%NSIDISK%%NSIPATH%\zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" %BODY% %%PUT="%LOGFILE%"

REM ������� ��� � �� �ਭ���� ������
del /F /Q %NSIDISK%%NSIPATH%\_Replication\Attention*.err
del /F /Q %NSIDISK%%NSIPATH%\_Replication\MRS_Dogovor\Attention*.err
del /F /Q %NSIDISK%%NSIPATH%\_Replication\MRS_NAKL\Attention*.err
del /F /Q %NSIDISK%%NSIPATH%\_Replication\%LOGFILE%
goto END


:LOCK
REM =============================================
REM ��᫠�� ᮮ�饭�� � �����襩 ����窥 �� ����������� ��
echo LOCK
REM ���室�� � ࠡ�稩 ��⠫�� ���-䠩���
%NSIDISK%
cd %NSIPATH%
zerat smtphost:%SMTP% from:"%0 %MAIL_FROM%" to:"%MAIL_TO%" subject:"�ਥ� 䠩��� ९����権: ����� ����� ���" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" %BODYSENDLOCK% %%PUT="%LOCKFILE%"
goto END

:NOMICS
REM =============================================
REM ��᫠�� ���䠩� � ������㯭��� ����
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" ��������! ���㫨 ���� mrsOra.exe, mrsDocOra.exe ��� info.key ������㯥�, ��� ����⮢ 䠩��� ��� �� �� �믮����. 
goto END

:NO_Y
REM =============================================
REM ��᫠�� ���䠩� � ������㯭��� ��⠫��� � ����⠬� ���
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" ��������! ��⠫�� %NSIDISK%%NSIPATH% ������㯥� (��� �� ������祭 ��� ��� �室� ���짮��⥫� � ����), �ਥ� ����⮢ 䠩��� ��� �� �� �믮����. 
goto END

:END








