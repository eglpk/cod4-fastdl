
@echo off
setlocal
title SLeS Promod - Compile and Install

set "work_directory=%~dp0"
set "destination=%~dp0..\..\Mods\pml220"

cd /d "%work_directory%"

echo ========================================
echo       SLeS PROMOD COMPILATION
echo ========================================
echo.

echo [1/4] Creating IWD files...

if not exist "..\pml220" mkdir "..\pml220"

del /Q "..\pml220\*.iwd" 2>nul

7za a -r -mx=9 -mpass=15 -mfb=258 -mmt=on -mtc=off -tzip "..\pml220\pml220.iwd" weapons images sound
if errorlevel 1 goto ERROR

7za a -r -mx=9 -mpass=15 -mfb=258 -mmt=on -mtc=off -tzip "..\pml220\z_c_r.iwd" promod_ruleset
if errorlevel 1 goto ERROR

echo.
echo [2/4] Compiling Fastfile...

call compile_fastfile.bat
if errorlevel 1 goto ERROR

echo.
echo [3/4] Installing all 3 files...

if not exist "%destination%" mkdir "%destination%"

copy /Y "%~dp0..\..\zone\english\mod.ff" "%destination%\mod.ff"
if errorlevel 1 goto ERROR

copy /Y "%~dp0..\pml220\pml220.iwd" "%destination%\pml220.iwd"
if errorlevel 1 goto ERROR

copy /Y "%~dp0..\pml220\z_c_r.iwd" "%destination%\z_c_r.iwd"
if errorlevel 1 goto ERROR

echo.
echo [4/4] Verifying installed files...

if not exist "%destination%\mod.ff" goto ERROR
if not exist "%destination%\pml220.iwd" goto ERROR
if not exist "%destination%\z_c_r.iwd" goto ERROR

dir "%destination%"

echo.
echo ========================================
echo       ALL 3 FILES INSTALLED
echo ========================================
echo Location: %destination%
goto END

:ERROR
echo.
echo ========================================
echo       COMPILATION OR COPY FAILED
echo ========================================
echo Check the error above.

:END
echo.
pause
