@echo off
REM --------------------------------------------------------------------------
REM   ��������� ���� ���:
REM
REM   ����������� ���� ������ � ������� ��� ��
REM   ��������� ��� �������� ����������.
REM
REM   (�) ���������� ����� ������ ��� "������� �������� �����-���������"
REM                                2009
REM --------------------------------------------------------------------------

chcp 1251

REM ������������� ��������� ����� ����������
setlocal

REM ������� ������� � ���� � ������ Rtap
set WORKDISK=R:
set WORKPATH0=RtapEnvs\LenVlh
set WORKPATH1=ACCOL

REM ��� ����� ������
set BDFILE=BDSEG

REM ��� ������� �� Rtap � ��� ����� � ������� Rtap
set ADRSERV=10.9.97.224
set DISKSERV=R$
   
REM ����� ������� ����������� �����
set SMTP=10.9.108.105

REM ���������� ������ � ������ ������
set MAIL_TO=sysadmin@vhv.ltg.gazprom.ru

REM ����������� ������
set MAIL_FROM=SEG@vhv.ltg.gazprom.ru

REM ���� ���������
set     THEME=CopyDBSEG: �� � ������� ��� �����������
set THEME_ERR=CopyDBSEG: ��� ����������� � ������� ���

REM ��������� � ������� �������
D:
cd \Backup\Archive_DB

REM �������� ����������� �������� ��� �������������
if exist %WORKDISK%\%WORKPATH% goto OK
   net use %WORKDISK% \\%ADRSERV%\%DISKSERV%
      if not exist %WORKDISK%\%WORKPATH% ( 
        zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME_ERR%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251"
        exit 1
       )         

:OK


REM ��������������� ������ ��� �� ����������� ��������
rename %BDFILE%09.* %BDFILE%10.*
rename %BDFILE%08.* %BDFILE%09.*
rename %BDFILE%07.* %BDFILE%08.*
rename %BDFILE%06.* %BDFILE%07.*
rename %BDFILE%05.* %BDFILE%06.*
rename %BDFILE%04.* %BDFILE%05.*
rename %BDFILE%03.* %BDFILE%04.*
rename %BDFILE%02.* %BDFILE%03.*
rename %BDFILE%01.* %BDFILE%02.*
rename %BDFILE%.7z  %BDFILE%01.*

REM ������������� ���� ������ ���
REM -ssw ��������� ��������� ������������ �����

"C:\Program Files\7-Zip\"7z.exe a -ssw -mx5 -m0=LZMA2 -xr!log %BDFILE%.7z %WORKDISK%\%WORKPATH0%\ %WORKDISK%\%WORKPATH1%\

REM �������� ������ ������� �����
del %BDFILE%10.*

REM ������� �� ��������� 1251
REM chcp 1251

REM ��������� ���������� � ������ ������
dir | find /I "%BDFILE%" > ..\%BDFILE%.log


REM �������� ��������� � ����������� ������
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" %%PUT="..\%BDFILE%.log" 

net use /delete %WORKDISK%

:END                                        