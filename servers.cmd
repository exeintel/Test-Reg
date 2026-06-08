@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title Registry Monitor - Real-time Test
color 0A

:: Request admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Restarting with elevated permissions...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

cls
echo ============================================
echo    REGISTRY MONITOR - EXPERIMENT
echo ============================================
echo Path: HKCR\test
echo Parameter: reg
echo.
echo Monitoring started. Press Ctrl+C to stop.
echo ============================================
echo.

set "lastValue=UNKNOWN"

:loop
for /f "skip=2 tokens=3" %%a in ('reg query "HKCR\test" /v "reg" 2^>nul') do (
    set "currentValue=%%a"
    
    if not "!currentValue!"=="!lastValue!" (
        echo [%date% %time%] VALUE CHANGED: !lastValue! -^> !currentValue! ^<^<^< DETECTED!
        set "lastValue=!currentValue!"
    ) else (
        echo [%date% %time%] Current value: !currentValue!    (stable)
    )
    goto :continue
)

echo [%date% %time%] ERROR: Registry key not found or access denied!
set "lastValue=NOT_FOUND"

:continue
timeout /t 1 /nobreak >nul
goto :loop