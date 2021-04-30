# Installing necessary modules
Install-Module oh-my-posh -Scope AllUsers
Install-Module -Name Terminal-Icons

# Installing fonts
$Source = ".\resources\fonts\Meslo.zip"
$FontsFolder = "Meslo"

Expand-Archive $Source -DestinationPath $FontsFolder -Force

$FONTS = 0x14
$CopyOptions = 4 + 16;
$objShell = New-Object -ComObject Shell.Application
$objFolder = $objShell.Namespace($FONTS)
$allFonts = dir $FontsFolder

foreach($font in Get-ChildItem -Path $fontsFolder -File)
{
    $dest = "C:\Windows\Fonts\$font"
    If(Test-Path -Path $dest)
    {
        echo "Font $font already installed"
    }
    Else
    {
        echo "Installing $font"
        $CopyFlag = [String]::Format("{0:x}", $CopyOptions);
        $objFolder.CopyHere($font.fullname,$CopyFlag)
    }
}

# Copy / replace settings.json in windows terminal installation folder
# TODO: copy / replace

# Create new powershell profile and override it with existing profile
Test-Path $PROFILE
New-Item -Type File -Force $PROFILE
# TODO: override