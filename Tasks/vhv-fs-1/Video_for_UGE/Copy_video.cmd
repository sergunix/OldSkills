
rem Копирование видеофайлов службы ЭВС в УГЭ (доступ от УЗ vhvservice)
rem (c) 2017, 2021 

REM Адрес SMTP сервера электронной почты
set SMTP=10.9.108.105

set SMAIL=Video_for_UGE@vhv.ltg.gazprom.ru

REM Получатель отчёта о неисправностях в работе системы
set MAIL_ADM=vhvadmin@vhv.ltg.gazprom.ru

set PATH_UGE=D:\Video_for_UGE

set Log=copy.log
Date /T > %Log%
Time /T >> %Log%
rem :Repeat

xcopy %PATH_UGE%\* "\\hq-fs-1\UGE_Video\Волховское ЛПУМГ" /E /Y /Z /J >> %Log%
if errorlevel 1 goto ERRORCOPY

rem dir /S /B %PATH_UGE% >> %Log%
zerat smtphost:"%SMTP%" from:"%SMAIL%" to:"%MAIL_ADM%" subject:"Задача копирования видео для УГЭ, выполнена." charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=cp866" %%PUT='C:\Apps\Video_for_UGE\%Log%'

rem RD /S /Q D:\Video_for_UGE\*

rem Удаление всех файлов и подкаталогов, в указанном каталоге
setlocal enableextensions enabledelayedexpansion

if exist "%PATH_UGE%" (
    echo Clearing folders in [%PATH_UGE%].
    pushd "%PATH_UGE%" && (rmdir /s /q "%PATH_UGE%" & popd) 2>nul
) else (
    echo Not found [%PATH_UGE%]
)

endlocal

goto END

:ERRORCOPY
zerat smtphost:"%SMTP%" from:"%SMAIL%" to:"%MAIL_ADM%" subject:"Задача копирования видео для УГЭ, не выполнена." charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=cp866" %%PUT='C:\Apps\Video_for_UGE\error.txt'

:END
exit /b 0