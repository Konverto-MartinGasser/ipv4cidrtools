echo off

REM
REM Call script like this
REM .\BuildTAR.bar AbsolutePathToFolderContainingDockerfile
REM

REM Remove quotation marks
SET folderpath=%1
SET folderpath=%folderpath:"=%
SET folderpath=%folderpath:'=%

:removeSlash
REM Remove trailing backslash if exists
REM We have to do this in a loop because a path with spaces would end witch a double backslash
if %folderpath:~-1% == \ (set folderpath=%folderpath:~0,-1%) else (goto :main)
goto :removeSlash

:main
REM echo %folderpath%
REM pause

REM Get last folder as this will be our parent-folder
for %%f in ("%folderpath%") do set "parent=%%~nxf"

REM echo %parent%
REM pause

REM Parent is empty or a backslash
if "%parent%" == "" (exit /b)
if "%parent%" == "\" (exit /b)

set filepath="%USERPROFILE%\OneDrive - Konverto AG\Desktop\%parent%.tar"

REM echo %filepath%
REM pause

REM Delete existing file
IF EXIST %filepath% (del %filepath%)

REM echo %folderpath%
REM pause

REM and create a new tar-archiv with files only (no parent-folder) and exluding everything in BuildTar.exclude
REM could cause an "file not found" error (Das System kann den angegebenen Pfad nicht finden) since BuildTAR.exclude is relative
"7zip\7za.exe" a -ttar %filepath% "%folderpath%\*" -xr@BuildTAR.exclude