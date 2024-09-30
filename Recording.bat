@echo off
:: Set window color (black background, green text)
color 0A
:: Set window title
title Logger

setlocal enabledelayedexpansion

:inputPath
REM Prompt user to input folder path
set "folderPath="
echo Please enter the folder path, or drag the folder into this window and press Enter. We will automatically create a .sav file in the same directory as your folder:
set /p folderPath=

REM Check if the user has entered a path
if "%folderPath%"=="" (
    echo Please enter a valid folder path!
    goto inputPath
)

REM Check if the path exists
if not exist "%folderPath%" (
    echo The folder path does not exist, please check and try again.
    goto inputPath
)

set "savFileName=%folderPath%.sav"

REM Check if a .sav file already exists and create a unique file name
if exist "%savFileName%" (
    set /a count=2
    :loop
    set "newSavFileName=%folderPath%(%count%).sav"
    if exist "%newSavFileName%" (
        set /a count+=1
        goto loop
    )
    set "savFileName=%newSavFileName%"
)

REM Indicate that writing is in progress
echo Writing...
timeout /t 1 >nul

REM Create or overwrite the .sav file
(
    for %%i in ("%folderPath%\*") do (
        set "fileName=%%~nxi"
        echo !fileName!
    )
) > "%savFileName%"

echo The file list has been saved to "%savFileName%"
echo Press any key to continue...
pause >nul

REM Allow the user to perform another action
goto inputPath
