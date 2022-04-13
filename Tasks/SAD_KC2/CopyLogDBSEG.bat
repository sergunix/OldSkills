@echo off
REM --------------------------------------------------------------------------
REM   Командный файл для:
REM
REM   Копирования  log-файлов базы данных с сервера СЕГ на
REM   компьютер АРМ инженера системщика.
REM
REM   (С) Волховское ЛПУМГ филиал ООО "Газпром трансгаз Санкт-Петербург"
REM                                2017
REM --------------------------------------------------------------------------

chcp 1251

REM Устанавливаем локальный набор переменных
setlocal

REM Рабочий каталог и путь к данным Rtap
set WORKDISK=R:
set WORKPATH=RtapEnvs\LenVlh\log


REM Имя файла архива
set BDFILELOG=BDSEGLOG

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
set     THEME=CopyDBSEGLOG: БД с сервера СЕГ скопирована
set THEME_ERR=CopyDBSEGLOG: нет подключения к серверу СЕГ

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
rename %BDFILELOG%09.* %BDFILELOG%10.*
rename %BDFILELOG%08.* %BDFILELOG%09.*
rename %BDFILELOG%07.* %BDFILELOG%08.*
rename %BDFILELOG%06.* %BDFILELOG%07.*
rename %BDFILELOG%05.* %BDFILELOG%06.*
rename %BDFILELOG%04.* %BDFILELOG%05.*
rename %BDFILELOG%03.* %BDFILELOG%04.*
rename %BDFILELOG%02.* %BDFILELOG%03.*
rename %BDFILELOG%01.* %BDFILELOG%02.*
rename   %BDFILELOG%.7z %BDFILELOG%01.*

REM Архивирование базы данных СЕГ
REM -ssw открывать совместно используемые файлы

"C:\Program Files\7-Zip\"7z.exe a -ssw -mx5 -m0=LZMA2 %BDFILELOG%.7z %WORKDISK%\%WORKPATH%\ 

REM Удаление самого старого файла
del %BDFILELOG%10.*

REM Переход на кодировку 1251
chcp 1251

REM Выделение информации о файлах архива
dir | find /I "%BDFILELOG%" > ..\%BDFILELOG%.log


REM Отправка сообщения о копировании файлов
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" %%PUT="..\%BDFILE%.log" 

net use /delete %WORKDISK%

:END                                        