$zip = "$env:LOCALAPPDATA\Xeno\workspace\XenoUI.zip"
$dest = "$env:LOCALAPPDATA\Xeno\workspace"

# Скрываем всё
$PSStyle.OutputRendering = 'PlainText' 2>$null

# Создание директории (без вывода)
New-Item -ItemType Directory -Force -Path $dest | Out-Null 2>&1

# Распаковка ZIP в тихом режиме
Expand-Archive -Path $zip -DestinationPath $dest -Force 2>$null

# Снять блокировку (убрать SmartScreen)
Get-ChildItem -Path $dest -Recurse | Unblock-File 2>$null

# Тихий запуск распакованного файла (если нужно) -WindowStyle Hidden
Start-Process "$dest\XenoUI.exe" 
