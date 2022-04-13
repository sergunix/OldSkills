@echo off
REM []-------------------------------------------------------------------------
REM    �������� 䠩� ���:
REM    �����⮢�� ����⮢ 䠩��� ��� ��� �� Oracle
REM
REM     (C) 䨫��� ��� "����஬ �࠭ᣠ� �����-������" - ���客᪮� �����
REM                               2002-2011
REM ---------------------------------------------------------------------------

REM ��⠭�������� ������� ����� ��६�����
setlocal

REM ��� ��� �� �����䨪�樨 ����
set LPU=13

REM ���� SMTP �ࢥ� ���஭��� �����
set SMTP=10.9.108.105

REM �����⥫� ���� � ����㧪� 䠩���
set MAIL_TO=sysadmin@vhv.ltg.gazprom.ru

REM ��ࠢ�⥫� ����
set MAIL_FROM=mics@vhv.ltg.gazprom.ru

REM ���� ᮮ�饭��
set THEME=����� MRS Oracle �� ��ନ஢���� ��� ��।�� makensiora.cmd

REM ���� � ��⠫��� � ����⠬� ���
set NSIDISK=D:
set NSIPATH=\ARM_UPDATES

REM ��⠫�� � �ᯮ��塞묨 䠩����
set RUNDISK=c:
set RUNPATH=\Apps\mics

REM ��⠫�� � �ᯮ��塞묨 䠩���� � ��
set NETDISK=S:
set NETPATH=\mics\Oracle

REM �����᪠� ��६�����
set bool=0

ECHO []---- �����⮢�a ����⮢ 䠩��� ��� ��� �� Oracle

REM =============================================
REM �஢�ઠ ����㯭��� ��⥬� ���� �����쭮
if not exist %RUNDISK%%RUNPATH%\mrsOra.exe (
   if not exist %NETDISK%%NETPATH%\mrsOra.exe goto NOMICS )
if not exist %RUNDISK%%RUNPATH%\mrsDocOra.exe (
   if not exist %NETDISK%%NETPATH%\mrsDocOra.exe goto NOMICS )
if not exist %RUNDISK%%RUNPATH%\info.key   goto NOMICS
if not exist %NETDISK%%NETPATH%\mrsOra.exe    (zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" ��������! ����� ���� mrsOra.exe    ������㯥� � ��, �������� �ਥ� ����⮢ ��� �믮������ � ���ॢ訬 ���㫥�!)
if not exist %NETDISK%%NETPATH%\mrsDocOra.exe (zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" ��������! ����� ���� mrsDocOra.exe ������㯥� � ��, �������� �ਥ� ����⮢ ��� �믮������ � ���ॢ訬 ���㫥�!)

REM �஢�ઠ ����㯭��� ��⠫��� � ����⠬� ���, �⮡� �뫮 �㤠 �뫮���� ������ ��� 
if not exist %NSIDISK%%NSIPATH% goto NO_Y

REM �ࠢ������ ���������� �� 䠩�� mrsOra.exe � mrsDocOra.exe �� �⥢�� �����
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
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" ��������! ���� ������ ���� Oracle ������㯭�, �ନ஢���� ����⮢ 䠩��� ��� �� �뫮 �믮�����. ��� �஢�ન=%errorlevel%. %%PUT="sqlnet.log"
goto END

:OK
REM =============================================
REM ����᪠�� ����⭮� �ନ஢���� 䠩��� mrs ��� �� Oracle
%RUNDISK%%RUNPATH%\mrsOra.exe /Ln /umics_13 /P1810vbrc_1313 /smicso13 /bmics_13 /TNSI_SEND /TAGGR_SEND /TAGDOG_SEND /TAGMTR_SEND
%RUNDISK%%RUNPATH%\mrsOra.exe /Ln /umics_13 /P1810vbrc_1313 /smicso13 /bmics_13 /TXIADD_SEND /TASBU_SEND 
REM /TXI_SEND -�� ࠡ�⠥� ���� � 25.10.2010 � �� Oracle � MSSQL ⮦� ����� �� ࠡ�⠫

%RUNDISK%%RUNPATH%\mrsDocOra.exe /Ln /umics_13 /P1810vbrc_1313 /smicso13 /bmics_13 /TDOG_SEND /TNAKL_SEND
sleep.EXE 2

goto DONE

:NOMICS
REM =============================================
REM ��᫠�� ���䠩� � ������㯭��� ����
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" ��������! ���㫨 ���� mrsOra.exe, mrsDocOra.exe ��� info.key ������㯥� � ��⠫��� %RUNDISK%%RUNPATH%, �ନ஢���� ����⮢ 䠩��� ��� �� �뫮 �믮�����. 
goto END

:NO_Y
REM =============================================
REM ��᫠�� ���䠩� � ������㯭��� ��⠫��� � ����⠬� ���
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" ��������! ��⠫�� %NSIDISK%%NSIPATH% ������㯥� (��� �� ������祭 ��� ��� �室� ���짮��⥫� � ����), �ନ஢���� ����⮢ 䠩��� ��� �� �뫮 �믮�����. 
goto END


:DONE

