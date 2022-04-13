@echo off
chcp 1251 > nul
echo []-----------------------------------------------------------
echo     Подключение FTP сервера MRS МиКС как локального диска V: 
echo     с помощью программы FTPUSE
echo.

FTPUSE V: mics.ltg.gazprom.ru 2fwy5jpy /USER:miks 

echo.
echo     ОКНО НЕ ЗАКРЫВАТЬ!!!