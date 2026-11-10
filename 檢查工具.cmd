@echo off
rem English only on purpose: cmd.exe misreads Chinese lines in UTF-8 batch files (seen 2026-10-09).
rem Double-click to see which tools are installed. Prints versions only; never prints accounts or tokens.
setlocal
set "NOPAUSE=%~1"
rem Re-read PATH from the registry, so tools installed after this window or the AI app was opened still show up.
set "SYSP="
set "USRP="
for /f "tokens=2,*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul ^| findstr /i "REG_"') do set "SYSP=%%B"
for /f "tokens=2,*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul ^| findstr /i "REG_"') do set "USRP=%%B"
if defined SYSP call set "PATH=%SYSP%;%USRP%;%PATH%"
cd /d "%~dp0"
title Tool check
echo.
echo   Checking tools.  OK = found   MISSING = needed but not installed yet   -- = optional, or not done yet
echo   -------------------------------------------------------------------------------------------
call :chk git "git --version"
call :chk gh "gh --version"
call :opt uv "uv --version" "only needed if you use gws mail"
call :opt node "node --version" "only needed if you use gws"
call :opt gws "gws --version" "lets your AI partner work with Gmail and Drive"
call :opt claude "claude --version" "command-line version, the desktop app is enough"
call :opt codex "codex --version" "command-line version, the desktop app is enough"
echo.
echo   Logins
where gh >nul 2>nul && (gh auth status >nul 2>nul && (echo   OK       GitHub CLI is logged in) || (echo   --       GitHub CLI not logged in yet: run  gh auth login)) || (echo   --       GitHub CLI not installed yet)
where gws >nul 2>nul && (gws auth status 2>nul | findstr /R /C:"has_refresh_token.*true" >nul && (echo   OK       gws has a saved Google login) || (echo   --       gws not logged in yet: see item 12 of the guide page)) || (echo   --       gws not installed, skip)
echo.
echo   PowerShell script policy - only matters if you type npm or gws yourself
call :pspol
echo.
echo   Required: git, gh and the GitHub CLI login. Everything else is optional.
echo   gh and its login are what save this folder to your own private GitHub repo.
echo   The ChatGPT and Claude desktop apps cannot be checked here: open each once and sign in.
echo.
if /i not "%NOPAUSE%"=="--no-pause" pause
exit /b 0

:chk
where %1 >nul 2>nul
if errorlevel 1 (
  echo   MISSING  %1
  goto :eof
)
for /f "delims=" %%v in ('%~2 2^>nul') do (
  echo   OK       %1    %%v
  goto :eof
)
echo   OK       %1
goto :eof

:opt
where %1 >nul 2>nul
if errorlevel 1 (
  echo   --       %1    optional: %~3
  goto :eof
)
for /f "delims=" %%v in ('%~2 2^>nul') do (
  echo   OK       %1    %%v
  goto :eof
)
echo   OK       %1
goto :eof

:pspol
rem A PowerShell 7 parent leaks PSModulePath and breaks Windows PowerShell 5.1 here; clear it for this script only.
set "PSModulePath="
set "PSPOL="
for /f "delims=" %%p in ('powershell -NoProfile -Command "Get-ExecutionPolicy" 2^>nul') do set "PSPOL=%%p"
if not defined PSPOL (
  echo   --       could not ask PowerShell
  goto :eof
)
if /i "%PSPOL%"=="Restricted" goto :pspolbad
if /i "%PSPOL%"=="AllSigned" goto :pspolbad
echo   OK       PowerShell allows local scripts: %PSPOL%
goto :eof
:pspolbad
echo   --       PowerShell blocks .ps1 scripts: %PSPOL%. Type npm.cmd and gws.cmd instead - your AI partner already does.
goto :eof
