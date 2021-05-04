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

# Copy / replace settings.json in windows terminal installation folder
Copy-Item .\resources\settings\settings.json -Destination $SettingsPath -force

# Create new powershell profile and override it with existing profile
Test-Path $PROFILE
New-Item -Type File -Force $PROFILE
Copy-Item .\resources\settings\Microsoft.PowerShell_profile.ps1 -Destination $ProfilePath -force

# TODO: generate new profile guid and replace it with the one in copied settings.json (under 'defaultProfile')
# $ProfileGuid = [guid]::NewGuid()

# TODO: copy and override settings.json of vs code to right path (or set font of integrated terminal)

# ::END