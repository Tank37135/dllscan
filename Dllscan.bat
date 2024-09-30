@echo off
color 0A
title DLL �ļ�ɨ�蹤��
setlocal enabledelayedexpansion

:: ���� DLL �ļ�Ŀ¼�� DLL �ļ������б�
set "dll_dir=C:\Windows\System32"
set "dll_folder=%~dp0dll"
set "logfile=%~dp0scan_results_%date:~10,4%-%date:~4,2%-%date:~7,2%.txt"

:: ȷ�� DLL �ļ��д���
if not exist "%dll_folder%" (
    echo ����: DLL �ļ��� "%dll_folder%" �����ڣ�����ϵ�����߻��������������
    pause
    exit /b
)

:show_intro
cls
call :show_text "��ӭʹ��dllscan, �������Ϊ���ṩһЩdll�ļ�ɨ�蹦����Ҫ���һ��ļ���"
call :show_text "������ڿ�����, ���ܹ��ܲ���ȫ��, ���½�"
call :show_text "��ѡ�������"
call :show_text "1. ��ʼɨ�� DLL �ļ�"
call :show_text "2. ��Դ��ַ"
call :show_text "3. ���ڡ�"
set /p choice=����ѡ���Ӧ��Ų��� Enter: 

if "%choice%"=="1" goto start_scan
if "%choice%"=="2" goto open_source
if "%choice%"=="3" goto show_author
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
        set "status_list=!status_list! %%f [��ʧ]"
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
echo ������Ҫ�޸����ļ���ţ����ѡ���������á� , ���������������� 0 �޸����ж�ʧ�ļ�:
set /p input=����ѡ�񲢰� Enter: 

:: �����û�����
if "%input%"=="0" (
    echo �޸����ж�ʧ�� DLL �ļ�...
    for %%f in (%expected_dlls%) do (
        if not exist "%dll_dir%\%%f" (
            if exist "%dll_folder%\%%f" (
                copy "%dll_folder%\%%f" "%dll_dir%" >nul
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
            if "!file_name:~1,1!"=="����" (
                echo ����: �ļ� %%i �Ѵ��ڣ������޸���
            ) else (
                set "file_name=!file_name:~2!"
                if exist "%dll_folder%\!file_name!" (
                    copy "%dll_folder%\!file_name!" "%dll_dir%" >nul
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

:open_source
start "" "https://github.com/Tank37135/dllscan.git"
goto :show_intro

:show_author
cls
call :show_text "��ǰ����汾�����԰�"
call :show_text "���ߣ�Tank37135"
call :show_text "����Ŀ����ߣ�earth1934"
call :show_text "�����Ŀ�����Ա��л��"
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
