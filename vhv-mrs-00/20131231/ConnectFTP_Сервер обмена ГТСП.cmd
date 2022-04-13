@echo off
chcp 1251 > nul
echo []-----------------------------------------------------------
echo     Подключение FTP сервера MRS МиКС как локального диска V: 
echo     с помощью программы FTPUSE
echo.

FTPUSE V: 10.9.14.9 wohv9hxz /USER:volhov

echo.
echo     ОКНО НЕ ЗАКРЫВАТЬ!!!