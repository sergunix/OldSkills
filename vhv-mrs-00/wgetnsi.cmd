@echo on
REM []-------------------------------------------------------------------------
REM    �������� 䠩� ���:
REM    ����窨 䠩��� ९����権 ��� ��� � ��� ��⮢;
REM    �뤥����� ���� ����砭���  䠩��� �� ��⮪���;
REM    �������� ����砭��� 䠩��� � FTP-�ࢥ�;
REM    �������� ���쬠 �� ���஭��� ����� ��� ���ନ஢����;
REM    � �ந��������� ����㧪� 䠩��� ९����権.
REM
REM     (C) 䨫��� ��� "����஬ �࠭ᣠ� �����-������" - ���客᪮� �����
REM                               2002-2011
REM ---------------------------------------------------------------------------

REM ��⠭�������� ������� ����� ��६�����
setlocal

REM ��� ��� �� �����䨪�樨 ����
set LPU=13

REM FTP ��ࢥ� 
set FTP_SERVER=ftp://miks:2fwy5jpy@10.9.14.9
rem mics.ltg.gazprom.ru

REM ����稩 ��⠫��
set WORKDISK=D:
set WORKPATH=\ARM_UPDATES\_Replication

REM ��� 䠩�� ��⮪��� ����窨
set LOGFILE=log_nsi.txt

REM ���� SMTP �ࢥ� ���஭��� �����
set SMTP=10.9.108.105

REM �����⥫� ���� � ����㧪� 䠩���
set MAIL_TO=sysadmin@vhv.ltg.gazprom.ru

REM ��ࠢ�⥫� ����
set MAIL_FROM=mics@vhv.ltg.gazprom.ru

REM ���� ᮮ�饭��
set THEME=����� ९����権 ��� ��� ����砭�

REM �� ������� %LPU%*.* - ��⠢��� ��� �ਥ�� ����⮢ ᨭ�஭���樨
REM OLD set FILES=%LPU%*.*,*ond*.*,bnz%LPU%*.*,dgd%LPU%*.*,ms%LPU%*.*,MS%LPU%*.*,*OND*.*,BNZ%LPU%*.*,DGD%LPU%*.*,M2O00101$ORA%LPU%*.*,m2o00101$ora%LPU%*.*
set FILES=%LPU%*.*,dgd%LPU%*.*,DGD%LPU%*.*,bnz%LPU%*.*,BNZ%LPU%*.*,M2O00101$ORA%LPU%*.*,m2o00101$ora%LPU%*.*
set FILESYES=*.YES,*.ZIPYES,*.RARYES

REM =============================================
REM ���室�� � ࠡ�稩 ��⠫��
%WORKDISK%
cd %WORKPATH%

REM =============================================
REM ����稢��� 䠩�� ९����権 ��� ��� � ����� LPU (���客-13) � ��� ��⮢
wget.exe %FTP_SERVER%/Mrs/ -P./ -o../%LOGFILE% -N -c -nH -r --cut-dirs=1 -R%FILESYES% -A%FILES% -X/Mrs/MRS_AGGR,/Mrs/MRS_BACK,/Mrs/MRS_SF,/Mrs/ORACLE,/Mrs/XI,/Mrs/GKI,/Mrs/OD,/Mrs/ASBU,/Mrs/MRS_FOND 
REM �࠭� � 03.04.2013 ⠪ ��� ����� ���-�� �⠫ 50���� --limit-rate=131072

REM =============================================
REM ���室�� � ࠡ�稩 ��⠫�� ���-䠩���
cd ..

REM =============================================
REM   �뤥���� �� ��⮪��� ����� � ����砭��� 䠩���
REM �᫨ ���ଠ樨 � ����砭��� 䠩��� ���, � ��祣� ����� �� ������
echo. >  SAVE%LOGFILE%
echo []-------------------------------------------------------------------------- >> SAVE%LOGFILE%
grep.exe saved %LOGFILE% | grep.exe -v .listing  >> SAVE%LOGFILE%

if errorlevel 2 goto ERR2
if errorlevel 1 goto ERR1
if errorlevel 0 goto ERR0
goto END

:ERR2
REM ���� �� ������ ��� ������� grep.exe 
goto END

:ERR1
REM �� 㤠���� ��祣� ���� �� ������� grep.exe >> %LOGFILE%
goto END

:ERR0
REM =============================================
REM ���ଠ�� � ����砭��� 䠩��� ����!
REM =============================================
REM ��᫠�� ���䠩� � �ந��������� ����窥 �� ����������� ��
REM �᫨ �ਭ��� 䠩�� �� ��娢� RAR, ��娢� ZIP


grep.exe -i rar  	    SAVE%LOGFILE%
goto RAR%errorlevel%
:RAR2
:RAR1

grep.exe -i zip	    SAVE%LOGFILE%
goto ZIP%errorlevel%
:ZIP2
:ZIP1

REM �� ����砭��� ��娢��, ��祣� �� �ᯠ���뢠��, ���� �� ���뫪� ���쬠
goto ZERAT

:RAR0
:ZIP0
REM =============================================
REM ���� ��娢�, �ᯠ���뢠�� - ���室�� � ࠡ�稩 ��⠫��
%WORKDISK%
cd %WORKPATH%

unzip -o *.zip
rar e -y *.rar
REM ������� �㤥� �� ��२��������� � YES del /F /Q *.zip *.rar

cd .\MRS_NAKL
unzip -o *.zip
rar e -y *.rar
cd ..

cd .\MRS_Dogovor
unzip -o *.zip
rar e -y *.rar
cd..

:ZERAT
zerat smtphost:%SMTP% from:"%0 %MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" "   ����� ������ � ���������� ������ ������� ���!!!" %%PUT="SAVE%LOGFILE%" $incl "%LOGFILE%"
REM c 24.01.2011 ����� �ਥ�� ��� �믮��塞 � ��⭨�� �� ����窥 �� �ᯥ譮� ����窥
REM ��� ����஫� ����砭�� �ਥ�� ��� ��᫥ �� ����窨 �� ��� �ࢥ�
ECHO =============================================
ECHO ��⠭�������� �ਭ��� � ��� ������ ��� � �� ����
ECHO � ᮧ������ 䠩�� LOCK ��� �।���饭�� ����୮�� ����᪠
ECHO.
REM �᫨ �� ������� 60 ᥪ㭤, � �������� � ����祭��� ����᪠ 
REM c makensiora.cmd, �� ������ �ਢ���� � �����஢���� 䠩��
REM C:\Apps\Mics\info.key
ECHO --- ������� � �祭�� 60 ᥪ㭤 ��� �����襭�� ����� �ନ஢���� MRS ---
ECHO.
sleep.exe 60
recvnsi.cmd


:END
REM ������ ����� "echo 0x007" (�⠭��p�� ���)
REM echo 
