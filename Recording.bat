@echo off
:: 设置窗口颜色（背景黑色，文字绿色）
color 0A
:: 设置窗口标题
title 记录器

setlocal enabledelayedexpansion

:inputPath
REM 提示用户输入文件夹路径
set "folderPath="
echo 请输入文件夹路径，或者将文件夹拖入此窗口后按回车：
set /p folderPath=

REM 检查用户是否输入了路径
if "%folderPath%"=="" (
    echo 请输入有效的文件夹路径！
    goto inputPath
)

REM 检查路径是否存在
if not exist "%folderPath%" (
    echo 文件夹路径不存在，请检查后重试。
    goto inputPath
)

set "savFileName=%folderPath%.sav"

REM 检查是否已存在 .sav 文件，并创建唯一的文件名
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

REM 提示正在写入
echo 正在写入...
timeout /t 1 >nul

REM 创建或覆盖 .sav 文件
(
    for %%i in ("%folderPath%\*") do (
        set "fileName=%%~nxi"
        echo !fileName!
    )
) > "%savFileName%"

echo 文件列表已保存到 "%savFileName%"
echo 按任意键以继续...
pause >nul

REM 允许用户再次操作
goto inputPath
