<# 
 
GeneratePrintJobAccountingReports.ps1
вер. 2014-09-26-01
 
Скрипт считывает идентификатор журнала событий 307 и ID 805 из журнала «Журналы приложений и служб> Microsoft> Windows> PrintService"
с указанного сервера и за указанный период времени, а затем вычисляет данные задания печати и общего количества страниц из этих
записи журнала событий.
 
Затем он записывает выходные данные в два файла .CSV, один из которых показывает данные задания печати, а другой показывает данные задания печати по запросу.
 
Скрипт зависит от конкретных данных журнала событий и текста в регистрационных данных журнала событий 307 и 805 и был протестирован только на
Windows Server 2008 R2 с пакетом обновления 1 (SP1).
 
Требования:
- Убедитесь, что установлена ​​.NET Framework 3.5 или более поздняя версия:
  - Добавить «.NET Framework 3.5.1» в разделе «Возможности .NET Framework 3.5.1» с помощью опции «Добавить функции» диспетчера сервера или
  - Все программы> Стандартные> Windows PowerShell> щелкните правой кнопкой мыши Windows PowerShell> Запуск от имени администратора ...
    Импорт-модуль ServerManager
    Add-WindowsFeature NET-Framework-Core
- Включить и настроить запись событий задания печати на нужном сервере печати:
  - запустите устройства и принтеры> (выделите любой принтер)> Свойства сервера печати> Дополнительно
    - установите флажок «Показывать информационные уведомления для локальных принтеров»
    - установите флажок «Показывать информационные уведомления для сетевых принтеров»
      - ОК
  - запустить средство просмотра событий> Журналы приложений и служб> Microsoft> Windows> PrintService
    - щелкните правой кнопкой мыши Operational> Enable Log
    - щелкните правой кнопкой мыши Operational> Properties> Maximum log size (KB): 65536 (по умолчанию было 1028 КБ)
      - ОК
