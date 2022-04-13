@echo off
chcp 1251 > nul
echo []-----------------------------------------------------------
echo     Подключение FTP сервера обмена ГТСП как локального диска V: 
echo     с помощью программы FTPUSE
echo.

FTPUSE V: corp-ftp.corp.it.ltg.gazprom.ru  wohv9hxz /USER:volhov

echo.
echo     ОКНО НЕ ЗАКРЫВАТЬ!!!