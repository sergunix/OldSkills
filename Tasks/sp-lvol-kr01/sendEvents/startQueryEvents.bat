@ECHO off
REM �������� 䠩� ��� ����᪠ ᡮ� ᮡ�⨩ �� �ࢥ஢ �� ᯨ᪠ � addresslist.txt

CD "%~dp0"

CLS

ECHO [%TIME:~0,8%] ����� ����⭮�� 䠩�� ᡮ� ᮡ�⨩ ��:
TYPE addresslist.txt
ECHO.

FOR /F "tokens=1,*" %%l in (addresslist.txt) do (
	ECHO.
	ECHO ����� ᡮ� ᮡ�⨩ �� %%l
	cscript.exe //nologo "%~dp0queryAndSendEvents.vbs" %%l
	)

ECHO [%TIME:~0,8%] ����� ����⭮�� 䠩�� ᡮ� ᮡ�⨩ �����襭