rem остановка и отключение неиспользуемых служб в АСУТП

rem Беспроводная настройка (только для XP)

sc config WZCSVC start= disabled

sc stop WZCSVC
