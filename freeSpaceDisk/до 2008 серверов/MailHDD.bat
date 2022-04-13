@echo off
REM []-------------------------------------------------------------------------
REM    Командный файл для:
REM    Отсылки писем Администраторам о переполнении дисков
REM
REM   (C) филиал ООО "Газпром трансгаз Санкт-Петербург"-Волховское ЛПУМГ, 2008
REM
REM   Внимание: В Windows 2000 объект Физический диск по умолчанию включен, а объект
REM   Логический диск по умолчанию выключен. Чтобы включить счетчики для мониторинга 
REM   логических дисков или томов нужно в консоли выполнить команду diskperf -yv и перезагрузить систему.                            
REM ---------------------------------------------------------------------------

REM Устанавливаем локальный набор переменных
setlocal

REM   Имя оповещения
set NOTIFY_NAME=%1
REM   Дата и время
set COUNT_DATE=%2
REM   Имя счетчика
set COUNT_NAME=%3
REM   Измеренное значение
set COUNT_VALUE=%4
REM   Предельное значение
set COUNT_LIMIT=%5
REM   Текстовое сообщение (сюда при настройке счетчика заносим имя сервера vhv-имя-01)
set COUNT_TEXT=%6

REM Адрес SMTP сервера электронной почты
set SMTP=vhv-dc-01.corp.it.ltg.gazprom.ru

REM Получатель письма
set MAIL_TO=sysadmin@vhv.ltg.gazprom.ru

REM Отправитель письма
set MAIL_FROM=%COUNT_TEXT%@vhv.ltg.gazprom.ru

REM Тема сообщения
set THEME=Мало свободного места на диске сервера %COUNT_TEXT%

REM Само сообщение
set BODY=%NOTIFY_NAME% %COUNT_NAME% свободно %COUNT_VALUE%Mb, предел не %COUNT_LIMIT%Mb.

REM =============================================
REM Послать письмо
zerat smtphost:%SMTP% from:"%MAIL_FROM%" to:"%MAIL_TO%" subject:"%THEME%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=windows-1251" %BODY%


:DONE

