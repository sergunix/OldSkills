@echo off
REM []----------------------------------------------------------------------------------------
REM    Командный файл для:
REM    Закачки файлов обновленной базы картографических материалов;
REM    Согласно приказа "О вводе в действие Регламента ведения и обновления 
REM             электронной базы картографической информации ГИС "НЕВА" №261 от 25.07.2011
REM    C письмом о произведенной загрузке файлов.
REM
REM    (C) филиал ООО "Газпром трансгаз Санкт-Петрбург" 
REM                                   - Волховское ЛПУМГ, 2011
REM ------------------------------------------------------------------------------------------

REM =============================================
REM Целевой каталог для закачки файлов 
set WORKDISK=D:
set WORKPATH=\ARM_UPDATES\Neva

REM Адрес сервера обновлений
set NAVSRV="ftp://volhov:wohv9hxz@10.9.14.9/aup/helpdesk/GIS_NEVA"

REM Имя файла протокола закачки
set LOGFILE=log_neva.txt

REM Адрес SMTP сервера электронной почты
set SMTP=vhv-dc-01.corp.it.ltg.gazprom.ru

REM Получатель отчета о загрузке файлов
set MAIL_TO=sysadmin@vhv.ltg.gazprom.ru

REM Отправитель отчета
set MAIL_FROM=wgetNeva.cmd@vhv.ltg.gazprom.ru
 
REM Тема сообщения
set THEME=Обновление базы картографических материалов ГИС Нева-

REM Что закачать 
set FILES=Vol*.*,Волхов*.*


REM =============================================
REM Формируем из команды CD переменные текущего диска и пути
cd > %LOGFILE%
for /f "tokens=1 delims=\" %%i in (%LOGFILE%) do set CURDISK=%%i
for /f "tokens=2 delims=:" %%i in (%LOGFILE%) do set CURPATH=%%i
del /Q /F %LOGFILE%

REM Переходим в рабочий каталог
%WORKDISK%
cd %WORKPATH%

REM =============================================
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME% запущено на закачку на компьютере %COMPUTERNAME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" %THEME% запущено на закачку с компьютера %COMPUTERNAME%
wget %NAVSRV% -P. -N -r --continue --no-remove-listing -nH -R.* -A%FILES% --cut-dirs=3 -o..\%LOGFILE% 
REM убрано с 03.04.2013 так как канал Спб-Вхв стал 50Мбит --limit-rate=131072
REM может что-нибудь надо будет исключить из закачки -X/aup/optima/.kde*

REM =============================================
REM   Выделить из протокола данные о закачанных файлах
REM Если информации о закачанных файлах нет, то ничего больше не делаем
GREP saved ..\%LOGFILE% | GREP -v .listing  > ..\SAVE%LOGFILE%

if errorlevel 2 goto ERR2
if errorlevel 1 goto ERR1
if errorlevel 0 goto ERR0
goto END


:ERR2
REM Файл не найден для команды GREP 
goto END

:ERR1
REM Не удалось ничего найти по команде GREP
goto END

:ERR0
REM Информация о закачанных файлах есть!

REM =============================================
REM Послать логфайл о произведенной закачке на администратора сети
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME% закачано" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" %%PUT="..\SAVE%LOGFILE%" $incl "..\%LOGFILE%"

REM []--- Синхронизация файлов Neva в лок.папке \Neva и на FTP-сервере /software/GIS_NEVA/Волховское_ЛПУМГ
REM       добавлена опция --no-remove-listing в команду wget для сохранения файла листинга
REM       Формируем список файлов на ФТП сервере
:: if not exist .listing goto NOLISTING

REM Выделяем из файла .listing имена закачанных файлов (начинаются с 57 символа)
REM cut.exe - unix утилита портированная под Win32
REM Первые 2 строки листинга удалить, так как там каталоги . и ..
:: more +2 .listing | cut.exe -c57- > ..\%LOGFILE%

REM Перекодируем файл из Win1251 в 866, так как wget дал .listing в 1251,
REM а rar работает из командной строки в 866
:: ..\dcd  /on 1251,dos ..\%LOGFILE%
:: del /Q /F ..\%LOGFILE%.bak

REM       Архивирование с исключением тех файлов, что лежат на FTP
:: del /Q /F .listing
:: rar m -y -m0 -x@..\%LOGFILE% FTP_del.rar *.*
:: echo. > ..\SAVE%LOGFILE%
:: rar lb FTP_del.rar >> ..\SAVE%LOGFILE%
                  
REM Перекодируем файл из 866 В Win1251
:: ..\dcd  /on dos,1251 ..\SAVE%LOGFILE%
:: del /Q /F ..\SAVE%LOGFILE%.bak

REM Послать логфайл о удаляемых локальных файлах, которых уже нет на ФТП
:: zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME% корневой каталог синхронизирован" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" Из директории %WORKDISK%%WORKPATH% были удалены файлы отсутствующие в корне на ФТП сервере: " %%PUT="../SAVE%LOGFILE%" 

REM       Архивированные файлы НТД будем удалять сразу
:: del /Q /F FTP_del.rar

goto END

:NOLISTING
REM []--- Отправка сообщения об отсутствии файла .listing со списком файлов на FTP-сервере
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME% нет списка файлов с ФТП сервера" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" Внимание! Список архивов с НТД с ФТП-сервера не был подготовлен, синхронизация НТД файлов не выполнена.
goto END

:END
REM Переходим в текущий каталог
%CURDISK%
cd %CURPATH%
