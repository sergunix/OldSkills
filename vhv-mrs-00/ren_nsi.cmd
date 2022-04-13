@echo off
REM []-------------------------------------------------------------------------
REM    �������� 䠩� ���:
REM    ��२��������� ����砭��� 䠩��� � FTP-�ࢥ� � *.yes;
REM
REM     (C) 䨫��� ��� "����஬ �࠭ᣠ� �����-������" - ���客᪮� �����
REM                               2002-2013
REM ---------------------------------------------------------------------------

REM ��⠭�������� ������� ����� ��६�����
setlocal

REM ��� ��� �� �����䨪�樨 ����
set LPU=13

REM ����稩 ��⠫��
set WORKDISK=D:
set WORKPATH=\ARM_UPDATES\_Replication

REM ���� SMTP �ࢥ� ���஭��� �����
set SMTP=10.9.108.105

REM �����⥫� ���� � ����㧪� 䠩���
set MAIL_TO=sysadmin@vhv.ltg.gazprom.ru

REM ��ࠢ�⥫� ����
set MAIL_FROM=ren_nsi.cmd mics@vhv.ltg.gazprom.ru

REM ���� ᮮ�饭��
set REN_THEME=��२��������� ����砭��� 䠩��� � FTP-�ࢥ� � *.yes

REM ��� 䠩�� ��⮪��� ��२���������� 䠩��� � YES ��� ��।��
set REN_LOGFILE=D:\ARM_UPDATES\log_renamensi.txt

REM ���� ᮮ�饭��
set REN_BODY=��२��������� �� �뫮 �믮����� � .YES, �� ��稭� ������㯭��� \Mrs\MRS_BACK �� FTP-�ࢥ�!

REM ����㠫�� ��� ftp �ࢥ�
set VDISK=V:

REM []--- ��ନ�㥬 �� ������� Date ��६����� �� �믮������. 10-11-2010 ������ �� ����� ������� 
set HOUR=%time:~0,2%

REM =============================================
REM ����砥� ��, �� �� ����祭�, �᫨ �����⨫� �� � 22 ��!
REM � 22 ��� �맮� wgetnsi.cmd �⬥�塞 � 08.10.2009, 
REM          ⠪ ��� ��२��������� ����᪠�� �� getnsi.cmd, 
REM          ����� ᠬ ��뢠�� wgetnsi.cmd ᭠砫� (�⮡� �� �뫮 ४��ᨨ)

echo  ����砥� ��, �� �� ����祭� �� ����, �᫨ �����⨫� �� � 22 ���!
if NOT %HOUR% == 22 call wgetnsi.cmd 

REM ������砥� ��� ����㠫쭮�� FTP-�ࢥ�
rem FTPUSE %VDISK% mics.ltg.gazprom.ru 2fwy5jpy /USER:miks 
runas /savecred /user:ladmin D:\Arm_Updates\ConnectFTP_MRS.cmd
sleep 10
%VDISK%
cd \Mrs\ORACLE
if not exist %VDISK%\Mrs\ORACLE goto NOFTP

REM ����塞 ��२��������� ࠭�� 䠩��
del /Q %VDISK%\Mrs\M2O00101$ORA%LPU%*.*YES
del /Q %VDISK%\Mrs\MRS_NAKL\BNZ%LPU%*.*YES
del /Q %VDISK%\Mrs\MRS_Dogovor\DGD%LPU%*.*YES
del /Q %VDISK%\Mrs\MRS_SYNC_ORACLE\%LPU%*.*YES

REM ���室�� � ࠡ�稩 ��⠫��
%WORKDISK%
cd %WORKPATH%
cd ..

REM �뤠�� "���ଠ�� � ��२���������� 䠩��� �� FTP �ࢥ�:"
echo ���������� � ��������������� ������ �� FTP-�������: > %REN_LOGFILE%
echo. >> %REN_LOGFILE%
REM (��� ��� 1251 ��� ������� DIR)
chcp 1251

