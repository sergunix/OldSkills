@ECHO off
REM Командный файл для запуска сбора событий сс ерверов из списка в addresslist.txt

CD "%~dp0"

CLS

ECHO [%TIME:~0,8%] Запуск пакетного файла сбора событий на:
TYPE addresslist.txt
ECHO.

FOR /F "tokens=1,*" %%l in (addresslist.txt) do (
	ECHO.
	ECHO [%TIME:~0,8%] Запуск сбора событий на %%l
	cscript.exe //nologo "%~dp0queryAndSendEvents.vbs" %%l
	)

ECHO [%TIME:~0,8%] Работа пакетного файла сбора событий завершена
