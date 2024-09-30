@echo off
color 0A
title DLL 文件扫描工具
setlocal enabledelayedexpansion

:: 设置 DLL 文件目录和 DLL 文件名称列表
set "dll_dir=C:\Windows\System32"
set "dll_folder=%~dp0dll"
set "logfile=%~dp0scan_results_%date:~10,4%-%date:~4,2%-%date:~7,2%.txt"

:: 确保 DLL 文件夹存在
if not exist "%dll_folder%" (
    echo 错误: DLL 文件夹 "%dll_folder%" 不存在，请联系开发者或重新下载软件。
    pause
    exit /b
)

:show_intro
cls
call :show_text "欢迎使用dllscan, 本软件将为你提供一些dll文件扫描功能主要是找回文件。"
call :show_text "软件仍在开发中, 可能功能并不全面, 请谅解"
call :show_text "请选择操作："
call :show_text "1. 开始扫描 DLL 文件"
call :show_text "2. 开源地址"
call :show_text "3. 关于…"
set /p choice=输入选择对应序号并按 Enter: 

if "%choice%"=="1" goto start_scan
if "%choice%"=="2" goto open_source
if "%choice%"=="3" goto show_author
goto :show_intro

:start_scan
:: 从 dll.sav 文件中读取 DLL 名称列表
if not exist "%~dp0dll.sav" (
    echo 错误: dll.sav 文件未找到，请联系开发者或重新下载软件。
    pause
    goto :show_intro
)

set "expected_dlls="
for /f "delims=" %%a in ("%~dp0dll.sav") do (
    if "%%a" neq "" set "expected_dlls=!expected_dlls! %%a"
)

:: 开始扫描
echo 扫描开始时间: %date% %time% > "%logfile%"
echo. >> "%logfile%"

set "status_list="
set /a index=1
for %%f in (%expected_dlls%) do (
    if exist "%dll_dir%\%%f" (
        echo [%index%] %%f [存在] >> "%logfile%"
        set "status_list=!status_list! [%index%] %%f [存在]"
    ) else (
        echo [%index%] %%f [丢失] >> "%logfile%"
        set "status_list=!status_list! %%f [丢失]"
    )
    set /a index+=1
)

:: 扫描完成
echo 扫描结束时间: %date% %time% >> "%logfile%"
echo. >> "%logfile%"

:: 显示扫描结果
cls
echo 扫描完成：
echo.
echo !status_list!
echo.
echo 输入需要修复的文件序号（如果选择多个，请用“ , ”隔开），或输入 0 修复所有丢失文件:
set /p input=输入选择并按 Enter: 

:: 处理用户输入
if "%input%"=="0" (
    echo 修复所有丢失的 DLL 文件...
    for %%f in (%expected_dlls%) do (
        if not exist "%dll_dir%\%%f" (
            if exist "%dll_folder%\%%f" (
                copy "%dll_folder%\%%f" "%dll_dir%" >nul
                if errorlevel 1 (
                    echo 错误: 修复文件 %%f 失败。
                ) else (
                    echo 修复: %%f
                )
            ) else (
                echo 错误: 找不到修复文件: %%f
            )
        )
    )
    goto :show_intro
)

for %%i in (%input%) do (
    set "found=false"
    for /f "tokens=1,* delims=]" %%a in ('echo !status_list!') do (
        if "%%a"=="%%i" (
            set "file_name=%%b"
            set "found=true"
            if "!file_name:~1,1!"=="存在" (
                echo 错误: 文件 %%i 已存在，不能修复。
            ) else (
                set "file_name=!file_name:~2!"
                if exist "%dll_folder%\!file_name!" (
                    copy "%dll_folder%\!file_name!" "%dll_dir%" >nul
                    if errorlevel 1 (
                        echo 错误: 修复文件 !file_name! 失败。
                    ) else (
                        echo 修复: !file_name!
                    )
                ) else (
                    echo 错误: 找不到修复文件: !file_name!
                )
            )
        )
    )
    if "!found!"=="false" (
        echo 错误: 序号 %%i 无效。
    )
)

goto :show_intro

:open_source
start "" "https://github.com/Tank37135/dllscan.git"
goto :show_intro

:show_author
cls
call :show_text "当前软件版本：测试版"
call :show_text "作者：Tank37135"
call :show_text "参与的开发者：earth1934"
call :show_text "向参与的开发人员致谢。"
echo.
pause
goto :show_intro

:show_text
setlocal enabledelayedexpansion
set "text=%~1"
for /l %%i in (0,1,255) do (
    set "char=!text:~%%i,1!"
    if "!char!"=="" goto :eof
    echo|set /p=!char!
)
endlocal
exit /b