REM ��२�����뢠�� �� ��᪥ ����㠫쭮�� FTP-�ࢥ�
rename %VDISK%\Mrs\M2O00101$ORA%LPU%*.mrs   M2O00101$ORA%LPU%*.YES
rename %VDISK%\Mrs\M2O00101$ORA%LPU%*.zip   M2O00101$ORA%LPU%*.ZIPYES
rename %VDISK%\Mrs\M2O00101$ORA%LPU%*.rar   M2O00101$ORA%LPU%*.RARYES
dir    %VDISK%\Mrs\M2O00101$ORA%LPU%*.*YES | grep -i YES >> %REN_LOGFILE%
rename %VDISK%\Mrs\MRS_NAKL\BNZ%LPU%*.mrs   BNZ%LPU%*.YES
rename %VDISK%\Mrs\MRS_NAKL\BNZ%LPU%*.zip   BNZ%LPU%*.ZIPYES
rename %VDISK%\Mrs\MRS_NAKL\BNZ%LPU%*.rar   BNZ%LPU%*.RARYES
dir    %VDISK%\Mrs\MRS_NAKL\BNZ%LPU%*.*YES | grep -i YES >> %REN_LOGFILE%
rename %VDISK%\Mrs\MRS_Dogovor\DGD%LPU%*.mrs DGD%LPU%*.YES
rename %VDISK%\Mrs\MRS_Dogovor\DGD%LPU%*.zip DGD%LPU%*.ZIPYES
rename %VDISK%\Mrs\MRS_Dogovor\DGD%LPU%*.rar DGD%LPU%*.RARYES
dir    %VDISK%\Mrs\MRS_Dogovor\DGD%LPU%*.*YES | grep -i YES >> %REN_LOGFILE%
rename %VDISK%\Mrs\MRS_SYNC_ORACLE\%LPU%*.mrs %LPU%*.YES
rename %VDISK%\Mrs\MRS_SYNC_ORACLE\%LPU%*.zip %LPU%*.ZIPYES
rename %VDISK%\Mrs\MRS_SYNC_ORACLE\%LPU%*.rar %LPU%*.RARYES
dir    %VDISK%\Mrs\MRS_SYNC_ORACLE\%LPU%*.*YES | grep -i YES >> %REN_LOGFILE%

chcp 866

REM ��᫠�� ���ଠ�� � ��२���������� 䠩��� �� ��� �ࢥ�
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%REN_THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" %%PUT="%REN_LOGFILE%"

REM =============================================
REM ����塞 �� �ਭ��� ZIP � RAR ������� 䠩��
REM ���室�� � ࠡ�稩 ��⠫��
%WORKDISK%
cd %WORKPATH%

del /F /Q *%LPU%*.zip *%LPU%*.rar

REM �뫮 � MSSQL
REM cd .\MRS_FOND
REM rem rar e -y *.rar
REM !!! �� 㤠���� �ਭ��� ��娢� 䮭���, ⠪ ��� ��� ����� �����
REM �� ��� �ࢥ� ���� � ���� ������� ����� ࠧ
REM del /F /Q *.rar *.zip
REM cd ..

cd .\MRS_NAKL
del /F /Q *%LPU%*.zip *%LPU%*.rar
cd ..

cd .\MRS_Dogovor
del /F /Q *%LPU%*.zip *%LPU%*.rar
cd ..

goto DONE

:NOFTP
REM =============================================
REM ���室�� � ࠡ�稩 ��⠫��
%WORKDISK%
cd %WORKPATH%
cd ..

REM ��᫠�� ���䠩�
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%REN_THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" %REN_BODY%

echo %REN_BODY% 


:DONE
REM �⪫�砥� ��� ����㠫쭮�� FTP-�ࢥ�
rem FTPUSE %VDISK% /delete
runas /savecred /user:ladmin D:\Arm_Updates\DisconnectFTP_MRS.cmd
