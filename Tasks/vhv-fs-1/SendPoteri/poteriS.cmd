@echo off
REM []-------------------------------------------------------------------------
REM    �������� 䠩� ���:
REM    ����᪠ ����� �ନ஢���� ��ᥬ �� �㦡 � �⤥� ���஢
REM    � ������ ࠡ�⭨��� �� ࠡ��� ����� (���쭨��, �ண�)
REM    poteri.cmd param1 param2 param3, ���
REM   		param1 - ��� �㦡�, ����� �ନ��� ᮮ�饭�� � ������
REM		param2 - ���� �.����� �㦡�, ��� ����祭�� ��� �� ᥡ�	
REM		param3 - ��⠫�� � 䠩���� � ���ଠ樥� � ������ � �㦡��		
REM                      (��� ��ᮩ �� ���� ���)
REM		param4 - ��� 䠩�� � ���ଠ樥� � ������ � �㦡�
REM
REM (C) 䨫��� ��� "����஬ �࠭ᣠ� �����-������" - ���客᪮� �����, 2008.
REM ---------------------------------------------------------------------------


REM =========================================
REM ��� ���������� 䠩�� ��� ����᪠ ��।�� ��� 
set CMDFILE=poteri.cmd

REM ��᫠�� 䠩� �� �㦡� ���
call %CMDFILE% ��� "vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ���.txt

REM ��᫠�� 䠩� �� �㦡� ���      
call %CMDFILE% ��� "VHV_gks_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ���.txt

REM ��᫠�� 䠩� �� �㦡� ��� 
call %CMDFILE% ��� "VHV_evs_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ���.txt

REM ��᫠�� 䠩� �� �㦡� ���
call %CMDFILE% ��� "VHV_atx_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ���.txt

REM ��᫠�� 䠩� �� �㦡� ��� 
call %CMDFILE% ��� "VHV_szk_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ���.txt
  
REM ��᫠�� 䠩� �� �㦡� ���
call %CMDFILE% ��� "VHV_sr_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ���.txt

REM ��᫠�� 䠩� �� �㦡� �����
call %CMDFILE% ����� "VHV_kip_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ���.txt

REM ��᫠�� 䠩� �� �㦡� ���
call %CMDFILE% ��� "VHV_rsg_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ���.txt

REM ��᫠�� 䠩� �� �㦡� ���
call %CMDFILE% ��� "VHV_les_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ���.txt

REM ��᫠�� 䠩� �� �㦡� �ᯫ��樨 �����
call %CMDFILE% ����� "VHV_egrs_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" �����.txt

REM ��᫠�� 䠩� �� �㦡� ��
call %CMDFILE% �� "VHV_ds_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ��.txt

REM ��᫠�� 䠩� �� ���.������ਨ
call %CMDFILE% ���.������ਨ "VHV_Chemlab_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ������.txt

REM ��᫠�� 䠩� �� ��㯯� 宧��⢥����� ���㦨�����
call %CMDFILE% ��� "VHV_Zavhoz_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ���宧.txt

REM ��᫠�� 䠩� �� ����
call %CMDFILE% ���� "VHV_vpo_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ���.txt

REM ��᫠�� 䠩� �� ��㦡� ��裡
call %CMDFILE% �� "VHV_ats_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ��.txt

REM ��᫠�� 䠩� �� ���
call %CMDFILE% ��� "VHV_arp_users@vhv.ltg.gazprom.ru,vhvadmin@vhv.ltg.gazprom.ru" "D:\Documentation\������\���� �� �㦡��" ���.txt

:END

