@echo off
color 0A
title DLL �ļ�ɨ�蹤��
setlocal enabledelayedexpansion

:: ���� DLL �ļ�Ŀ¼�� DLL �ļ������б�
set "dll_dir=C:\Windows\System32"
set "dll_folder=%~dp0dll"
set "logfile=%~dp0scan_results_%date:~10,4%-%date:~4,2%-%date:~7,2%.txt"

:show_intro
cls
echo ��ӭʹ�� dllscan, �������Ϊ���ṩ DLL �ļ�ɨ�蹦�ܣ���Ҫ�����һ��ļ���
echo ������ڿ�����, ���ܹ��ܲ���ȫ��, ���½⡣
echo ��ѡ�������
echo 1. ��ʼɨ�� DLL �ļ�
echo 2. �����޸� DLL �ļ�
echo 3. ��Դ��ַ
echo 4. ���ڡ�
set /p choice=����ѡ���Ӧ��Ų��� Enter: 

if "%choice%"=="1" goto start_scan
if "%choice%"=="2" goto find_and_repair
if "%choice%"=="3" start "" "https://github.com/Tank37135/dllscan.git" & goto :show_intro
if "%choice%"=="4" goto show_author
goto :show_intro

:start_scan
:: �� dll.sav �ļ��ж�ȡ DLL �����б�
if not exist "%~dp0dll.sav" (
    echo ����: dll.sav �ļ�δ�ҵ�������ϵ�����߻��������������
    pause
    goto :show_intro
)

set "expected_dlls="
for /f "delims=" %%a in ("%~dp0dll.sav") do (
    if "%%a" neq "" set "expected_dlls=!expected_dlls! %%a"
)

:: ��ʼɨ��
echo ɨ�迪ʼʱ��: %date% %time% > "%logfile%"
echo. >> "%logfile%"

set "status_list="
set /a index=1
for %%f in (%expected_dlls%) do (
    if exist "%dll_dir%\%%f" (
        echo [%index%] %%f [����] >> "%logfile%"
        set "status_list=!status_list! [%index%] %%f [����]"
    ) else (
        echo [%index%] %%f [��ʧ] >> "%logfile%"
        set "status_list=!status_list! [%index%] %%f [��ʧ]"
    )
    set /a index+=1
)

:: ɨ�����
echo ɨ�����ʱ��: %date% %time% >> "%logfile%"
echo. >> "%logfile%"

:: ��ʾɨ����
cls
echo ɨ����ɣ�
echo.
echo !status_list!
echo.
echo ������Ҫ�޸����ļ���ţ����ѡ���������á�,���������������� 0 �޸����ж�ʧ�ļ�:
set /p input=����ѡ�񲢰� Enter: 

goto check_dll_folder

:check_dll_folder
:: ��� DLL �ļ����Ƿ����
if not exist "%dll_folder%" (
    echo ����: DLL �ļ��� "%dll_folder%" �����ڣ�����ϵ�����߻��������������
    pause
    goto :show_intro
)

:: �����û�����
if "%input%"=="0" (
    echo �޸����ж�ʧ�� DLL �ļ�...
    for %%f in (%expected_dlls%) do (
        if not exist "%dll_dir%\%%f" (
            if exist "%dll_folder%\%%f" (
                copy "%dll_folder%\%%f" "%dll_dir%">nul
                if errorlevel 1 (
                    echo ����: �޸��ļ� %%f ʧ�ܡ�
                ) else (
                    echo �޸�: %%f
                )
            ) else (
                echo ����: �Ҳ����޸��ļ�: %%f
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
            set "file_name=!file_name:~2!"
            if "!file_name:~-6!"=="[����" (
                echo ����: �ļ� %%i �Ѵ��ڣ������޸���
            ) else (
                if exist "%dll_folder%\!file_name!" (
                    copy "%dll_folder%\!file_name!" "%dll_dir%">nul
                    if errorlevel 1 (
                        echo ����: �޸��ļ� !file_name! ʧ�ܡ�
                    ) else (
                        echo �޸�: !file_name!
                    )
                ) else (
                    echo ����: �Ҳ����޸��ļ�: !file_name!
                )
            )
        )
    )
    if "!found!"=="false" (
        echo ����: ��� %%i ��Ч��
    )
)

goto :show_intro

:find_and_repair
:: ��� DLL �ļ����Ƿ����
if not exist "%dll_folder%" (
    echo ����: DLL �ļ��� "%dll_folder%" �����ڣ�����ϵ�����߻��������������
    pause
    goto :show_intro
)

set /p dll_name=��������Ҫ�޸��� DLL �ļ�����������׺��: 
if exist "%dll_folder%\%dll_name%" (
    copy "%dll_folder%\%dll_name%" "%dll_dir%">nul
    if errorlevel 1 (
        echo ����: �޸��ļ� %dll_name% ʧ�ܡ�
    ) else (
        echo �޸�: %dll_name%
    )
) else (
    echo ����: �Ҳ����ļ�: %dll_name%
)

pause
goto :show_intro

:show_author
cls
echo ��ǰ����汾�����԰�
echo �������ߣ�Tank37135
echo �ӿ����ߣ�Earth1934
echo �����Ŀ�����Ա��л��
echo.
pause
goto :show_intro

exit /b
