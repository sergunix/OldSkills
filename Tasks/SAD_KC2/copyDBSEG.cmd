@echo off
REM --------------------------------------------------------------------------
REM   Командный файл для:
REM
REM   Копирования базы данных с сервера СЕГ на
REM   компьютер АРМ инженера системщика.
REM
REM   (С) Волховское ЛПУМГ филиал ООО "Газпром трансгаз Санкт-Петербург"
REM                                2009
REM --------------------------------------------------------------------------

chcp 1251

REM Устанавливаем локальный набор переменных
setlocal

REM Рабочий каталог и путь к данным Rtap
set WORKDISK=R:
set WORKPATH0=RtapEnvs\LenVlh
set WORKPATH1=ACCOL

REM Имя файла архива
set BDFILE=BDSEG

REM Имя сервера БД Rtap и имя диска с данными Rtap
set ADRSERV=10.9.97.224
set DISKSERV=R$
   
REM Адрес сервера электронной почты
set SMTP=10.9.108.105

REM Получатель отчёта о записи файлов
set MAIL_TO=sysadmin@vhv.ltg.gazprom.ru

REM Отправитель отчёта
set MAIL_FROM=SEG@vhv.ltg.gazprom.ru

REM Тема сообщения
set     THEME=CopyDBSEG: БД с сервера СЕГ скопирована
set THEME_ERR=CopyDBSEG: нет подключения к серверу СЕГ

REM Переходим в рабочий каталог
D:
cd \Backup\Archive_DB

REM Проверка доступности каталога для архивирования
if exist %WORKDISK%\%WORKPATH% goto OK
   net use %WORKDISK% \\%ADRSERV%\%DISKSERV%
      if not exist %WORKDISK%\%WORKPATH% ( 
        zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME_ERR%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251"
        exit 1
       )         

:OK


REM Переименовываем архивы для их длительного хранения
rename %BDFILE%09.* %BDFILE%10.*
rename %BDFILE%08.* %BDFILE%09.*
rename %BDFILE%07.* %BDFILE%08.*
rename %BDFILE%06.* %BDFILE%07.*
rename %BDFILE%05.* %BDFILE%06.*
rename %BDFILE%04.* %BDFILE%05.*
rename %BDFILE%03.* %BDFILE%04.*
rename %BDFILE%02.* %BDFILE%03.*
rename %BDFILE%01.* %BDFILE%02.*
rename %BDFILE%.7z  %BDFILE%01.*

REM Архивирование базы данных СЕГ
REM -ssw открывать совместно используемые файлы

"C:\Program Files\7-Zip\"7z.exe a -ssw -mx5 -m0=LZMA2 -xr!log %BDFILE%.7z %WORKDISK%\%WORKPATH0%\ %WORKDISK%\%WORKPATH1%\

REM Удаление самого старого файла
del %BDFILE%10.*

REM Переход на кодировку 1251
REM chcp 1251

REM Выделение информации о файлах архива
dir | find /I "%BDFILE%" > ..\%BDFILE%.log


REM Отправка сообщения о копировании файлов
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" %%PUT="..\%BDFILE%.log" 

net use /delete %WORKDISK%

:END                                        