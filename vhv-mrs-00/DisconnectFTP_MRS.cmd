@echo off
chcp 1251 > nul
echo []-----------------------------------------------------------
echo     Отключение FTP сервера MRS МиКС как локального диска V: 
echo     с помощью программы FTPUSE
echo.
FTPUSE V: /delete