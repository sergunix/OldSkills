'Первый и единственный аргумент <имя_компьютера>
Set objArgs = WScript.Arguments
Set objSysInfo = CreateObject( "WinNTSystemInfo" )

Const CONVERT_TO_LOCAL_TIME = True
Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8

numPeriod = 1/48	'За какой период в случае ошибок выбирать события (1/24 = за последний 1 час)
dtmDateToCheck = NOW
strErrInfo = ""

On Error Resume Next

strComputer = UCase(objArgs(0))

'Процедура определения и вывод ошибки в переменную с указанием ее идентификатора (ErrorID)
Sub CheckLastError(strErrorID)
	If Err.Number Then
		strErrInfo = "В ходе выполнения " & WScript.ScriptName & " на " & objSysInfo.ComputerName & _
                   " произошло событие:<BR>" & Err.Source & " " & "(" & strErrorID & "): " & Err.Description & "<BR>" & vbCrLf
		Wscript.Echo Err.Source & " " & "(" & strErrorID & "): " & Err.Description
		Err.Clear
	End If
End Sub

'Объекты
Set objSysInfo = CreateObject( "WinNTSystemInfo" )
Set objEmail = CreateObject("CDO.Message")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set dtmDateTime = CreateObject("WbemScripting.SWbemDateTime")
Set dtmDateStart = CreateObject("WbemScripting.SWbemDateTime")
Set dtmDateEnd = CreateObject("WbemScripting.SWbemDateTime")
Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
CheckLastError("ErrorID 1")

'Параметры почтового сервера
SMTPServ = "10.9.108.105"
SMTPPort = 25
SMTPAuth = 0	'Аутентификация: 0 – без аутентификации, 1 - базовая, 2 – NTLM
SMTPSSL  = False

'Параметры письма
strSendName = "Script"
strSendFrom = strComputer & "@vhv.ltg.gazprom.ru"
strSendPswd = ""
strSendTo   = "sysadmin@vhv.ltg.gazprom.ru"
strMailSubj = "Event log on " & strComputer

'Получение из текстового файла даты/времени предыдущего опроса 
strLastRunDTFileName = objFSO.GetParentFolderName(WScript.ScriptFullName) & "\logs\log_" & strComputer & ".txt"
If objFSO.FileExists (strLastRunDTFileName) Then
	Set txtStreamInput = objFSO.OpenTextFile(strLastRunDTFileName, ForReading, True)
	strLastRunDT = txtStreamInput.ReadLine
	If strLastRunDT = "" Then
		dtmDateStart.SetVarDate dtmDateToCheck - numPeriod, CONVERT_TO_LOCAL_TIME 
	Else
		dtmDateStart.SetVarDate strLastRunDT, CONVERT_TO_LOCAL_TIME
	End If
Else
	dtmDateStart.SetVarDate dtmDateToCheck - numPeriod, CONVERT_TO_LOCAL_TIME 
End If
CheckLastError("ErrorID 2")

'Запись в текстовый файл даты/времени текущего опроса
Set txtStreamOutput = objFSO.OpenTextFile(strLastRunDTFileName, ForWriting, True)
If Not Err.Number Then
	txtStreamOutput.WriteLine (dtmDateToCheck)
End If
CheckLastError("ErrorID 3")

dtmDateEnd.SetVarDate dtmDateToCheck, CONVERT_TO_LOCAL_TIME

'Опрос журналов событий на удаленной машине
'EventType: 1 - Error; 2 - Warning; 4 - Information; 8 - Security audit success; 16 - Security audit failure;
strEventsQueryFileName = objFSO.GetParentFolderName(WScript.ScriptFullName) & "\eventsQuery.sql"
strEventsQuery = ""
Set txtStreamInput = objFSO.OpenTextFile(strEventsQueryFileName, ForReading, True)
Do While Not txtStreamInput.AtEndOfStream
   strEventsQuery = strEventsQuery + txtStreamInput.ReadLine
   If Right(strEventsQuery, 1) <> " " Then
      strEventsQuery = strEventsQuery + " "
   End If
Loop
CheckLastError("ErrorID 4")

Set colLoggedEvents = objWMIService.ExecQuery _
	(strEventsQuery & "And (TimeWritten >= '" & dtmDateStart & "' and TimeWritten < '" & dtmDateEnd & "')") 
CheckLastError("ErrorID 5 - Возможно " & strComputer & " недоступен")

