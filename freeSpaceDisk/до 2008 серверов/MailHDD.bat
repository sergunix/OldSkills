@echo off
REM []-------------------------------------------------------------------------
REM    �������� 䠩� ���:
REM    ���뫪� ��ᥬ ����������ࠬ � ��९������� ��᪮�
REM
REM   (C) 䨫��� ��� "����஬ �࠭ᣠ� �����-������"-���客᪮� �����, 2008
REM
REM   ��������: � Windows 2000 ��ꥪ� �����᪨� ��� �� 㬮�砭�� ����祭, � ��ꥪ�
REM   �����᪨� ��� �� 㬮�砭�� �몫�祭. �⮡� ������� ���稪� ��� �����ਭ�� 
REM   �����᪨� ��᪮� ��� ⮬�� �㦭� � ���᮫� �믮����� ������� diskperf -yv � ��१���㧨�� ��⥬�.                            
REM ---------------------------------------------------------------------------

REM ��⠭�������� ������� ����� ��६�����
setlocal

REM   ��� �����饭��
set NOTIFY_NAME=%1
REM   ��� � �६�
set COUNT_DATE=%2
REM   ��� ���稪�
set COUNT_NAME=%3
REM   ����७��� ���祭��
set COUNT_VALUE=%4
REM   �।��쭮� ���祭��
set COUNT_LIMIT=%5
REM   ����⮢�� ᮮ�饭�� (� �� ����ன�� ���稪� ����ᨬ ��� �ࢥ� vhv-���-01)
set COUNT_TEXT=%6

REM ���� SMTP �ࢥ� ���஭��� �����
set SMTP=vhv-dc-01.corp.it.ltg.gazprom.ru

REM �����⥫� ���쬠
set MAIL_TO=sysadmin@vhv.ltg.gazprom.ru

REM ��ࠢ�⥫� ���쬠
set MAIL_FROM=%COUNT_TEXT%@vhv.ltg.gazprom.ru

REM ���� ᮮ�饭��
set THEME=���� ᢮������� ���� �� ��᪥ �ࢥ� %COUNT_TEXT%

REM ���� ᮮ�饭��
set BODY=%NOTIFY_NAME% %COUNT_NAME% ᢮����� %COUNT_VALUE%Mb, �।�� �� %COUNT_LIMIT%Mb.

REM =============================================
REM ��᫠�� ���쬮
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" %BODY%


:DONE

