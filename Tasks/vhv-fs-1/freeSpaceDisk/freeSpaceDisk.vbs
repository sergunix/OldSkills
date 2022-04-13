'«апускать с параметрами:
'   all      - мес€чный отчет письмо отправл€етс€ вне независимости от заполнени€ диска
'   normal  - ежедневна€ работа, письмо отправл€тс€ только в случае переполнени€ диска

Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8

Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20

SMTPServ = "10.9.108.105"
SMTPPort = 25
SMTPAuth = 0   'јутентификаци€: 0 Ц без аутентификации, 1 - базова€, 2 Ц NTLM
SMTPSSL  = False

strSendName = "Script"
strSendFrom = "freeSpaceDisk@vhv.ltg.gazprom.ru"
strSendPswd = ""
strSendTo   = "vhvadmin@vhv.ltg.gazprom.ru"
strMailSubj = "Low disk space"

boolSentMail = False

Set objFSO       = CreateObject("Scripting.FileSystemObject")
Set objStreamLog = objFSO.OpenTextFile(objFSO.GetParentFolderName(WScript.ScriptFullName) & "\scriptlog.log", ForWriting, True)
objStreamLog.WriteLine (Now & vbTab & WScript.ScriptFullName)

Set objArgs = WScript.Arguments
if objArgs.Count > 0 Then
   On Error Resume Next

   'ќбъекты
   Set objSysInfo = CreateObject( "WinNTSystemInfo" )
   Set objEmail   = CreateObject("CDO.Message")
   Set objStreamConfig = objFSO.OpenTextFile(objFSO.GetParentFolderName(WScript.ScriptFullName) & "\config.txt", ForReading, True)

   strMailBody = "<HTML>" & vbCrLf & _
                     "<HEAD>" & vbCrLf & _
                       "<STYLE>" & vbCrLf & _
                         "BODY {font-family:tahoma;font-size:4pt;font-weight:bold}" & vbCrLf & _
                         "DIV {font-size:10pt;margin-bottom:0mm;margin-top:3mm;text-align:left}" & vbCrLf & _
                         "DIV.GRAY {color:#C0C0C0;font-weight:normal}" & vbCrLf & _
                         "SPAN {font-size:12pt}" & vbCrLf & _
                         "SPAN.ERR {font-size:10pt;color:#D92128}" & vbCrLf & _
                         "HR {width:640px;text-align:left;margin-top:0mm}" & vbCrLf & _
                         "TABLE {width:640px;border-collapse:collapse}" & vbCrLf & _
                         "TR {vertical-align:top;font-size:8pt;}" & vbCrLf & _
                         "TD {text-align:center}" & vbCrLf & _
                         "TD.GREEN {background:#99CC00}" & vbCrLf & _
                         "TD.RED {background:#FF0000}" & vbCrLf & _
                         "TD.GREY {background:#C0C0C0}" & vbCrLf & _
                         "A {text-decoration:none}" & vbCrLf & _
                         "A:link {color:#000000}" & vbCrLf & _
                         "A:hover {color:#213F7E}" & vbCrLf & _
                         "A:visited {color:#000000}" & vbCrLf & _
                       "</STYLE>" & vbCrLf & _
                     "</HEAD>" & vbCrLf & _
                     "<BODY>" & vbCrLf & _
                     "<DIV><SPAN>Low disk space</SPAN><BR>" & Now & "</DIV>" & vbCrLf
   
   Do While not objStreamConfig.AtEndOfStream
      arrayConfig = Split(objStreamConfig.ReadLine, Chr(9))   'сделаем массив c параметрами

      strMailBodyCurSVR = ""
      
      Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & arrayConfig(0) & "\root\cimv2")
      Set colItems = objWMIService.ExecQuery("SELECT SystemName, Caption, Size, FreeSpace FROM Win32_LogicalDisk", "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)

      For Each objItem In colItems
         For counterI = 1 to UBound(arrayConfig)
            intSize  = 1
            intFree  = 1
            intQuota = 1
            k        = 1
            If Left(objItem.Caption, 1) = Left(arrayConfig(counterI), 1) Then
               intSize  = Round(objItem.Size/(1024 * 1024 * 1024), 2)
               intFree  = Round(objItem.FreeSpace/(1024 * 1024 *1024), 2)
               intQuota = Round(Right(arrayConfig(counterI), Len(arrayConfig(counterI))-2), 2)
               k = 640/intSize
               objStreamLog.WriteLine (Now & vbTab & objItem.SystemName & vbTab & objItem.Caption & " free " & objItem.FreeSpace & " of " & objItem.Size)

               Select Case  LCase(objArgs(0))
               Case "normal"
                  If (intFree < intQuota) and Err.Number <> 462 Then
                     strMailBodyCurSVR = strMailBodyCurSVR & _
                        "<TABLE border=1 bordercolor=black cellPadding=3>" & vbCrLf & _
                           "<TR><TH colSpan=3><A href=" & Chr(34) & "\\" & arrayConfig(0) & "\" & Left(objItem.Caption, 1) & "$\" & Chr(34) & ">" & _
                           "Drive " & objItem.Caption & " " & intSize & "&nbsp;Gb (Quota: " & Round(intQuota, 2) & "&nbsp;Gb)</A></TH></TR>" & vbCrLf & _
                           "<TR>" & vbCrLf & _
                              "<TD width=" & Round(k * (intSize - intQuota)) & " class=GREEN>" & Round(intSize - intQuota, 2) & "&nbsp;Gb</TD>" & vbCrLf & _
                              "<TD class=RED>" & Round(intQuota - intFree, 2) & "&nbsp;Gb</TD>" & vbCrLf & _
                              "<TD width=" & Round(k * intFree) & " class=GREY>" & intFree & "&nbsp;Gb</TD>" & vbCrLf & _
                           "</TR>" & vbCrLf & _
                        "</TABLE><BR>" & vbCrLf
                     boolSentMail = true
                  End If
               Case "all"
                  If Err.Number = 0 Then
                          strMailBodyCurSVR = strMailBodyCurSVR & _
                          "<TABLE border=1 bordercolor=black cellPadding=3>" & vbCrLf & _
                             "<TR><TH colSpan=3><A href=" & Chr(34) & "\\" & arrayConfig(0) & "\" & Left(objItem.Caption, 1) & "$\" & Chr(34) & ">" & _
                                "Drive " & objItem.Caption & " " & intSize & "&nbsp;Gb (Quota: " & Round(intQuota, 2) & "&nbsp;Gb)</A></TH></TR>" & vbCrLf & _
                             "<TR>" & vbCrLf
                          If (intFree < intQuota) Then
                             strMailBodyCurSVR = strMailBodyCurSVR & _
                                "<TD width=" & Round(k * (intSize - intQuota)) & " class=GREEN>" & Round(intSize - intQuota, 2) & "&nbsp;Gb</TD>" & vbCrLf & _
                                "<TD class=RED>" & Round(intQuota - intFree, 2) & "&nbsp;Gb</TD>" & vbCrLf & _
                                "<TD width=" & Round(k * intFree) & " class=GREY>" & intFree & "&nbsp;Gb</TD>" & vbCrLf               
                          Else
                             strMailBodyCurSVR = strMailBodyCurSVR & _
                                "<TD width=" & Round(k * (intSize - intFree)) & " class=GREEN>" & Round(intSize - intFree, 2) & "&nbsp;Gb</TD>" & vbCrLf & _
                                "<TD width=" & Round(k * (intFree - intQuota)) & ">&nbsp;</TD>" & vbCrLf & _
                                "<TD width=" & Round(k * intQuota) & " class=GREY>" & intQuota & "&nbsp;Gb</TD>" & vbCrLf   
                          End If
                          strMailBodyCurSVR = strMailBodyCurSVR & _   
                             "</TR>" & vbCrLf & _
                             "</TABLE><BR>" & vbCrLf
                  Else
                    strMailBodyCurSVR = "<SPAN class=" & Chr(34) & "ERR" & Chr(34) & "> " & Err.Description & " (" & Err.Number & " " & Err.Source & ")</SPAN>"
                  End If
               End select
            End If
         Next
      Next
      If strMailBodyCurSVR <> "" Then
         strMailBody = strMailBody & _
                       "<DIV>" & UCase(arrayConfig(0)) & "<HR></DIV>" & vbCrLf & _
                       strMailBodyCurSVR
      End If
      Set objWMIService = Nothing
      Set colItems = Nothing
      Err.Clear
   Loop
   
   strMailBody = strMailBody & _
      "<DIV class=GRAY>Form script on " + objSysInfo.ComputerName + "</DIV>" & vbCrLf & _
      "</BODY>" & vbCrLf & _
      "</HTML>"
   
   'Wscript.Echo strMailBody
   
   If boolSentMail or LCase(objArgs(0)) = "all" Then
      With objEmail
         .From = strSendFrom
         .To = strSendTo
      	If LCase(objArgs(0)) = "all" Then
               .Subject = strMailSubj & " Month"
      	Else
      		.Subject = strMailSubj
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
   End If
End If