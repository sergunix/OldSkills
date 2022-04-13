@echo off
REM []-------------------------------------------------------------------------
REM    Командный файл для:
REM    Подготовки пакетов файлов НСИ для БД Oracle
REM
REM     (C) филиал ООО "Газпром трансгаз Санкт-Петербург" - Волховское ЛПУМГ
REM                               2002-2011
REM ---------------------------------------------------------------------------

REM Устанавливаем локальный набор переменных
setlocal

REM Код ЛПУ по классификации МиКС
set LPU=13

REM Адрес SMTP сервера электронной почты
set SMTP=10.9.108.105

REM Получатель отчета о загрузке файлов
set MAIL_TO=sysadmin@vhv.ltg.gazprom.ru

REM Отправитель отчета
set MAIL_FROM=mics@vhv.ltg.gazprom.ru

REM Тема сообщения
set THEME=Файлы MRS Oracle не сформированны для передачи makensiora.cmd

REM Путь к каталогу с пакетами НСИ
set NSIDISK=D:
set NSIPATH=\ARM_UPDATES

REM Каталог с исполняемыми файлами
set RUNDISK=c:
set RUNPATH=\Apps\mics

REM Каталог с исполняемыми файлами в сети
set NETDISK=S:
set NETPATH=\mics\Oracle

REM Логическая переменная
set bool=0

ECHO []---- Подготовкa пакетов файлов НСИ для БД Oracle

REM =============================================
REM Проверка доступности системы МиКС локально
if not exist %RUNDISK%%RUNPATH%\mrsOra.exe (
   if not exist %NETDISK%%NETPATH%\mrsOra.exe goto NOMICS )
if not exist %RUNDISK%%RUNPATH%\mrsDocOra.exe (
   if not exist %NETDISK%%NETPATH%\mrsDocOra.exe goto NOMICS )
if not exist %RUNDISK%%RUNPATH%\info.key   goto NOMICS
if not exist %NETDISK%%NETPATH%\mrsOra.exe    (zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" Внимание! Модуль МИКС mrsOra.exe    недоступен в сети, возможно прием пакетов НСИ выполняется с устаревшим модулем!)
if not exist %NETDISK%%NETPATH%\mrsDocOra.exe (zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" Внимание! Модуль МИКС mrsDocOra.exe недоступен в сети, возможно прием пакетов НСИ выполняется с устаревшим модулем!)

REM Проверка доступности каталога с пакетами НСИ, чтобы было куда выложить пакеты НСИ 
if not exist %NSIDISK%%NSIPATH% goto NO_Y

REM Сравниваем обновились ли файлы mrsOra.exe и mrsDocOra.exe на сетевом ресурсе
echo N|comp.exe %RUNDISK%%RUNPATH%\mrsOra.exe %NETDISK%%NETPATH%\mrsOra.exe 1>nul 2>nul && set bool=1
if %bool%==0 (copy /Z /Y %NETDISK%%NETPATH%\mrsOra.exe %RUNDISK%%RUNPATH%\mrsOra.exe)
echo N|comp.exe %RUNDISK%%RUNPATH%\mrsDocOra.exe %NETDISK%%NETPATH%\mrsDocOra.exe 1>nul 2>nul && set bool=1
if %bool%==0 (copy /Z /Y %NETDISK%%NETPATH%\mrsDocOra.exe %RUNDISK%%RUNPATH%\mrsDocOra.exe)

REM Проверка доступности базы данных для выполнения программы (подключение и выход)
REM Удаляем файл протокола подключения, сформированный sqlplus.exe ранее
if not exist sqlnet.log goto NEXT1
del /F /Q sqlnet.log
:NEXT1
echo exit | sqlplus.exe -L "mics_%LPU%/1810vbrc_1313@micso%LPU%" 
if errorlevel 2 goto ERR2
if errorlevel 1 goto ERR1
if errorlevel 0 goto OK
:ERR2
:ERR1
REM Послать инфо о недоступности базы данных МиКС
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" Внимание! База данных МИКС Oracle недоступна, формирование пакетов файлов НСИ не было выполнено. Код проверки=%errorlevel%. %%PUT="sqlnet.log"
goto END

:OK
REM =============================================
REM Запускаем пакетное формирование файлов mrs для БД Oracle
%RUNDISK%%RUNPATH%\mrsOra.exe /Ln /umics_13 /P1810vbrc_1313 /smicso13 /bmics_13 /TNSI_SEND /TAGGR_SEND /TAGDOG_SEND /TAGMTR_SEND
%RUNDISK%%RUNPATH%\mrsOra.exe /Ln /umics_13 /P1810vbrc_1313 /smicso13 /bmics_13 /TXIADD_SEND /TASBU_SEND 
REM /TXI_SEND -не работает пока с 25.10.2010 в БД Oracle и MSSQL тоже давно не работал

%RUNDISK%%RUNPATH%\mrsDocOra.exe /Ln /umics_13 /P1810vbrc_1313 /smicso13 /bmics_13 /TDOG_SEND /TNAKL_SEND
sleep.EXE 2

goto DONE

:NOMICS
REM =============================================
REM Послать логфайл о недоступности МиКС
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" Внимание! Модули МИКС mrsOra.exe, mrsDocOra.exe или info.key недоступен в каталоге %RUNDISK%%RUNPATH%, формирование пакетов файлов НСИ не было выполнено. 
goto END

:NO_Y
REM =============================================
REM Послать логфайл о недоступности каталога с пакетами НСИ
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" Внимание! Каталог %NSIDISK%%NSIPATH% недоступен (диск не подключен или нет входа пользователя в сессию), формирование пакетов файлов НСИ не было выполнено. 
goto END


:DONE

