@echo off
cd /d "%~dp0"
echo Installing Stitch Bonus Calculator to Desktop...
powershell -ExecutionPolicy Bypass -File "%~dp0create-shortcut.ps1"
echo.
echo Done! Use the desktop shortcut "Stitch Bonus Calculator"
echo to open the app anytime.
pause
