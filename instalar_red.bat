@echo off
:: ================================================
::  LineDance App — Instalador de red
::  Ejecutar como Administrador
:: ================================================

echo.
echo  =========================================
echo   LineDance App — Configuracion de red
echo  =========================================
echo.

:: Verificar que se ejecuta como administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo  [ERROR] Este script debe ejecutarse como Administrador.
    echo  Hace clic derecho en el archivo y elegí "Ejecutar como administrador".
    echo.
    pause
    exit /b 1
)

echo  [1/4] Configurando perfil de red como Privado...
powershell -Command "Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private" >nul 2>&1
if %errorLevel% equ 0 (
    echo        OK - Red configurada como Privada
) else (
    echo        AVISO - No se pudo cambiar el perfil de red automaticamente
    echo        Hacelo manual: Configuracion ^> Red e Internet ^> Ethernet ^> Privada
)

echo.
echo  [2/4] Creando regla de firewall para el puerto 5000...

:: Eliminar reglas anteriores si existen
netsh advfirewall firewall delete rule name="LineDance Remote" >nul 2>&1

:: Crear regla nueva
netsh advfirewall firewall add rule name="LineDance Remote" dir=in action=allow protocol=TCP localport=5000 profile=private >nul 2>&1
if %errorLevel% equ 0 (
    echo        OK - Puerto 5000 habilitado en red privada
) else (
    echo        ERROR - No se pudo crear la regla de firewall
)
echo  [3/4] Creando regla de firewall para el puerto 5001...

:: Eliminar reglas anteriores si existen
netsh advfirewall firewall delete rule name="LineDance Monitor" >nul 2>&1

:: Crear regla nueva
netsh advfirewall firewall add rule name="LineDance Monitor" dir=in action=allow protocol=TCP localport=5001 profile=private >nul 2>&1
if %errorLevel% equ 0 (
    echo        OK - Puerto 5001 habilitado en red privada
) else (
    echo        ERROR - No se pudo crear la regla de firewall
)

echo.
echo  [4/4] Verificando configuracion...
netsh advfirewall firewall show rule name="LineDance Remote" | findstr "Habilitada" >nul 2>&1
if %errorLevel% equ 0 (
    echo        OK - Regla verificada y activa
) else (
    echo        AVISO - No se pudo verificar la regla
)

echo.
echo  =========================================
echo   Configuracion completada!
echo   Ya podes usar el control desde el celu.
echo  =========================================
echo.
pause
