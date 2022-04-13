@echo off
REM --------------------------------------------------------------------------
REM   ��������� ���� ���:
REM
REM   ����������� ���� ������ � ������� ��� ��
REM   ��������� ��� �������� ����������.
REM
REM   (�) ���������� ����� ������ ��� "������� �������� �����-���������"
REM                                2017
REM --------------------------------------------------------------------------

chcp 1251

REM ������������� ��������� ����� ����������
setlocal

REM ������� ������� � ���� � ������ Rtap
set WORKDISK=Z:
set WORKPATH=systserv

REM ��� ����� ������
set BACKUPFILE=ProjectKC2

REM ��� ��� ��2 � ��� ����� � ������� ��2
set ADRSERV=10.9.97.1
set DISKSERV=c$
   
REM ����� ������� ����������� �����
set SMTP=10.9.108.105

REM ���������� ������ � ������ ������
set MAIL_TO=lyum@vhv.ltg.gazprom.ru, serges@vhv.ltg.gazprom.ru 

REM ����������� ������
set MAIL_FROM=SAD_KC2@vhv.ltg.gazprom.ru

REM ���� ���������
set     THEME=CopyKC2: ������ � ��� ��2 ����������
set THEME_ERR=CopyKC2: ��� ����������� � ��� ��2

REM ��������� � ������� �������
D:
cd \Backup\Archive_KC2

REM �������� ����������� �������� ��� �������������
if exist %WORKDISK% goto OK
   net use %WORKDISK% \\%ADRSERV%\%DISKSERV%
      if not exist %WORKDISK%\%WORKPATH% ( 
        zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME_ERR%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251"
        exit 1
       )         

:OK


REM ��������������� ������ ��� �� ����������� ��������
rename %BACKUPFILE%09.* %BACKUPFILE%10.*
rename %BACKUPFILE%08.* %BACKUPFILE%09.*
rename %BACKUPFILE%07.* %BACKUPFILE%08.*
rename %BACKUPFILE%06.* %BACKUPFILE%07.*
rename %BACKUPFILE%05.* %BACKUPFILE%06.*
rename %BACKUPFILE%04.* %BACKUPFILE%05.*
rename %BACKUPFILE%03.* %BACKUPFILE%04.*
rename %BACKUPFILE%02.* %BACKUPFILE%03.*
rename %BACKUPFILE%01.* %BACKUPFILE%02.*
rename %BACKUPFILE%.7z  %BACKUPFILE%01.*

REM ������������� ������� ��2
REM -ssw ��������� ��������� ������������ �����

"C:\Program Files\7-Zip\"7z.exe a -ssw -mx5 -m0=LZMA2 -xr!log %BACKUPFILE%.7z %WORKDISK%\%WORKPATH%\ 

REM �������� ������ ������� �����
del %BACKUPFILE%10.*


REM ��������� ���������� � ������ ������
dir | find /I "%BACKUPFILE%" > ..\%BACKUPFILE%.log


REM �������� ��������� � ����������� ������
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" %%PUT="..\%BACKUPFILE%.log" 

net use /delete %WORKDISK%

:END                                        