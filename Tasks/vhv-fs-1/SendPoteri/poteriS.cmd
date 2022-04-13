@echo off
REM []-------------------------------------------------------------------------
REM    Командный файл для:
REM    Запуска процесса формирования писем от служб в отдел кадров
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


REM =========================================
REM Имя командного файла для запуска передачи инфо 
set CMDFILE=poteri.cmd

REM Послать файл от службы АСУ
call %CMDFILE% АСУ "vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" АСУ.txt

REM Послать файл от службы ГКС      
call %CMDFILE% ГКС "VHV_gks_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" ГКС.txt

REM Послать файл от службы ЭВС 
call %CMDFILE% ЭВС "VHV_evs_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" ЭВС.txt

REM Послать файл от службы АТХ
call %CMDFILE% АТХ "VHV_atx_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" АТХ.txt

REM Послать файл от службы СЗК 
call %CMDFILE% СЗК "VHV_szk_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" СЗК.txt
  
REM Послать файл от службы СКЗ
call %CMDFILE% СКЗ "VHV_sr_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" СКЗ.txt

REM Послать файл от службы КИПиА
call %CMDFILE% КИПиА "VHV_kip_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" КИП.txt

REM Послать файл от службы РСГ
call %CMDFILE% РСГ "VHV_rsg_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" РСГ.txt

REM Послать файл от службы ЛЭС
call %CMDFILE% ЛЭС "VHV_les_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" ЛЭС.txt

REM Послать файл от службы эксплуатации СЭГРС
call %CMDFILE% СЭГРС "VHV_egrs_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" СЭГРС.txt

REM Послать файл от службы ДС
call %CMDFILE% ДС "VHV_ds_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" ДС.txt

REM Послать файл от Хим.лаборатории
call %CMDFILE% Хим.лаборатории "VHV_Chemlab_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" Химлаб.txt

REM Послать файл от Группы хозяйственного обслуживания
call %CMDFILE% ГХО "VHV_Zavhoz_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" Завхоз.txt

REM Послать файл от СВПО
call %CMDFILE% СВПО "VHV_vpo_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" ВПО.txt

REM Послать файл от Службы Связи
call %CMDFILE% СС "VHV_ats_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" СС.txt

REM Послать файл от АРП
call %CMDFILE% АРП "VHV_arp_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\Табеля\Потери по службам" АРП.txt

:END

