Dim SourceFolder, Mask, TargetFolder, FileCount, CopyCount, ErrCount
Dim SMTPServ, SMTPPort, SMTPAuth, SMTPSSL
Dim SendName, SendFrom, SendPswd, SendTo
Dim MailSubj, MailBody, MailAtch

Set oShell = WScript.CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")
MailAtch = FSO.GetParentFolderName(WScript.ScriptFullName) & "\CopyLogSEG.log"
Set LogFile = FSO.CreateTextFile(MailAtch, true)
Set objEmail = CreateObject("CDO.Message")

' Папаметры скрипта
SourceFolder = "\\10.9.97.224\r$\RtapEnvs\LenVlh\log\"			'Исходный каталог, откуда производиться копирование
TargetFolder = "V:\СЕГ, Г-Л 1\Логи сервера СЕГ1\"		'Каталог назначения, куда копируются файлы
Mask = "LenVlhEvents.log."					'Имя файла начинается с этих символов, своеобразная маска

SMTPServ = "10.9.108.105"				'Почтовый сервер
SMTPPort = 25						'Порт
SMTPAuth = 0						'Аутентификация: 0 – без аутентификации, 1 - базовая, 2 – NTLM
SMTPSSL  = False					'Использовать SSL

SendName = "CopyFiles"					'Имя отправителя
SendFrom = "SEG@vhv.ltg.gazprom.ru"			'Адрес отправителя
SendPswd = ""						'Пароль отправителя
SendTo   = "sysadmin@vhv.ltg.gazprom.ru"			'Адрес получателя
MailSubj = "Копирование файлов событий сервера СЛТМ"	'Тема письма


MailBody = "Копирование файлов событий сервера СЛТМ"
MailBody = MailBody & Chr(13)
MailBody = MailBody & Chr(13) & "Исходный каталог:  " & Chr(9) & SourceFolder
MailBody = MailBody & Chr(13) & "Каталог назначения:" & Chr(9) & TargetFolder
MailBody = MailBody & Chr(13) & "Маска копирования: " & Chr(9) & Mask & "*"
MailBody = MailBody & Chr(13)

LogFile.WriteLine Now & Chr(9) & "Подключение подключение сетевого диска"
oShell.Run "net use V: \\10.9.106.109\Documentation /user:asutp@corp.it.ltg.gazprom.ru Atgs1790314", 0, False
LogFile.WriteLine Now & Chr(9) & "Ожидание 3 секунды..."
WScript.Sleep 3000

On Error Resume Next

FileCount = 0
CopyCount = 0
ErrCount = 0

LogFile.WriteLine Now & Chr(9) & "Копирование начато"
MailBody = MailBody & Chr(13) & Now & Chr(9) & "Копирование начато"

For Each File In FSO.GetFolder(SourceFolder).Files
	If Left(File.Name, Len(Mask)) = Mask Then
		FileCount = FileCount + 1
		FSO.CopyFile File.Path, TargetFolder & File.Name, True
		If Err.Number Then
			LogFile.WriteLine Now & Chr(9) & "Ошибка " & Err.Number & " при копировании файла " & File.Name  & Chr(9) &  Err.Description
			MailBody = MailBody & Chr(13) & Now & Chr(9) & "Ошибка " & Err.Number & " при копировании файла " & File.Name  & Chr(9) &  Err.Description
			ErrCount = ErrCount + 1
			Err.Clear
		Else
			LogFile.WriteLine Now & Chr(9) & "Файл скопирован " & File.Name
			CopyCount = CopyCount + 1
		End If
	End If
Next

oShell.Run "net use V: /Delete", 0, False

LogFile.WriteLine Now & Chr(9) & "Копирование завершено"
MailBody = MailBody & Chr(13) & Now & Chr(9) & "Копирование завершено"
MailBody = MailBody & Chr(13)
MailBody = MailBody & Chr(13) & "Обнаружено файлов:" & Chr(9) & FileCount
MailBody = MailBody & Chr(13) & "Скопировано файлов:" & Chr(9) & CopyCount
MailBody = MailBody & Chr(13) & "Ошибок копирования:" & Chr(9) & ErrCount

LogFile.Close

With objEmail
	.From = SendFrom
	.To = SendTo
	If ErrCount = 0 Then
		.Subject = MailSubj
	Else
		.Subject = MailSubj & " (ОШИБОК: " & ErrCount & ")"
	End If
	.BodyPart.CharSet = "windows-1251"
	.Textbody = MailBody
	.AddAttachment MailAtch
	With .Configuration.Fields
		.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = SMTPServ
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = SMTPPort
		.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = SendName
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = SMTPAuth
		.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = SendPswd
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = SMTPSSL
		.Update
	End With
	.Send
End With