@echo off
REM []-------------------------------------------------------------------------
REM    �������� 䠩� ���:
REM    �������� ���쬠 �� ���஭��� ����� � �⤥� ���஢
REM    � ������ ࠡ�⭨��� �� ࠡ��� ����� (���쭨��, �ண�)
REM    poteri.cmd param1 param2 param3, ���
REM   		param1 - ��� �㦡�, ����� �ନ��� ᮮ�饭�� � ������
REM		param2 - ���� �.����� �㦡�, ��� ����祭�� ��� �� ᥡ�	
REM		param3 - ��⠫�� � 䠩���� � ���ଠ樥� � ������ � �㦡��		
REM                      (��� ��ᮩ �� ���� ���)
REM		param4 - ��� 䠩�� � ���ଠ樥� � ������ � �㦡�
REM
REM (C) 䨫��� ��� "����஬ �࠭ᣠ� �����-������" - ���客᪮� �����, 2008.
REM ---------------------------------------------------------------------------




REM =============================================
REM ��� �㦡�, ����� �ନ��� ᮮ�饭�� � ������
set SERVICE=%1

REM �����⥫� ����� � �㦡�
set SMAIL=%2

REM ���� � 䠩�� � ���ଠ樥� � ������ � �㦡� 
set FPATH=%3

REM ��� 䠩�� � ���ଠ樥� � ������ � �㦡� 
set FILE=%4

REM ���� �⪫�祭�� ��ࠢ�� ���ࠬ
set FLAG=%5

REM ��� 䠩�� � ⥪�饩 ��⮩ 
set DFILE=curdate.txt

REM ���� SMTP �ࢥ� ���஭��� �����
set SMTP=10.9.108.105

REM �����⥫� ����� � �⤥�� ���஢
set MAIL_TO=AllHR-ManagersBranch@vhv.ltg.gazprom.ru 

REM �����⥫� ����� ��ࠢ�㭪� ��� ��� ���쭨���
set MAIL_MEDIC=VHV_medic_users@vhv.ltg.gazprom.ru

REM �����⥫� ����� � ����ࠢ������ � ࠡ�� ��⥬�
set MAIL_ADM=vhvadmin@vhv.ltg.gazprom.ru

REM =============================================
REM ��ନ�㥬 �� ������� Date ��६���� ⥪�饣� ��� � �����
REM ���� ⥪�饣� ��� � ����� ��।���� 22-12-2021 ����� �.�.
 rem date  /T > %DFILE%
 rem for /f "tokens=1 delims=." %%i in (%DFILE%) do set DAY=%%i
 rem for /f "tokens=2 delims=." %%i in (%DFILE%) do set MONTH=%%i
 rem for /f "tokens=3 delims=." %%i in (%DFILE%) do set YEAR=%%i
set DAY=%DATE:~7,2%
set MONTH=%DATE:~4,2%
set YEAR=%DATE:~-4%

REM =============================================
REM ��ନ�㥬 �� ������� Dir ��६���� �६��� � ��� ��� 䠩�� � ������
REM ������� find �� ���⠢�� Windows ����� �᪠�� ���᪨� ᫮�� � 䠩��
REM ��� � grep.com �� ����� Turbo� 3.0, ��⠫�� grep.exe - �� �����
REM ��ਠ�� �१ ������ �ணࠬ�� �� Turbo� 3.0:
REM                  grep.com -i -o+ %FILE% > %DFILE%

if exist %FPATH%\%FILE% goto FILEEXIST
REM =============================================
REM ��᫠�� 䠩� � ������㯭��� 䠩�� � ������
zerat smtphost:"%SMTP%" from:"%SMAIL%" to:"%MAIL_ADM%" subject:"ALERT! ���� �� %SERVICE% �� %DAY%.%MONTH%.%YEAR% - 䠩� ������㯥�!" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" ���� � ����묨 � ������ �� ��� %FPATH%\%FILE% ������㯥�!!!
goto END

:FILEEXIST
dir %FPATH%\%FILE% | find /I "%FILE%" > %DFILE%
for /f "tokens=1 delims= " %%i in (%DFILE%) do set FDATE=%%i
for /f "tokens=2 delims= " %%i in (%DFILE%) do set FTIME=%%i

rem �८�ࠧ������ ���� � ��/��/���� 11-01-2022 ����� �.�.
set FDATE=%FDATE:~3,2%/%FDATE:~0,2%/%FDATE:~-4%

REM =============================================
REM ��᫠�� 䠩�
IF NOT "%FLAG%"=="NOTFORKADR" zerat smtphost:%SMTP% from:%SMAIL% to:%MAIL_TO% subject:"���� �� %SERVICE% �� %DAY%.%MONTH%.%YEAR%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" ���ଠ�� ���⮢�ୠ �� %FTIME% �� %FDATE%  %%PUT='%FPATH%\%FILE%'
zerat smtphost:%SMTP% from:%SMAIL% to:%MAIL_MEDIC% subject:"���� �� %SERVICE% �� %DAY%.%MONTH%.%YEAR%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" ���ଠ�� ���⮢�ୠ �� %FTIME% �� %FDATE%  %%PUT='%FPATH%\%FILE%'
zerat smtphost:%SMTP% from:%SMAIL% to:%SMAIL%   subject:"���� �� %SERVICE% �� %DAY%.%MONTH%.%YEAR%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" ���ଠ�� ���⮢�ୠ �� %FTIME% �� %FDATE%  %%PUT='%FPATH%\%FILE%'

REM ������� 䠩� � ⥪�饩 ��⮩
del /F /Q %DFILE%

REM � ����� ��⠢��� ������� ��� ���४��. ����\�६��� 䠩�� �� ᫥�. ����
rem touch -t08:00 -d��� ������ ���� �� �����? %FILE%

:END


