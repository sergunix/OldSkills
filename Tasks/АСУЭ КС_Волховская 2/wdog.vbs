' Параметры wdog.vbs
boolCanWork = true

' Проверяемый процесс, Выполняемая команда
strChkProcess = "ScadaRTM.exe"
' strExecCmdLine Строка запуска, если проверяемый процесс не найден
strExecCmdLine = "E:\TM608\ScadaRTM.exe"
strLogFileName = "wdog.vbs.log"
' Время проверки существования процесса в минутах
intTimer = 5


' =[wdog.vbs]==================================================
Const ForAppending = 8

If Not UCase( Mid( WScript.FullName, InStrRev(WScript.FullName, "\") + 1 ) ) = "CSCRIPT.EXE" Then
   Set objShell = CreateObject("wscript.shell")
   objShell.Run "cscript.exe //nologo " & Chr(34) & WScript.ScriptFullName & Chr(34)
   WScript.Quit
End If

Set objFSO = CreateObject("Scripting.FileSystemObject")
strLogFileName = objFSO.GetParentFolderName(WScript.ScriptFullName) & "\" & strLogFileName
Set objLogFile = objFSO.OpenTextFile(strLogFileName, ForAppending, True)

objLogFile.WriteLine
Log("Start " & WScript.ScriptFullName)

On Error Resume Next

Do While boolCanWork
   WScript.Sleep(intTimer*60000)

   Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
   strQuery = "SELECT * FROM Win32_Process Where Caption = '" & strChkProcess & "'"
   Set colItems = objWMIService.ExecQuery(strQuery, "WQL")

   If colItems.Count = 0 Then
      Log("Process " & strChkProcess & " not found")
      Set objShell = WScript.CreateObject("WScript.Shell")
      Log("Try to execute " & strExecCmdLine)
      objShell.Run strExecCmdLine
      If Err.Number = 0 Then
         Log ("Successfully execute " & strChkProcess)
      Else
         Log ("Fail of execute " & strChkProcess & " ERROR " & Err.Number & " " & Err.Description)
      End If
   End If

   Set colItems = Nothing
   Set objWMIService = Nothing
   Err.Clear
Loop

Log("Stop " & WScript.ScriptFullName)

Sub Log (strEvent)
   objLogFile.WriteLine Now & Chr(9) & strEvent
   WScript.Echo Now & Chr(9) & strEvent
End Sub