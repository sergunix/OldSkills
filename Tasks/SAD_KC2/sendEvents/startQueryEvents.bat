@ECHO off
REM ��������� ���� ��� ������� ����� ������� �� ������� �� ������ � addresslist.txt

CD "%~dp0"

CLS

ECHO [%TIME:~0,8%] ������ ��������� ����� ����� ������� ��:
TYPE addresslist.txt
ECHO.

FOR /F "tokens=1,*" %%l in (addresslist.txt) do (
	ECHO.
	ECHO [%TIME:~0,8%] ������ ����� ������� �� %%l
	cscript.exe //nologo "%~dp0queryAndSendEvents.vbs" %%l
	)

ECHO [%TIME:~0,8%] ������ ��������� ����� ����� ������� ���������
