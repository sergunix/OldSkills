@echo off
REM []-------------------------------------------------------------------------
REM    Командный файл для:
REM    Приема пакетов файлов НСИ по заданиям mrsOra.exe и mrsDocOra.exe
REM
REM     (C) филиал ООО "Газпром трансгаз Санкт-Петербург" - Волховское ЛПУМГ
REM                               2002-2011
REM ---------------------------------------------------------------------------

REM Устанавливаем локальный набор переменных
setlocal

REM Код ЛПУ по классификации МиКС
set LPU=13

REM Адрес SMTP сервера электронной почты
set SMTP=vhv-dc-01.corp.it.ltg.gazprom.ru

REM Получатель отчета о загрузке файлов
set MAIL_TO=sysadmin@vhv.ltg.gazprom.ru

REM Отправитель отчета
set MAIL_FROM=mics@vhv.ltg.gazprom.ru

REM Имя файла протокола сформированных файлов для передачи
set LOGFILE=log_recvnsi.txt

REM Тема сообщения
set THEME=Файлы MRS - ошибки приёма через recvnsi.cmd
set THEMEOK=Завершен прием закачанных пакетов файлов НСИ

REM Само сообщение
set BODY="Список не принятых файлов MRS"

REM Сообщение о повторном запуске того же батника
set BODYSENDLOCK="Внимание! Не завершился прошлый запуск recvnsi.cmd, возможно, ошибка в приеме пакета НСИ!"

REM Путь к каталогу с пакетами НСИ
set NSIDISK=D:
set NSIPATH=\ARM_UPDATES

REM Имя файла блокировки
set LOCKFILE=%NSIDISK%%NSIPATH%\RECVNSI_LCK.TXT

REM Каталог с исполняемыми файлами
set RUNDISK=c:
set RUNPATH=\Apps\Mics

REM Каталог с исполняемыми файлами в сети
set NETDISK=S:
set NETPATH=\mics\Oracle

REM Логическая переменная
set bool=0
ECHO []----- Прием пакетов файлов НСИ по заданиям mrsOra.exe и mrsDocOra.exe

REM =============================================
REM Проверка доступности системы МиКС локально и в сети
if not exist %RUNDISK%%RUNPATH%\mrsOra.exe (
   if not exist %NETDISK%%NETPATH%\mrsOra.exe goto NOMICS )
if not exist %RUNDISK%%RUNPATH%\mrsDocOra.exe (
   if not exist %NETDISK%%NETPATH%\mrsDocOra.exe goto NOMICS )
if not exist %RUNDISK%%RUNPATH%\info.key   goto NOMICS
if not exist %NETDISK%%NETPATH%\mrsOra.exe    (zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" Внимание! Модуль МИКС mrsOra.exe недоступен в сети, возможно прием пакетов НСИ выполняется с устаревшим модулем!)
if not exist %NETDISK%%NETPATH%\mrsDocOra.exe (zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" Внимание! Модуль МИКС mrsDocOra.exe недоступен в сети, возможно прием пакетов НСИ выполняется с устаревшим модулем!)

REM Проверка доступности каталога с пакетами НСИ, чтобы было куда выложить пакеты НСИ  
if not exist %NSIDISK%%NSIPATH% goto NO_Y

REM Сравниваем обновился ли файл mrsOra.exe и mrsDocOra.exe на сетевом ресурсе
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
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" Внимание! База данных МИКС Oracle недоступна, приём пакетов файлов НСИ не был выполнен. Код проверки=%errorlevel%. %%PUT="sqlnet.log"
goto END

:OK
REM Создать файл блокировки повторного запуска
if exist %LOCKFILE% goto LOCK
echo. > %LOCKFILE%
echo File %LOCKFILE% locked!  >> %LOCKFILE%
date /t >>  %LOCKFILE% 
time /t >> %LOCKFILE% 

REM Запускаем пакетный прием файлов mrs
%RUNDISK%%RUNPATH%\mrsOra.exe /Ln /umics_13 /P1810vbrc_1313 /smicso13 /bmics_13 /TNSI_RECV
sleep.EXE 2
%RUNDISK%%RUNPATH%\mrsDocOra.exe /Ln /umics_13 /P1810vbrc_1313 /smicso13 /bmics_13 /TNAKL_RECV /TDOG_RECV
sleep.EXE 2

REM Снять блокировку запуска этого командного файла
del /F /Q %LOCKFILE%

REM Послать инфо о завершении процесса приёма пакетов НСИ в БД МиКС
%NSIDISK%%NSIPATH%\zerat smtphost:%SMTP% from:"%0 %MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEMEOK%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" По заданиям mrsOra.exe и mrsDocOra.exe

REM =============================================
REM Проверяем, все ли пакеты приняты успешно
%NSIDISK%
cd %NSIPATH%

if exist     .\_Replication\Attention*.err 	       goto MAKELST
if exist     .\_Replication\MRS_Dogovor\Attention*.err goto MAKELST
if not exist .\_Replication\MRS_NAKL\Attention*.err    goto END

:MAKELST
REM Формируем список не принятых файлов mrs (код стр 1251 для команды DIR)
chcp 1251
REM Удаляем лог для помещения его в корзину 11-11-2010
del /q %LOGFILE%
@echo : >  %LOGFILE%
dir /B %NSIDISK%%NSIPATH%\_Replication 		   | grep -i .err >> %LOGFILE%
dir /B %NSIDISK%%NSIPATH%\_Replication\MRS_Dogovor | grep -i .err >> %LOGFILE%
dir /B %NSIDISK%%NSIPATH%\_Replication\MRS_NAKL    | grep -i .err >> %LOGFILE%
REM dir /B %NSIDISK%%NSIPATH%\_Replication\MRS_FOND    | grep -i .err >> %LOGFILE%
chcp 866

REM Послать логфайл о непринятых файлах
%NSIDISK%%NSIPATH%\zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" %BODY% %%PUT="%LOGFILE%"

REM Удалить инфо о не принятых пакетах
del /F /Q %NSIDISK%%NSIPATH%\_Replication\Attention*.err
del /F /Q %NSIDISK%%NSIPATH%\_Replication\MRS_Dogovor\Attention*.err
del /F /Q %NSIDISK%%NSIPATH%\_Replication\MRS_NAKL\Attention*.err
del /F /Q %NSIDISK%%NSIPATH%\_Replication\%LOGFILE%
goto END


:LOCK
REM =============================================
REM Послать сообщение о зависшей закачке на администратора сети
echo LOCK
REM Переходим в рабочий каталог лог-файлов
%NSIDISK%
cd %NSIPATH%
zerat smtphost:%SMTP% from:"%0 %MAIL_FROM%" to:"%MAIL_TO%" subject:"Прием файлов репликаций: завис процесс приёма" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" %BODYSENDLOCK% %%PUT="%LOCKFILE%"
goto END

:NOMICS
REM =============================================
REM Послать логфайл о недоступности МиКС
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" Внимание! Модули МИКС mrsOra.exe, mrsDocOra.exe или info.key недоступен, приём пакетов файлов НСИ не был выполнен. 
goto END

:NO_Y
REM =============================================
REM Послать логфайл о недоступности каталога с пакетами НСИ
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" Внимание! Каталог %NSIDISK%%NSIPATH% недоступен (диск не подключен или нет входа пользователя в сессию), прием пакетов файлов НСИ не был выполнен. 
goto END

:END








