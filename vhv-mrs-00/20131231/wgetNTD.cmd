@echo off
REM []-------------------------------------------------------------------------
REM    �������� 䠩� ���:
REM    ����窨 䠩��� ���஭��� ���� ��� � ���;
REM    �����᭮ �ਪ��� �125 �� 25.03.2010
REM    C ���쬮� � �ந��������� ����㧪� 䠩���.
REM
REM    (C) 䨫��� ��� "����஬ �࠭ᣠ� �����-������" 
REM                                   - ���客᪮� �����, 2010
REM ---------------------------------------------------------------------------

REM =============================================
REM ����稩 ��⠫��
set WORKDISK=D:
set WORKPATH=\ARM_UPDATES\���

REM ���� �ࢥ� ����������
set NAVSRV="ftp://volhov:wohv9hxz@10.9.14.9/aup/optima"

REM ��� 䠩�� ��⮪��� ����窨
set LOGFILE=log_ntd.txt

REM ���� SMTP �ࢥ� ���஭��� �����
set SMTP=vhv-dc-01.corp.it.ltg.gazprom.ru

REM �����⥫� ���� � ����㧪� 䠩���
set MAIL_TO=sysadmin@vhv.ltg.gazprom.ru

REM ��ࠢ�⥫� ����
set MAIL_FROM=wgetNTD.cmd@vhv.ltg.gazprom.ru
 
REM ���� ᮮ�饭��
set THEME=�����஭��� ���� ��� � ���

REM �� ������� 
set FILES=volhov


REM =============================================
REM ��ନ�㥬 �� ������� CD ��६���� ⥪�饣� ��᪠ � ���
cd > %LOGFILE%
for /f "tokens=1 delims=\" %%i in (%LOGFILE%) do set CURDISK=%%i
for /f "tokens=2 delims=:" %%i in (%LOGFILE%) do set CURPATH=%%i
del /Q /F %LOGFILE%

REM ���室�� � ࠡ�稩 ��⠫��
%WORKDISK%
cd %WORKPATH%

REM =============================================
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME% ����饭� �� ������ �� �������� %COMPUTERNAME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" %THEME% ����饭� �� ������ � �������� %COMPUTERNAME%
wget %NAVSRV% -P. -N -r --continue --no-remove-listing -nH -R.* -X/aup/optima/.kde* --cut-dirs=2 -o..\%LOGFILE% 
REM �࠭� � 03.04.2013 ⠪ ��� ����� ���-�� �⠫ 50���� --limit-rate=131072
REM =============================================
REM   �뤥���� �� ��⮪��� ����� � ����砭��� 䠩���
REM �᫨ ���ଠ樨 � ����砭��� 䠩��� ���, � ��祣� ����� �� ������
GREP saved ..\%LOGFILE% | GREP -v .listing  > ..\SAVE%LOGFILE%

if errorlevel 2 goto ERR2
if errorlevel 1 goto ERR1
if errorlevel 0 goto ERR0
goto END


:ERR2
REM ���� �� ������ ��� ������� GREP 
goto END

:ERR1
REM �� 㤠���� ��祣� ���� �� ������� GREP
goto END

:ERR0
REM ���ଠ�� � ����砭��� 䠩��� ����!

REM =============================================
REM ��᫠�� ���䠩� � �ந��������� ����窥 �� ����������� ��
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME% ����砭�" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" %%PUT="..\SAVE%LOGFILE%" $incl "..\%LOGFILE%"

REM []--- ����஭����� 䠩��� ��� � ���.����� \��� � �� FTP-�ࢥ� /aup/optima
REM       ��������� ���� --no-remove-listing � ������� wget ��� ��࠭���� 䠩�� ���⨭��
REM       ��ନ�㥬 ᯨ᮪ 䠩��� �� ��� �ࢥ�
if not exist .listing goto NOLISTING

REM �뤥�塞 �� 䠩�� .listing ����� ����砭��� 䠩��� (��稭����� � 57 ᨬ���� ���筮)
REM cut.exe - unix �⨫�� ����஢����� ��� Win32
REM ���� 2 ��ப� ���⨭�� 㤠����, ⠪ ��� ⠬ ��⠫��� . � ..
more +2 .listing > ..\%LOGFILE%
echo. > ..\SAVE%LOGFILE%
for /f "tokens=2 delims=:" %%i in (..\%LOGFILE%) do echo %%i  >> ..\SAVE%LOGFILE%
type ..\SAVE%LOGFILE% | cut.exe -c4- > ..\%LOGFILE%

rem more +2 .listing | cut.exe -c57- > ..\%LOGFILE%

REM ��४����㥬 䠩� �� Win1251 � 866, ⠪ ��� wget ��� .listing � 1251,
REM � rar ࠡ�⠥� �� ��������� ��ப� � 866
..\dcd  /on 1251,dos ..\%LOGFILE%
del /Q /F ..\%LOGFILE%.bak

REM       ��娢�஢���� � �᪫�祭��� �� 䠩���, �� ����� �� FTP
del /Q /F .listing
rar m -y -m0 -x@..\%LOGFILE% ���_del.rar *.*
echo. > ..\SAVE%LOGFILE%
rar lb ���_del.rar >> ..\SAVE%LOGFILE%
                  
REM ��४����㥬 䠩� �� 866 � Win1251
..\dcd  /on dos,1251 ..\SAVE%LOGFILE%
echo. >> ..\SAVE%LOGFILE%
echo ----------------------------------------------------------- >> ..\SAVE%LOGFILE%
del /Q /F ..\SAVE%LOGFILE%.bak

REM ��᫠�� ���䠩� � 㤠�塞�� �������� 䠩��� ���, ������ 㦥 ��� �� ���
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME% ᨭ�஭���஢���" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" �� ��४�ਨ %WORKDISK%%WORKPATH% �뫨 �����⮢���� ��� 㤠����� 䠩��, ���������騥 �� ��� �ࢥ�: " %%PUT="../SAVE%LOGFILE%" ������ ������ 䠩� ���_del.rar! 

REM ��娢�஢���� 䠩�� ��� �㤥� 㤠���� �ࠧ�
REM del /Q /F ���_del.rar

goto END

:NOLISTING
REM []--- ��ࠢ�� ᮮ�饭�� �� ������⢨� 䠩�� .listing � ᯨ᪮� 䠩��� ��� �� FTP-�ࢥ�
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME% ��� ᯨ᪠ 䠩��� � ��� �ࢥ�" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" ��������! ���᮪ ��娢�� � ��� � ���-�ࢥ� �� �� �����⮢���, ᨭ�஭����� ��� 䠩��� �� �믮�����.
goto END

:END
REM ���室�� � ⥪�騩 ��⠫��
%CURDISK%
cd %CURPATH%
