@echo off
title Stitch Bonus Calculator
cd /d "%~dp0"

REM Start local server (needed for real app / install / offline)
start /B powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%~dp0server.ps1"

REM Wait for server to start
ping 127.0.0.1 -n 3 >nul

set "APP_URL=http://127.0.0.1:8765/index.html"

REM Open in app window (no browser tabs/address bar)
where msedge >nul 2>&1
if %errorlevel%==0 (
  start "" msedge --app=%APP_URL% --window-size=420,860
  exit /b 0
)

where chrome >nul 2>&1
if %errorlevel%==0 (
  start "" chrome --app=%APP_URL% --window-size=420,860
  exit /b 0
)

REM Fallback: default browser
start "" %APP_URL%
