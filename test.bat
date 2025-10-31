@echo off
powershell -command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Привет, Тимур!', 'Сообщение')"
pause
