# Custom Windows Terminal

Overall: use oh my posh for themes
Before starting: Install Windows Terminal from MS Windows Store

## Install Fonts:
https://ohmyposh.dev/docs/fonts
https://www.nerdfonts.com/font-downloads

## Install Oh My Posh
https://ohmyposh.dev/docs/pwsh/

## Create new powershell profile (which defines theme and imports modules)
Test-Path $PROFILE
New-Item -Type File -Force $PROFILE

-- then override the created empty profile

## Restart powershell
