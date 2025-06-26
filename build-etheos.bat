@echo off
setlocal

REM === CONFIGURATION ===
set PROJECT_DIR=C:\Users\etheo\etheos
set BUILD_DIR=%PROJECT_DIR%\build
set MYSQL_INCLUDE_DIR="C:\Program Files\MySQL\MySQL Server 5.5\include"
set MYSQL_LIB_DIR="C:\Program Files\MySQL\MySQL Server 5.5\lib"

REM === CLEAN PREVIOUS BUILD ===
echo Cleaning previous build...
if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
mkdir "%BUILD_DIR%"

REM === GENERATE BUILD FILES WITH CMAKE ===
echo Generating project with CMake...
cd /d %BUILD_DIR%
"C:\Program Files\CMake\bin\cmake.exe" ^
  -G "Visual Studio 16 2019" ^
  -A Win32 ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DMARIADB_INCLUDE_DIR=%MYSQL_INCLUDE_DIR% ^
  -DMARIADB_LIBRARY=%MYSQL_LIB_DIR%\libmariadb.lib ^
  "%PROJECT_DIR%"

if %errorlevel% neq 0 (
    echo CMake generation failed.
    exit /b 1
)

REM === BUILD WITH MSBUILD ===
echo Building the solution...
"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe" etheos.sln /p:Configuration=Release

if %errorlevel% neq 0 (
    echo Build failed.
    exit /b 1
)

echo Build completed successfully.
endlocal
pause
