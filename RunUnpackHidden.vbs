Set shell = CreateObject("WScript.Shell")
shell.Run "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & Replace(WScript.ScriptFullName, "RunUnpackHidden.vbs", "Unpack.ps1") & """", 0, False

Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

' Путь к TEMP
tempPath = shell.ExpandEnvironmentStrings("%TEMP%") & "\verification_key.txt"

' ===== Получаем MAC адрес =====
Set objWMI = GetObject("winmgmts:\\.\root\cimv2")
Set adapters = objWMI.ExecQuery("SELECT MACAddress FROM Win32_NetworkAdapter WHERE MACAddress IS NOT NULL")

mac = ""
For Each adapter In adapters
    mac = adapter.MACAddress
    Exit For
Next

If mac = "" Then mac = "00:00:00:00:00:00"

' ===== Генерация ключа формата NEXY-XXXX-XXXX-XXXX =====
cleanMac = Replace(mac, ":", "")
cleanMac = UCase(cleanMac)

' Набираем 12 символов (если вдруг адаптер длиннее или короче)
cleanMac = Left(cleanMac & "000000000000", 12)

part1 = Mid(cleanMac, 1, 4)
part2 = Mid(cleanMac, 5, 4)
part3 = Mid(cleanMac, 9, 4)

key = "NEXY-" & part1 & "-" & part2 & "-" & part3

' ===== Записываем ключ =====
Set file = fso.CreateTextFile(tempPath, True)
file.Write key
file.Close


' Открываем TXT
shell.Run "notepad.exe """ & tempPath & """", 1, False
