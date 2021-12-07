# ::ENTRY POINT

# Check if script is started with admin rights (needed for installing modules)
If(-NOT([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Please re-run this script as an Administrator!"
    Break
}

# Set config paths
$SettingsPath = "C:\Users\chris\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$ProfilePath = "C:\Users\chris\OneDrive\Private\Documents\WindowsPowerShell"
$ProfilePathPS7 = "C:\Program Files\PowerShell\7"

# Installing necessary modules
Install-Module posh-git -Scope AllUsers
Install-Module oh-my-posh -Scope AllUsers
Install-Module -Name Terminal-Icons -Scope AllUsers

# Installing fonts
$Source = ".\resources\fonts\Meslo.zip"
$FontsFolder = "Meslo"

Expand-Archive $Source -DestinationPath $FontsFolder -Force

$FONTS = 0x14
$CopyOptions = 4 + 16;
$ObjShell = New-Object -ComObject Shell.Application
$ObjFolder = $ObjShell.Namespace($FONTS)
$AllFonts = Get-ChildItem $FontsFolder

foreach($font in Get-ChildItem -Path $fontsFolder -File)
{
    $dest = "C:\Windows\Fonts\$font"
    If(Test-Path -Path $dest)
    {
        Write-Output "Font $font already installed"
    }
    Else
    {
        Write-Output "Installing $font"
        $CopyFlag = [String]::Format("{0:x}", $CopyOptions);
        $ObjFolder.CopyHere($font.fullname,$CopyFlag)
    }
}

# Install latest powershell version
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet"

# Copy / replace settings.json in windows terminal installation folder
Copy-Item .\resources\settings\settings.json -Destination $SettingsPath -force

# Create new powershell profile and override it with existing profile
Test-Path $PROFILE
New-Item -Type File -Force $PROFILE
Copy-Item .\resources\settings\Microsoft.PowerShell_profile.ps1 -Destination $ProfilePath -force
Copy-Item .\resources\settings\Microsoft.PowerShell_profile.ps1 -Destination $ProfilePathPS7 -force

# Generate new profile guid and replace it with the one in copied settings.json (under 'defaultProfile')
$ProfileGuid = [guid]::NewGuid()
((Get-Content -path "$SettingsPath\settings.json" -Raw) -replace 'insert-profile-guid-here',$ProfileGuid) | Set-Content -Path "$SettingsPath\settings.json"

# Copy and override settings.json of vs code to right path (or set font of integrated terminal)
$VSCodeSettingsFile = 'C:\Users\chris\AppData\Roaming\Code\User\settings.json'

$VSCodeSettings = Get-Content $VSCodeSettingsFile | Out-String | ConvertFrom-Json
$VSCodeSettings | Add-Member -Type NoteProperty -Name 'terminal.integrated.fontFamily' -Value 'MesloLGM NF'

$VSCodeSettings | ConvertTo-Json | Set-Content $VSCodeSettingsFile

# ::END