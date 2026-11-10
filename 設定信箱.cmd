@echo off
rem English only on purpose: cmd.exe misreads Chinese lines in UTF-8 batch files (seen 2026-10-09).
rem Puts the client_secret.json from Prof. Chen where gws looks for it, then starts the Google login.
rem Messages avoid parentheses inside blocks on purpose: cmd.exe would end the block early.
setlocal
rem Re-read PATH from the registry, so tools installed after this window or the AI app was opened still show up.
set "SYSP="
set "USRP="
for /f "tokens=2,*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul ^| findstr /i "REG_"') do set "SYSP=%%B"
for /f "tokens=2,*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul ^| findstr /i "REG_"') do set "USRP=%%B"
if defined SYSP call set "PATH=%SYSP%;%USRP%;%PATH%"
cd /d "%~dp0"
title Set up Gmail for your AI partner - gws
set "NOLOGIN=%~1"
set "DEST=%USERPROFILE%\.config\gws"

where gws >nul 2>nul
if errorlevel 1 goto :nogws

if exist "%DEST%\client_secret.json" goto :haveconfig

set "SRC="
if exist "%~dp0client_secret.json" set "SRC=%~dp0client_secret.json"
if not defined SRC if exist "%USERPROFILE%\Downloads\client_secret.json" set "SRC=%USERPROFILE%\Downloads\client_secret.json"
if not defined SRC call :findone
if not defined SRC goto :nofile

if not exist "%DEST%" mkdir "%DEST%"
copy /y "%SRC%" "%DEST%\client_secret.json" >nul
if errorlevel 1 goto :copyfail
echo   OK       copied the login file to %DEST%
goto :login

:haveconfig
echo   OK       a login file is already in place: %DEST%\client_secret.json

:login
if /i "%NOLOGIN%"=="--no-login" goto :skiplogin
rem Logging in again replaces every permission the old login had - ask first.
gws auth status 2>nul | findstr /R /C:"has_refresh_token.*true" >nul
if errorlevel 1 goto :dologin
echo.
echo   NOTE: this computer already has a saved Google login for gws.
echo   Logging in again REPLACES all its permissions with: gmail, drive, calendar, sheets, docs.
echo   Only continue if your login stopped working or Prof. Chen told you to.
choice /c YN /t 60 /d N /m "  Log in again now? Y = yes, N = no - no answer in 60 seconds means no"
if errorlevel 2 goto :keptlogin
:dologin
echo.
echo   Next: a browser opens. Choose your WORK Google account and allow the permissions.
echo.
rem CALL is required: gws is gws.cmd, and a batch file run without CALL never returns here.
call gws auth login -s "gmail,drive,calendar,sheets,docs"
echo.
gws auth status 2>nul | findstr /R /C:"has_refresh_token.*true" >nul
if errorlevel 1 (
  echo   --       login not saved. Run this file again, or ask Prof. Chen.
) else (
  echo   OK       login saved. You can close this window.
)
goto :end

:keptlogin
echo   --       kept the existing login. Nothing changed.
goto :end

:skiplogin
echo   --       login skipped because of --no-login
goto :end

:nogws
echo.
echo   STOP: gws is not installed yet. Ask your AI partner to finish installing the tools first, then run this again.
goto :end

:nofile
echo.
if defined MANY goto :manyfiles
echo   STOP: client_secret.json not found.
echo   Put the file from Prof. Chen next to this .cmd file, or in your Downloads folder, then run again.
goto :end

:manyfiles
echo   STOP: several client_secret files are in your Downloads folder.
echo   Keep only the newest one from Prof. Chen - delete the others - then run again.
goto :end

:copyfail
echo.
echo   STOP: could not copy the file to %DEST%. Ask Prof. Chen.

:end
echo.
if /i not "%NOLOGIN%"=="--no-login" pause
exit /b 0

:findone
rem No exact client_secret.json: a browser may have renamed it. Accept exactly one client_secret*.json in Downloads, never several.
set "CNT=0"
set "ONE="
for %%F in ("%USERPROFILE%\Downloads\client_secret*.json") do call :countone "%%~fF"
if "%CNT%"=="1" set "SRC=%ONE%"
if %CNT% GTR 1 set "MANY=1"
goto :eof

:countone
set /a CNT+=1
set "ONE=%~1"
goto :eof
