' ������ �� ����� ���������� �� ������������� ��
' ���������� ������� �� ����� �������
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
'��������� ��� ������ ������ ����������� �����������
Set objCompListFile = objFSO.OpenTextFile("computers.lst", ForReading, True)

' ������ ������ ��������� � CSV-����
arrFindKeys = Array("DisplayName", "DisplayVersion", "InstallDate")

'�������� ���� ������ ����������
Do While Not objCompListFile.AtEndOfStream

	'�������� ��� ������������ ����������
	strComputer = objCompListFile.ReadLine
	
	Set objSoftListFile = objFSO.OpenTextFile("reports\" & strComputer & ".csv", ForWriting, True)
	' ��������� ��� objReg ����� ����� � ������ � �������� SubKeys
	Set objReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
	If Err.Number = 0 Then
		' ��������� ���� � ������� �� �������
		strKeyPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
		objReg.EnumKey HKEY_LOCAL_MACHINE, strKeyPath, arrSubKeys
		' ������� subkey � ������� arrSubKeys, ������� �� ����������� Uninstall'a
		For Each subkey In arrSubKeys
			strKeyPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" & subkey
			'���� � ����������� ��������� ������ ��������� �������� �������
			objReg.GetExpandedStringValue HKEY_LOCAL_MACHINE, strKeyPath, arrFindKeys(0), StrValue
			'���� �� ���� ��������� ��� ����� �����
			If strValue <> Empty Then
				StrOutPut = strComputer& ";" & StrValue & ";"
				'���������� ����� ����������� ������
				For CounterI = 1 to UBound(arrFindKeys)
					'�������� �� ������� ��� �������� - strValue
					objReg.GetExpandedStringValue HKEY_LOCAL_MACHINE, strKeyPath, arrFindKeys(CounterI), StrValue
					StrOutPut = StrOutPut & StrValue & ";"
				Next
				objSoftListFile.Writeline StrOutPut
			End If
		Next
		SucsCount = SucsCount + 1
	Else
		objSoftListFile.Writeline "������ " & Err.Number & " - " & Err.Description
		Err.Clear
		ErrCount = ErrCount + 1
	End If
	CompCount = CompCount + 1
Loop

MsgBox	"��������� ������� �� �������������� �� ���������!" & Chr(13) & _
	Chr(13) & _
	"����� �����������: " & CompCount & Chr(13) & _
	"�������� �������: " & SucsCount & Chr(13) & _
	"������� � ��������: " & ErrCount, vbOKOnly, "Information"