- Убедитесь, что учетная запись пользователя, используемая для запуска сценария, имеет разрешение на запись в целевой каталог, который будет содержать
  вывода .CSV-файлы ("D: \ Scripts \" в коде ниже). Измените пути .CSV и имена файлов в приведенном ниже коде.
- Если сервер печати является удаленным сервером, убедитесь, что учетная запись пользователя, используемая для запуска скрипта, имеет удаленный вызов процедуры
  сетевой доступ к указанному имени хоста и что правила брандмауэра разрешают такой доступ к сети.
- Если сервер печати регистрирует события с использованием языка, отличного от английского, настройте строку поиска сообщения ID 805 ниже
  для соответствия строке, соответствующей языку, используемой в сообщении журнала событий события 805 сервера печати.
 
Применение:
- см. функцию PrintCommandLineUsage, ниже
 
Коды выхода:
- errorlevel 0 указывает на отсутствие ошибки (записи были найдены и сгенерированы, или записи не найдены)
- errorlevel 1 указывает на ошибку (неповторимые параметры командной строки или отсутствующие записи журнала событий ID 805)
 
Замечания по внедрению:
- Принтер HP LaserJet P2055dn с использованием драйвера HP Universal Printing PCL 5 (v5.2)
    Принтер сообщает 0 копий на все задания.
    Если задание на печать, сообщающее 0 копий, видно сценарию, оно выдаст предупреждение, а затем рассмотрит проблему 
    Исправление для этого конкретного случая состояло в том, чтобы обновить драйвер печати до драйвера HP Universal Printing PCL 5 (v5.5.0).
- Случай цветного принтера HP LaserJet Pro 400 модели M451dn (CE957A) с использованием драйвера HP Universal Printing PCL 6 (v5.0.3),
  драйвер HP Universal Printing PCL 5 (v5.2) и драйвер HP Universal Printing PS (v.5.0.3):
    Во всех случаях этот принтер сообщает о 1 копии всех заданий в событии 805, даже когда пользователь печатает более одной копии задания.
    Сценарий не может обнаружить это. Это было обнаружено через наблюдение.
    Исправлено удаление свойств принтера «Совместное использование» и «Отправка заданий печати на клиентских компьютерах» (по умолчанию это _enabled_).
    При этом изменении количество экземпляров на одно задание было точно указано в журнале событий Windows.
    ПРЕДЛОЖЕНИЕ: проверьте сгенерированный файл .CSV в первый месяц и посмотрите проверку принтеров, которые только когда-либо сообщают о 1 копии всех заданий. Эти
      принтеры могут нуждаться в обходе для рендеринга на стороне сервера.
 
История:
- 2010-02 Оригинальный сценарий, написанный Sh_Con по адресу http://social.technet.microsoft.com/Forums/en-US/ITCG/thread/007be664-1d8d-461c-9e0b-d8177106d4f8
- 2011-05 Обновлено BSOD2600 по адресу http://social.technet.microsoft.com/Forums/en-US/ITCG/thread/007be664-1d8d-461c-9e0b-d8177106d4f8
- 2011-10 Обновлено Tim Miller Dyck в WorldWorks Technology Solutions, чтобы включить количество копий в учетные записи страниц, сопоставив их с
    Идентификатор события 805, добавьте целевое имя сервера и имя сервера целевого сервера печати, добавьте отчет об общих страницах пользователей и переключите кодировку с
    Unicode для ASCII для лучшей совместимости Excel .CSV.
    Благодаря Центральному комитету Mennonite Canada за спонсорство этой дополнительной разработки.
- 2012-09 Обновлено Tim Miller Dyck в WorldWorks Technology Solutions включает предупреждение о том, что задания на печать сообщают о нулевых копиях,
    добавьте предупреждение о том, что некоторые задания печати неправильно сообщают одну копию, когда было напечатано более одной копии, добавьте идентификационный номер задания на печать
    на выход .CSV и изменить запятые в имени задания печати, чтобы подчеркнуть для более надежного анализа .CSV с некоторыми клиентами.
- 2014-09. Модифицировано Тимом Миллером Диком в WorldWorks Technology Solutions для добавления дополнительных предупреждающих протоколов и надежности для редких случаев, когда
    сообщения о событиях 805 сообщений регистрируются либо 0, либо более одного раза для одного и того же задания печати; добавить недопустимое обращение к символам имен документов и PreviousDay
    улучшения, предложенные комментаторами по адресу http://gallery.technet.microsoft.com/scriptcenter/Script-to-generate-print-84bdcf69/view/Discussions#content
#> 
 
##### 
 
Set-StrictMode -version 2 
 
##### 
# определить начальные переменные
 
$PrintJobCounter = 1                      # console display output counter 
$PerUserTotalPagesRecords = @{}           # create empty hash table 
 
##### 
# Объявление вспомогательных функций 
 

Function PrintCommandLineUsage { 
    Write-Host " 
 
Параметры 
  (hostname) PreviousMonth -- Получение данных о заданиях печати на (hostname) за предыдущий месяц
     
  (hostname) PreviousDay -- Получение данных о заданиях печати на (hostname) за предыдущий день 
    
  (hostname) (startdate) (enddate) -- Получение данных о заданиях печати на (hostname) 
                                      за указанный период.
                                      Даты указываются в формате соответсвующем текущей локализации на хосте
                                      (например dd/mm/yyyy для России). 
 
Примеры: 
  powershell.exe -command `".\GeneratePrintJobAccountingReports.ps1 localhost PreviousMonth`"
  powershell.exe -command `".\GeneratePrintJobAccountingReports.ps1 localhost PreviousDay`" 
  powershell.exe -command `".\GeneratePrintJobAccountingReports.ps1 printserver.domain.local 01/01/2018 01/02/2018`" 
 
"
powershell.exe -command `".\GeneratePrintJobAccountingReports.ps1 localhost PreviousDay`" 
} 
 
##### 
# получение параметров командной строки 
 
switch ($args.count) { 
    {($_ -eq 2) -or ($_ -eq 3)} { 
        # если есть два или три параметра, первым параметром является имя хоста сервера печати, из которого будут извлекаться журналы событий 
        $PrintServerName = $args[0] 
        Write-Host "Print server hostname to query:" $PrintServerName 
    } 
    2 { 
        # если есть ровно два параметра, проверьте, что второй - «PreviousMonth» или «PreviousDay» (используя сравнение по умолчанию без учета регистра)
        if ($args[1].CompareTo("PreviousMonth") -eq 0) { 
            # время начала - в (00:00:00) первого дня предыдущего месяца 
            $StartDate = (Get-Date -Day 1 -Hour 0 -Minute 0 -Second 0).AddMonths(-1) 
            # время окончания -  (23:59:59) последнего дня предидущего месяца 
            $EndDate = (Get-Date -Day 1 -Hour 0 -Minute 0 -Second 0) - (New-Timespan -Second 1) 
        } 
        elseif ($args[1].CompareTo("PreviousDay") -eq 0) { 
            # время начала - в (00:00:00) предыдущего дня
            $StartDate = (Get-Date -Hour 0 -Minute 0 -Second 0).AddDays(-1) 
            # время окончания -  (23:59:59)предидущего дня 
            $EndDate = (Get-Date -Hour 23 -Minute 59 -Second 59).AddDays(-1) 
        } 
        else { 
            # Если параметр неизвестен то завершение с кодом ошибки 1 
            Write-Host "`nERROR: Two command-line parameters were detected but the second comand-line parameter was not `"PreviousMonth`" or `"PreviousDay`"."
            PrintCommandLineUsage 
            Exit 1 
        } 
    } 
    3  { 
       # если имеется ровно три параметра, проверьте, что второй и третий являются датами 
        $ErrorActionPreference = "SilentlyContinue" 
        # время начала - в начале указанной даты (00:00:00) 
        $StartDate = Get-Date -Date $args[1] 
        # проверка, был ли параметр командной строки признан действительной датой 
        if (!$?) { 
            # Если параметр неизвестен то завершение с кодом ошибки 1
            Write-Host "`nERROR: Three command-line parameters were detected but the second comand-line parameter was not a valid date."
            PrintCommandLineUsage 
            Exit 1 
        } 
        # время окончания - в конце указанной даты (23:59:59) - добавить день, а затем вычесть одну секунду
        $EndDate = (Get-Date -Date $args[2]) + (New-Timespan -Day 1) - (New-Timespan -Second 1) 
        # проверка, был ли параметр командной строки признан действительной датой 
        if (!$?) { 
            # Если параметр неизвестен то завершение с кодом ошибки 1
            Write-Host "`nERROR: Three command-line parameters were detected but the third comand-line parameter was not a valid date."
            PrintCommandLineUsage 
            Exit 1 
        } 
        # set error-handling back to default 
        $ErrorActionPreference = "Continue" 
    } 
    default { 
        # Если параметров нет или более 3х 
        Write-Host "`nERROR: No or too many command-line parameters were detected."
        PrintCommandLineUsage 
        Exit 1 
    } 
} 
 
##### 
# определяем имена файлов для вывода *.CSV 
 
$OutputFilenameByPrintJob = "\\vhv-fs-1\software\_NewUpLoad_\PrintJob\" + $StartDate.ToString("yyyy-MM-dd") + " to " + $EndDate.ToString("yyyy-MM-dd") + ".csv"     
            
 
##### 
# Получение записей из журнала событий с ID 307 и 805 
 
# display status message 
Write-Host "Collecting event logs found in the specified time range from $StartDate to $EndDate."
 
# основными событиями задания на печать являются события ID 307 (используйте «-ErrorAction SilentlyContinue» для обработки случая, когда сообщения журнала событий не найдены) 
$PrintEntries = Get-WinEvent -ErrorAction SilentlyContinue -ComputerName $PrintServerName -FilterHashTable @{ProviderName="Microsoft-Windows-PrintService"; StartTime=$StartDate; EndTime=$EndDate; ID=307} 
# количество экземпляров, принадлежащих заданию в событии ID 805  
$PrintEntriesNumberofCopies = Get-WinEvent -ErrorAction SilentlyContinue -ComputerName $PrintServerName -FilterHashTable @{ProviderName="Microsoft-Windows-PrintService"; StartTime=$StartDate; EndTime=$EndDate; ID=805} 
 
# проверить найденные данные; если не было найдено записей журнала событий 307, выход из сценария без создания выходного файла (не является ошибкой)
if (!$PrintEntries) { 
    Write-Host "There were no print job event ID 307 entries found in the specified time range from $StartDate to $EndDate. Exiting script."
    Exit 
} 
 
# Иначе -отобразить количество записей и продолжить 
#   Measure-Object нужен если найдена только 1 запись
Write-Host "  Number of print job event ID 307 entries found:" ($PrintEntries | Measure-Object).Count 
Write-Host "  Number of print job event ID 805 entries found:" ($PrintEntriesNumberofCopies | Measure-Object).Count 
 
# Отображение статуса 
Write-Host "Parsing event log entries and writing data to the by-print job .CSV output file `"$OutputFilenameByPrintJob`"..." 
 
# Запись заголовка выходного файла
Write-Output "Date,Print Job ID,User Name,Full Name,Client PC Name,Printer Name,Document Name,Print Job Size in Bytes,Page Count for One Copy,Number of Copies,Total Pages" | Out-File -FilePath $OutputFilenameByPrintJob -Encoding UTF8
 
##### 
# Запуск цикла для анализа событий ID 307
 
ForEach ($PrintEntry in $PrintEntries) { 
 
    # получить дату и время задания печати из поля TimeCreated 
    $StartDate_Time = $PrintEntry.TimeCreated 
 
    # Конвертировать журнал событий в XML 
    
    try { 
        $entry = [xml]$PrintEntry.ToXml() 
    } 
    catch { 
                $Message = "WARNING: Event log ID 307 event at time $StartDate_Time has unparsable XML contents. This is usually caused by a print job document name that contains unusual characters that cannot be converted to XML. Please investigate further if possible. Skipping this print job entry entirely without counting its pages and continuing on..." 
        Write-Host $Message 
        Write-Output $Message | Out-File -FilePath $OutputFilenameByPrintJob -Encoding UTF8 -Append 
        # немедленно продолжить со следующего сообщения ID 307 события, пропустив сообщение журнала проблемных событий 
        Continue 
    } 
 
    # извлечение выбранных записей из журнала событий 
    $PrintJobId = $entry.Event.UserData.DocumentPrinted.Param1 
    $DocumentName = $entry.Event.UserData.DocumentPrinted.Param2 
    $UserName = $entry.Event.UserData.DocumentPrinted.Param3 
    $ClientPCName = $entry.Event.UserData.DocumentPrinted.Param4 
    $PrinterName = $entry.Event.UserData.DocumentPrinted.Param5 
    $PrintSizeBytes = $entry.Event.UserData.DocumentPrinted.Param7 
    $PrintPagesOneCopy = $entry.Event.UserData.DocumentPrinted.Param8 
 
    # получить имя пользователя из AD
    if ($UserName -gt "") { 
        $DirectorySearcher = New-Object System.DirectoryServices.DirectorySearcher 
        $LdapFilter = "(&(objectClass=user)(samAccountName=${UserName}))" 
        $DirectorySearcher.Filter = $LdapFilter 
        $UserEntry = [adsi]"$($DirectorySearcher.FindOne().Path)" 
        $ADName = $UserEntry.displayName 
    } 
  
   # получить номер задания на печать, сопоставляя записи с идентификатором события 805
     # запись ID 805 всегда регистрируется непосредственно перед (то есть раньше времени), ее связанная запись 307
     # Идентификационный номер задания на печать завершается после достижения 255 
    $PrintEntryNumberofCopies = $PrintEntriesNumberofCopies | Where-Object {$_.Message -eq "Rendering job $PrintJobId." -and $_.TimeCreated -le $StartDate_Time -and $_.TimeCreated -ge ($StartDate_Time - (New-Timespan -second 5))} 
 
    # проверить для ожидаемого случая ровно одну совпадающую запись журнала событий 805 событий для записи события 307 исходного события
     # если это верно, то извлекается количество копий задания печати для соответствующего задания на печать 
    if (($PrintEntryNumberofCopies | Measure-Object).Count -eq 1) { 
        # получить оставшиеся поля из содержимого журнала событий
        $entry = [xml]$PrintEntryNumberofCopies.ToXml() 
        $NumberOfCopies = $entry.Event.UserData.RenderJobDiag.Copies 
        # некоторые принтеры всегда сообщают количество копий равное 0 в этом случае ставится количество копий 1 
        if ($NumberOfCopies -eq 0) { 
            $NumberOfCopies = 1 
            $Message = "WARNING: Printer $PrinterName recorded that print job ID $PrintJobId was printed with 0 copies. This is probably a bug in the print driver. Upgrading or otherwise changing the print driver may help. Guessing that 1 copy of the job was printed and continuing on..." 
            Write-Host $Message 
            Write-Output $Message | Out-File -FilePath $OutputFilenameByPrintJob -Encoding UTF8 -Append 
        } 
    } 
    # иначе было найдено долее одного совпадающего события с ID 805. В этом случае также ставится количество копий 1  
    else { 
        $NumberOfCopies = 1 
        $Message = "WARNING: Printer $PrinterName recorded that print job ID $PrintJobId had $(($PrintEntryNumberofCopies | Measure-Object).Count) matching event ID 805 entries in the search time range from $(($StartDate_Time - (New-Timespan -second 5))) to $StartDate_Time. Logging this as a warning as only a single matching event log ID 805 record should be present. Please investigate further if possible. Guessing that 1 copy of the job was printed and continuing on..." 
        Write-Host $Message 
        Write-Output $Message | Out-File -FilePath $OutputFilenameByPrintJob -Encoding UTF8 -Append 
    } 
 
    # Вычисление общего количества страниц для задания печати
    $TotalPages = [int]$PrintPagesOneCopy * [int]$NumberOfCopies 
 
    # запись вывода в выходной файл
    $Output = $StartDate_Time.ToString() + "," + $PrintJobId + "," + $UserName + "," + $ADName + "," + $ClientPCName + "," + $PrinterName + ",`"" + ($DocumentName -replace ",", "_") + "`"," + $PrintSizeBytes + "," + $PrintPagesOneCopy + "," + $NumberOfCopies + "," + $TotalPages 
    Write-Output $Output | Out-File -FilePath $OutputFilenameByPrintJob -Encoding UTF8 -Append 
     
    # обновить общее количество страниц задания пользователя 
    $UserNameKey = "`"$UserName ($ADName)`"" 
    # если пользователь еще не находится в хеш-таблице, добавить их и их начальное общее количество страниц 
    if (!$PerUserTotalPagesRecords.ContainsKey($UserNameKey)) { 
        $PerUserTotalPagesRecords.Add($UserNameKey,$TotalPages) 
    } 
    # если пользователь уже находится в хеш-таблице, обновить общее количество страниц 
    else { 
        $PerUserTotalPagesRecords.Set_Item($UserNameKey,$PerUserTotalPagesRecords.Get_Item($UserNameKey) + $TotalPages) 
    } 
     
    # display status message 
    Write-Host "  Print job $PrintJobCounter (job ID $PrintJobId printed at $StartDate_Time) processed." 
    $PrintJobCounter++ 
 
} 
 

Write-Host "Finished." 