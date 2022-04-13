@echo off
REM --------------------------------------------------------------------------
REM   Командный файл для:
REM
REM   Копирования базы данных с сервера СЕГ на
REM   компьютер АРМ инженера системщика.
REM
REM   (С) Волховское ЛПУМГ филиал ООО "Газпром трансгаз Санкт-Петербург"
REM                                2017
REM --------------------------------------------------------------------------

chcp 1251

REM Устанавливаем локальный набор переменных
setlocal

REM Рабочий каталог и путь к данным Rtap
set WORKDISK=Z:
set WORKPATH=systserv

REM Имя файла архива
set BACKUPFILE=ProjectKC2

REM Имя АРМ КЦ2 и имя диска с данными КЦ2
set ADRSERV=10.9.97.1
set DISKSERV=c$
   
REM Адрес сервера электронной почты
set SMTP=10.9.108.105

REM Получатель отчёта о записи файлов
set MAIL_TO=lyum@vhv.ltg.gazprom.ru, serges@vhv.ltg.gazprom.ru 

REM Отправитель отчёта
set MAIL_FROM=SAD_KC2@vhv.ltg.gazprom.ru

REM Тема сообщения
set     THEME=CopyKC2: Проект с АРМ КЦ2 скопирован
set THEME_ERR=CopyKC2: нет подключения к АРМ КЦ2

REM Переходим в рабочий каталог
D:
cd \Backup\Archive_KC2

REM Проверка доступности каталога для архивирования
if exist %WORKDISK% goto OK
   net use %WORKDISK% \\%ADRSERV%\%DISKSERV%
      if not exist %WORKDISK%\%WORKPATH% ( 
        zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME_ERR%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251"
        exit 1
       )         

:OK


REM Переименовываем архивы для их длительного хранения
rename %BACKUPFILE%09.* %BACKUPFILE%10.*
rename %BACKUPFILE%08.* %BACKUPFILE%09.*
rename %BACKUPFILE%07.* %BACKUPFILE%08.*
rename %BACKUPFILE%06.* %BACKUPFILE%07.*
rename %BACKUPFILE%05.* %BACKUPFILE%06.*
rename %BACKUPFILE%04.* %BACKUPFILE%05.*
rename %BACKUPFILE%03.* %BACKUPFILE%04.*
rename %BACKUPFILE%02.* %BACKUPFILE%03.*
rename %BACKUPFILE%01.* %BACKUPFILE%02.*
rename %BACKUPFILE%.7z  %BACKUPFILE%01.*

REM Архивирование проекта КЦ2
REM -ssw открывать совместно используемые файлы

"C:\Program Files\7-Zip\"7z.exe a -ssw -mx5 -m0=LZMA2 -xr!log %BACKUPFILE%.7z %WORKDISK%\%WORKPATH%\ 

REM Удаление самого старого файла
del %BACKUPFILE%10.*


REM Выделение информации о файлах архива
dir | find /I "%BACKUPFILE%" > ..\%BACKUPFILE%.log


REM Отправка сообщения о копировании файлов
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" %%PUT="..\%BACKUPFILE%.log" 

net use /delete %WORKDISK%

:END                                        