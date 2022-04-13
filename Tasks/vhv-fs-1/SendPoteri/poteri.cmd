@echo off
REM []-------------------------------------------------------------------------
REM    Командный файл для:
REM    Создания письма на электронную почту в отдел кадров
REM    о потерях работников на рабочих местах (больничный, прогул)
REM    poteri.cmd param1 param2 param3, где
REM   		param1 - имя службы, которая формирует сообщение о потерях
REM		param2 - адрес эл.почты службы, для получения инфо на себя	
REM		param3 - каталог с файлами с информацией о потерях в службах		
REM                      (без косой на конце пути)
REM		param4 - имя файла с информацией о потерях в службе
REM
REM (C) филиал ООО "Газпром трансгаз Санкт-Петербург" - Волховское ЛПУМГ, 2008.
REM ---------------------------------------------------------------------------




REM =============================================
REM Имя службы, которая формирует сообщение о потерях
set SERVICE=%1

REM Получатель отчёта в службе
set SMAIL=%2

REM Путь к файлу с информацией о потерях в службе 
set FPATH=%3

REM Имя файла с информацией о потерях в службе 
set FILE=%4

REM Флаг отключения отправки кадрам
set FLAG=%5

REM Имя файла с текущей датой 
set DFILE=curdate.txt

REM Адрес SMTP сервера электронной почты
set SMTP=10.9.108.105

REM Получатель отчёта в Отделе Кадров
set MAIL_TO=AllHR-ManagersBranch@vhv.ltg.gazprom.ru 

REM Получатель отчёта Здравпункт для учета больничных
set MAIL_MEDIC=VHV_medic_users@vhv.ltg.gazprom.ru

REM Получатель отчёта о неисправностях в работе системы
set MAIL_ADM=vhvadmin@vhv.ltg.gazprom.ru

REM =============================================
REM Формируем из команды Date переменные текущего дня и месяца
REM блок текущего дня и месяца переделан 22-12-2021 Филин М.А.
 rem date  /T > %DFILE%
 rem for /f "tokens=1 delims=." %%i in (%DFILE%) do set DAY=%%i
 rem for /f "tokens=2 delims=." %%i in (%DFILE%) do set MONTH=%%i
 rem for /f "tokens=3 delims=." %%i in (%DFILE%) do set YEAR=%%i
set DAY=%DATE:~7,2%
set MONTH=%DATE:~4,2%
set YEAR=%DATE:~-4%

REM =============================================
REM Формируем из команды Dir переменные времени и дня для файла о потерях
REM Команда find из поставки Windows может искать русские слова в файле
REM как и grep.com из пакета TurboС 3.0, остальные grep.exe - не могут
REM Вариант через внешнюю программу от TurboС 3.0:
REM                  grep.com -i -o+ %FILE% > %DFILE%

if exist %FPATH%\%FILE% goto FILEEXIST
REM =============================================
REM Послать файл о недоступности файла о потерях
zerat smtphost:"%SMTP%" from:"%SMAIL%" to:"%MAIL_ADM%" subject:"ALERT! Потери по %SERVICE% на %DAY%.%MONTH%.%YEAR% - файл недоступен!" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" Файл с данными о потерях по пути %FPATH%\%FILE% недоступен!!!
goto END

:FILEEXIST
dir %FPATH%\%FILE% | find /I "%FILE%" > %DFILE%
for /f "tokens=1 delims= " %%i in (%DFILE%) do set FDATE=%%i
for /f "tokens=2 delims= " %%i in (%DFILE%) do set FTIME=%%i

rem преобразование даты в ДД/ММ/ГГГГ 11-01-2022 Филин М.А.
set FDATE=%FDATE:~3,2%/%FDATE:~0,2%/%FDATE:~-4%

REM =============================================
REM Послать файл
IF NOT "%FLAG%"=="NOTFORKADR" zerat smtphost:%SMTP% from:%SMAIL% to:%MAIL_TO% subject:"Потери по %SERVICE% на %DAY%.%MONTH%.%YEAR%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" Информация достоверна на %FTIME% от %FDATE%  %%PUT='%FPATH%\%FILE%'
zerat smtphost:%SMTP% from:%SMAIL% to:%MAIL_MEDIC% subject:"Потери по %SERVICE% на %DAY%.%MONTH%.%YEAR%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" Информация достоверна на %FTIME% от %FDATE%  %%PUT='%FPATH%\%FILE%'
zerat smtphost:%SMTP% from:%SMAIL% to:%SMAIL%   subject:"Потери по %SERVICE% на %DAY%.%MONTH%.%YEAR%" charset:windows-1251 type:multipart/mixed $boun "Content-type: text/plain; charset=Windows-1251" Информация достоверна на %FTIME% от %FDATE%  %%PUT='%FPATH%\%FILE%'

REM Удалить файл с текущей датой
del /F /Q %DFILE%

REM Сюда можно вставить команду для корректир. даты\времени файла на след. день
rem touch -t08:00 -dКак задать дату на завтра? %FILE%

:END


