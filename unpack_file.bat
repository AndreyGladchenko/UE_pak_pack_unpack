@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

icacls "%~dp0" /grant:r "%USERNAME%":(F) >nul 2>&1

title Распаковщик .pak файлов UE4 с обработкой ошибок

if "%~1"=="" (
    echo Перетащите .pak файл на этот скрипт
    pause
    exit /b
)

pushd %~dp0

set "filename=%~n1"
set "output_folder=!filename!"
set "ini_file=set_aes.ini"
set "aes_key="

echo Обрабатываем файл: %~nx1
echo.

rem Чтение AES ключа из INI файла
if exist "!ini_file!" (
    for /f "usebackq tokens=*" %%i in ("!ini_file!") do (
        set "line=%%i"
        if not "!line!"=="" if not "!line:~0,1!"==";" (
            set "aes_key=!line!"
            echo [INFO] Используется AES ключ из ini файла
        )
    )
)

rem Попытка распаковки
if not "!aes_key!"=="" (
    repak.exe --aes-key "!aes_key!" unpack "%~1" "!output_folder!" 2>nul
) else (
    repak.exe unpack "%~1" "!output_folder!" 2>nul
)

rem Проверка успешности распаковки
if exist "!output_folder!" (
    echo Успешно распаковано в: !output_folder!
    echo.
    echo Игнорируйте ошибку "Отказано в доступе", если файлы извлечены.
    echo Это известная проблема с инструментом repak.
) else (
    echo Ошибка распаковки! Возможно требуется AES ключ.
)

popd
pause
