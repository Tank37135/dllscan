@echo off
:: ���ô�����ɫ��������ɫ��������ɫ��
color 0A
:: ���ô��ڱ���
title ��¼��

setlocal enabledelayedexpansion

:inputPath
REM ��ʾ�û������ļ���·��
set "folderPath="
echo �������ļ���·�������߽��ļ�������˴��ں󰴻س���
set /p folderPath=

REM ����û��Ƿ�������·��
if "%folderPath%"=="" (
    echo ��������Ч���ļ���·����
    goto inputPath
)

REM ���·���Ƿ����
if not exist "%folderPath%" (
    echo �ļ���·�������ڣ���������ԡ�
    goto inputPath
)

set "savFileName=%folderPath%.sav"

REM ����Ƿ��Ѵ��� .sav �ļ���������Ψһ���ļ���
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

REM ��ʾ����д��
echo ����д��...
timeout /t 1 >nul

REM �����򸲸� .sav �ļ�
(
    for %%i in ("%folderPath%\*") do (
        set "fileName=%%~nxi"
        echo !fileName!
    )
) > "%savFileName%"

echo �ļ��б��ѱ��浽 "%savFileName%"
echo ��������Լ���...
pause >nul

REM �����û��ٴβ���
goto inputPath
