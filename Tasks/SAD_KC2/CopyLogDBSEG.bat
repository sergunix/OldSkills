@echo off
REM --------------------------------------------------------------------------
REM   ��������� ���� ���:
REM
REM   �����������  log-������ ���� ������ � ������� ��� ��
REM   ��������� ��� �������� ����������.
REM
REM   (�) ���������� ����� ������ ��� "������� �������� �����-���������"
REM                                2017
REM --------------------------------------------------------------------------

chcp 1251

REM ������������� ��������� ����� ����������
setlocal

REM ������� ������� � ���� � ������ Rtap
set WORKDISK=R:
set WORKPATH=RtapEnvs\LenVlh\log


REM ��� ����� ������
set BDFILELOG=BDSEGLOG

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
set     THEME=CopyDBSEGLOG: �� � ������� ��� �����������
set THEME_ERR=CopyDBSEGLOG: ��� ����������� � ������� ���

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
rename %BDFILELOG%09.* %BDFILELOG%10.*
rename %BDFILELOG%08.* %BDFILELOG%09.*
rename %BDFILELOG%07.* %BDFILELOG%08.*
rename %BDFILELOG%06.* %BDFILELOG%07.*
rename %BDFILELOG%05.* %BDFILELOG%06.*
rename %BDFILELOG%04.* %BDFILELOG%05.*
rename %BDFILELOG%03.* %BDFILELOG%04.*
rename %BDFILELOG%02.* %BDFILELOG%03.*
rename %BDFILELOG%01.* %BDFILELOG%02.*
rename   %BDFILELOG%.7z %BDFILELOG%01.*

REM ������������� ���� ������ ���
REM -ssw ��������� ��������� ������������ �����

"C:\Program Files\7-Zip\"7z.exe a -ssw -mx5 -m0=LZMA2 %BDFILELOG%.7z %WORKDISK%\%WORKPATH%\ 

REM �������� ������ ������� �����
del %BDFILELOG%10.*

REM ������� �� ��������� 1251
chcp 1251

REM ��������� ���������� � ������ ������
dir | find /I "%BDFILELOG%" > ..\%BDFILELOG%.log


REM �������� ��������� � ����������� ������
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" %%PUT="..\%BDFILE%.log" 

net use /delete %WORKDISK%

:END                                        