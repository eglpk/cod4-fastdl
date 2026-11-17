
@echo off
setlocal

SET "work_directory=%~dp0"
cd /d "%work_directory%"

echo Copying source files...

xcopy localizedstrings ..\..\raw\english\localizedstrings\ /SY
xcopy maps ..\..\raw\maps\ /SY
xcopy mp ..\..\raw\mp\ /SY
xcopy promod ..\..\raw\promod\ /SY
xcopy shock ..\..\raw\shock\ /SY
xcopy sound ..\..\raw\sound\ /SY
xcopy soundaliases ..\..\raw\soundaliases\ /SY
xcopy ui_mp ..\..\raw\ui_mp\ /SY
xcopy xmodel ..\..\raw\xmodel\ /SY

copy /Y mod.csv ..\..\zone_source\

echo.
echo Compiling Fastfile...

cd /d ..\..\bin

linker_pc.exe -language english -compress -cleanup mod -verbose

if errorlevel 1 exit /b 1

echo.
echo Fastfile compilation complete.

endlocal
exit /b 0