'HTML разметка текста письма
strMailBody =  "<HTML>" & _
               "<HEAD>" & _
               "<META http-equiv=Content-Type content=" & Chr(34) & "text/html; charset=windows-1251" & Chr(34) & ">" & _
                  "<STYLE>" & _
                     "BODY {font-family:Tahoma;font-size:10pt;text-align:left;} " & _
   				      "DIV {margin-bottom:3mm;margin-top:3mm;} " & _
   				      "DIV.GRAY {color:#C0C0C0} " & _
                     "SPAN {font-weight:bold}" & _
   				      "SPAN.INFO {font-size:12pt} " & _
   				      "SPAN.ERR {font-size:10pt;color:#D92128} " & _
   				      "TABLE {width:640px;border-collapse:collapse;font-family:Calibri;} " & _
   				      "TR.GR {background:#E5E5E5} " & _
   				      "TH {width:120px;text-align:left} " & _
   				      "A {text-decoration:none} " & _
                     "A:link {color:#213F7E} " & _
   				      "A:hover {color:#000000} " & _
   				      "A:visited {color:#213F7E}" & _
                  "</STYLE>" & vbCrLf & _
               "</HEAD>" & _
               "<BODY><DIV><SPAN class=INFO>Event Log on " & strComputer & "</SPAN><BR>" & _
               "<SPAN>" & dtmDateStart.GetVarDate & " - " & dtmDateEnd.GetVarDate & "</SPAN></DIV>" & vbCrLf

'В случае ошибок в работе
If strErrInfo<>"" Then
	strMailBody = strMailBody & "<DIV><SPAN class=ERR>" & strErrInfo & "</SPAN></DIV>" & vbCrLf
End If

Wscript.Echo "EventsCount: " & colLoggedEvents.Count

'Если существуют выбранные события из журналов
If colLoggedEvents.Count > 0 Then	
	For Each objEvent in colLoggedEvents
		'Превод даты/времени события
		dtmDateTime.Value = objEvent.TimeWritten

      'Подготовка описания события и разметка при необходимости
      strInsertionStrings = ""
      If objEvent.Message <> Noting Then
         strTmpMessage = Replace(objEvent.Message, Chr(13) & Chr(10), "<BR>")
      Else
         strTmpMessage = "n/d"
         For Each strInsertionString in objEvent.InsertionStrings
            strInsertionStrings = strInsertionStrings & strInsertionString & "<BR>"
         Next
         strInsertionStrings = "<TR><TH>Insertion Strings: </TH><TD>" & strInsertionStrings &"</TD></TR>"
      End If

		'HTML разметка текста письма с выборкой данных по событию
		strMailBody = strMailBody & _
         "<TABLE border=1 bordercolor=#c0c0c0 cellPadding=3 >" & _
   			"<TR>" & _
               "<TH>Log file: </TH>" & _
               "<TD>" & objEvent.Logfile & "</TD>" & _
            "</TR>" & _
   			"<TR class=GR >" & _
               "<TH>Event Type: </TH>" & _
   				"<TD><A href=" & Chr(34) & "http://eventid.net/display.asp?eventid=" & objEvent.EventCode & _
   				"&source=" & objEvent.SourceName & Chr(34) & " title=" & Chr(34) & "Поиск на eventid.net" & Chr(34) & ">" & _
   				objEvent.Type & "</A></TD>" & _
            "</TR>" & _
   			"<TR>" & _
               "<TH>Time Written: </TH>" & _
               "<TD>" & dtmDateTime.GetVarDate & "</TD>" & _
            "</TR>" & _
   			"<TR class=GR >" & _
               "<TH>Source Name: </TH>" & _
   				"<TD>" & objEvent.SourceName & "</TD>" & _
            "</TR>" & _
   			"<TR>" & _
               "<TH>Event Code: </TH>" & _
   				"<TD>" & objEvent.EventCode & "</TD>" & _
            "</TR>" & _
   			"<TR class=GR >" & _
               "<TH>Message: </TH>" & _
               "<TD>" & strTmpMessage &"</TD>" & _
            "</TR>" & _
            strInsertionStrings & _
         "</TABLE>" & _
         "<BR>" & vbCrLf
 	Next
End IF

'HTML разметка текста письма
strMailBody = strMailBody & "<DIV class=GRAY>Form script on " + objSysInfo.ComputerName + "</DIV></BODY></HTML>"

If (colLoggedEvents.Count > 0 or strErrInfo<>"") Then
	Err.Clear
	'Завершение подготовки и отправка письма
	With objEmail
		.From = strSendFrom
		.To = strSendTo
		If strErrInfo = "" Then
			.Subject = strMailSubj
		Else
			.Subject = strMailSubj & " (with ERR)"
		End If
		.BodyPart.Charset = "windows-1251" 
		.HTMLBody = strMailBody
		With .Configuration.Fields
			.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
			.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = SMTPServ
			.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = SMTPPort
			.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = strSendName
			.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = SMTPAuth
			.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = strSendPswd
			.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = SMTPSSL
			.Update
		End With
		.Send
	End With
	'Если водникает ошибка при отправлении письма, что бы не потерять период возвращаем старую дату
	If Err.Number Then
		Set txtStreamOutput = objFSO.OpenTextFile(strLastRunDTFileName, ForWriting, True)
		txtStreamOutput.WriteLine (strLastRunDT)
	End If
End If