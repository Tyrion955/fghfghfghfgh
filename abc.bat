@echo off
setlocal enabledelayedexpansion

:: Ocultar la ventana de CMD
if not "%1"=="hidden" (
    start /min cmd /c %0 hidden
    exit
)

:: Verificar privilegios de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    mshta "javascript:alert('Este script requiere privilegios de administrador.\nPor favor, ejecútalo como administrador.');close();"
    exit /b 1
)

:: Generar nuevo HwProfileGuid en el formato {xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}
for /f %%a in ('powershell -command "[guid]::NewGuid().ToString()"') do set HwProfileGuid={%%a}

:: Generar nuevo MachineGuid en el formato xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
for /f %%a in ('powershell -command "[guid]::NewGuid().ToString()"') do set MachineGuid=%%a

:: Actualizar los valores en el registro
reg add "HKLM\SYSTEM\CurrentControlSet\Control\IDConfigDB\Hardware Profiles\0001" /v HwProfileGuid /t REG_SZ /d "%HwProfileGuid%" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Cryptography" /v MachineGuid /t REG_SZ /d "%MachineGuid%" /f >nul

exit