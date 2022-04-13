'Рекурсии нет!!! Ходим только в одном контейнере!!!
'cscript.exe getComputersEventsList.vbs -A 
'cscript.exe getComputersEventsList.vbs -f 

'Запускать скрипт только в консоли
If Not UCase( Mid( WScript.FullName, InStrRev(WScript.FullName, "\") + 1 ) ) = "CSCRIPT.EXE" Then
   set objShell = CreateObject("wscript.shell")
   set objArgs = WScript.Arguments
   For Each strArgument In objArgs
      strAllArguments = " " + strArgument
   Next
   objShell.Run "cscript.exe //nologo " & Chr(34) & wscript.scriptfullname & Chr(34) & strAllArguments
   WScript.Quit
End If

'On Error Resume Next

Const numPeriodDays = 14
Const CONVERT_TO_LOCAL_TIME = True
Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8

Set objArgs = WScript.Arguments
Set objFSO = CreateObject("Scripting.FileSystemObject")

strReportPath = objFSO.GetParentFolderName(WScript.ScriptFullName) & "\" & WScript.ScriptName & "-report-" & CurrentDateTime & ".csv"
strLogPath = objFSO.GetParentFolderName(WScript.ScriptFullName) & "\" & WScript.ScriptName & "-failed-" & CurrentDateTime & ".txt"

'Проверка аргументов и/или Вывод справки
If objArgs.Count = 2 Then
   strType = UCase(objArgs(0))
   strPath = objArgs(1)

   If (strType = "-A") or (strType = "--A") or (strType = "/A") Then
      strType = "A"
   End If

   If (strType = "-F") or (strType = "--F") or (strType = "/F") Then
      strType = "F"
   End If

   Select Case strType
      Case "A"
         Set objVHVComputers = GetObject (strPath)
         If Err.Number <> 0 Then
            WScript.Echo "Ошибка " & Err.Number & ": " & Err.Description
            EchoHelp()
         End If  
      Case "F"
         If not objFSO.FileExists (strPath) Then
            WScript.Echo "Ошибка - Неудается найти файл " & strPath
            EchoHelp()
         End If
      Case Else
         EchoHelp()
   End Select  
Else
   EchoHelp()
End If 

WScript.Echo Now & Chr(9) & "Start " & WScript.ScriptName & " (Period: " & numPeriodDays & "days)"

Set ReportFile = objFSO.CreateTextFile(strReportPath, true)
Set FailedLogFile = objFSO.CreateTextFile(strLogPath, true)

Set dtmDateTime = CreateObject("WbemScripting.SWbemDateTime")
Set dtmDateStart = CreateObject("WbemScripting.SWbemDateTime")

dtmDateStart.SetVarDate NOW - numPeriodDays, CONVERT_TO_LOCAL_TIME

ReportFile.WriteLine Chr(34) & "ComputerName" & Chr(34) & ";" & _
                     Chr(34) & "Logfile" & Chr(34) & ";" & _
                     Chr(34) & "EventType" & Chr(34) & ";" & _
                     Chr(34) & "SourceName" & Chr(34) & ";" & _
                     Chr(34) & "TimeWritten" & Chr(34) & ";" & _
                     Chr(34) & "EventCode" & Chr(34)

Select Case strType
   Case "A"
      'Support Tools - ADSI Edit
      Set objVHVComputers = GetObject (strPath)
      ' Идём по всем элементам в контейнере
      For Each obj In objVHVComputers
      	' Cмотрим стОит ли выводить информацию в отчет.
      	If (obj.Class = "computer") Then
            getComputerEventsList(Right(obj.Name, Len(obj.Name) - 3))
      	End If
      Next
   Case "F"
      'Проверяем все компьютеры из файла
      Set ComputerListFile = objFSO.OpenTextFile (strPath, ForReading, True)
      Do While Not ComputerListFile.AtEndOfStream
         getComputerEventsList(ComputerListFile.ReadLine)
      Loop
End Select

WScript.Echo Now & Chr(9) & "Stop " & WScript.ScriptName & " - Export done" & vbCrLf & _
             Now & Chr(9) & "Report file name: " & strReportPath & vbCrLf & _
             Now & Chr(9) & "Unsuccesed Log file name: " & strLogPath

ReportFile.Close
FailedLogFile.Close

Sub getComputerEventsList(strComputer)
   If Ping (strComputer) Then
      Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
      'EventType: 1 - Error; 2 - Warning; 4 - Information; 8 - Security audit success; 16 - Security audit failure;
      If Err.Number = 0 Then
         Set colLoggedEvents = objWMIService.ExecQuery _
            ("Select * from Win32_NTLogEvent Where " & _
         	"( Logfile = 'SYSTEM' or Logfile = 'APPLICATION' or Logfile = 'SECURITY' or " & _
         	"Logfile = 'File Replication Service' or Logfile = 'Directory Service') and " & _
         	"( EventType = '1' or EventType = '2' or " & _
         	"EventCode = '36' or EventCode = '644' or " & _
         	"EventCode = '4015' or EventCode = '13508' or EventCode = '13568') and " & _
         	"( TimeWritten >= '" & dtmDateStart & "')")
         If colLoggedEvents.Count > 0 Then
         	For Each objEvent in colLoggedEvents
               dtmDateTime.Value = objEvent.TimeWritten
               ReportFile.WriteLine Chr(34) & strComputer & Chr(34) & ";" & _
                                    Chr(34) & objEvent.Logfile & Chr(34) & ";" & _
                                    Chr(34) & objEvent.Type & Chr(34) & ";" & _
         			                  Chr(34) & objEvent.SourceName & Chr(34) & ";" & _
         			                  Chr(34) & dtmDateTime.GetVarDate & Chr(34) & ";" & _
                                    Chr(34) & objEvent.EventCode & Chr(34)
      	   Next 
         End If
         WScript.Echo Now & Chr(9) & FormatOutputStr(strComputer, 16) & "Succesed (EventCount: " & colLoggedEvents.Count & ")"
         Set colLoggedEvents = Nothing
      Else
         WScript.Echo Now & Chr(9) & FormatOutputStr(strComputer, 16) & "Failed"
         FailedLogFile.WriteLine strComputer
         Err.Clear
      End If
      Set objWMIService = Nothing
   Else
      WScript.Echo Now & Chr(9) & FormatOutputStr(strComputer, 16) & "Host is down"
      FailedLogFile.WriteLine strComputer
   End If
End Sub

'Вывод справки
Sub EchoHelp
   WScript.Echo
   WScript.Echo "Скрипт сбора ошибок и предупреждений из журналов событий"
   WScript.Echo
   WScript.Echo WScript.ScriptName & " [/F|/A] <имя_файла/контейнер_LDAP>"
   WScript.Echo "/F" & Chr(9) & "сбор информации из журналов компьютеров указанных в файле"
   WScript.Echo "/A" & Chr(9) & "сбор информации из журналов компьютеров распологающихся в указанном контейнере LDAP"
   WScript.Echo
   WScript.Echo "Вывод информации производится в файлы вида:"
   WScript.Echo strReportPath
   WScript.Echo strLogPath
   WScript.Sleep 1000
   WScript.Quit
End Sub

' Функция возвращает текущую дату в виде yyyy-mm-dd-hh-mm
Function CurrentDateTime()
	CurrentDateTime = Year(Now()) & "-" & Month(Now()) & "-" & Day(Now()) & "-" & Hour(Now()) & "-" & Minute(Now())
End Function

' Форматирование вывода таблицы в консоль
Function FormatOutputStr(strOutput, intStrLength)
   If Len(strOutput) > intStrLength - 1 Then
      FormatOutputStr = Left(strOutput, intStrLength - 1) & "}"
   Else
      FormatOutputStr = strOutput & Space(intStrLength - Len(strOutput))
   End If
End Function

Function Ping(strHostName)
   strQuery = "SELECT * FROM Win32_PingStatus WHERE Address = '" & strHostName & "'"
   Set colPingResults = GetObject("winmgmts://./root/cimv2").ExecQuery( strQuery )
   ' Translate the query results to either True or False
   For Each objPingResult In colPingResults
       If Not IsObject( objPingResult ) Then
          Ping = False
       ElseIf objPingResult.StatusCode = 0 Then
          Ping = True
       Else
          Ping = False
       End If
   Next
   Set colPingResults = Nothing
End Function