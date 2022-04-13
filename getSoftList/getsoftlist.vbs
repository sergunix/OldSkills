' Скрипт по сбору информации об установленном ПО
' информация берется из ветки реестра
' HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall

'On Error Resume Next

Const HKEY_LOCAL_MACHINE = &H80000002
Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8

SucsCount = 0
CompCount = 0
ErrCount = 0

Set objFSO = CreateObject("Scripting.FileSystemObject")
'открываем для чтения список проверяемых компьютеров
Set objCompListFile = objFSO.OpenTextFile("computers.lst", ForReading, True)

' Массив ключей выводимых в CSV-Файл
arrFindKeys = Array("DisplayName", "DisplayVersion", "InstallDate")

'Проходим весь список компьтеров
Do While Not objCompListFile.AtEndOfStream

	'Получаем имя проверяемого компьютера
	strComputer = objCompListFile.ReadLine
	
	Set objSoftListFile = objFSO.OpenTextFile("reports\" & strComputer & ".csv", ForWriting, True)
	' указываем что objReg будет лезть в реестр и достанем SubKeys
	Set objReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
	If Err.Number = 0 Then
		' Указываем куда в реестре мы полезем
		strKeyPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
		objReg.EnumKey HKEY_LOCAL_MACHINE, strKeyPath, arrSubKeys
		' Перебор subkey в массиве arrSubKeys, шаримся по подразделам Uninstall'a
		For Each subkey In arrSubKeys
			strKeyPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" & subkey
			'Ищем в подразделах строковый первый строковый параметр массива
			objReg.GetExpandedStringValue HKEY_LOCAL_MACHINE, strKeyPath, arrFindKeys(0), StrValue
			'Если он пуст считается что ветка битая
			If strValue <> Empty Then
				StrOutPut = strComputer& ";" & StrValue & ";"
				'Перебираем масив необходимых ключей
				For CounterI = 1 to UBound(arrFindKeys)
					'Выдираем из реестра его значение - strValue
					objReg.GetExpandedStringValue HKEY_LOCAL_MACHINE, strKeyPath, arrFindKeys(CounterI), StrValue
					StrOutPut = StrOutPut & StrValue & ";"
				Next
				objSoftListFile.Writeline StrOutPut
			End If
		Next
		SucsCount = SucsCount + 1
	Else
		objSoftListFile.Writeline "Ошибка " & Err.Number & " - " & Err.Description
		Err.Clear
		ErrCount = ErrCount + 1
	End If
	CompCount = CompCount + 1
Loop

MsgBox	"Постоение отчетов по установленному ПО завершено!" & Chr(13) & _
	Chr(13) & _
	"Всего компьютеров: " & CompCount & Chr(13) & _
	"Успешных отчетов: " & SucsCount & Chr(13) & _
	"Отчетов с ошибками: " & ErrCount, vbOKOnly, "Information"