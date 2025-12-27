@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title Упаковщик папок в .pak файл UE4

if "%~1"=="" (
    echo Перетащите папку на этот скрипт для упаковки
    echo.
    echo Создастся файл: имя_папки.pak
    echo.
    pause
    exit /b
)

pushd %~dp0

set "folder_path=%~1"
set "folder_name=%~n1"
set "output_file=!folder_name!.pak"

echo ========================================
echo    УПАКОВЩИК ПАПОК В .PAK ФАЙЛ
echo ========================================
echo.

echo Обрабатываемая папка: %~nx1
echo Выходной файл: !output_file!
echo.

rem Проверяем, что это действительно папка
if not exist "!folder_path!\" (
    echo ОШИБКА: Это не папка!
    echo Перетащите именно папку на скрипт
    goto :error
)

rem Проверяем, не пустая ли папка
dir "!folder_path!" /b >nul 2>&1
if errorlevel 1 (
    echo ОШИБКА: Папка пуста!
    goto :error
)

rem Проверяем существование выходного файла
if exist "!output_file!" (
    echo.
    set /p "overwrite=Файл !output_file! уже существует. Перезаписать? (д/н): "
    if /i not "!overwrite!"=="д" if /i not "!overwrite!"=="y" (
        echo Отмена операции
        goto :error
    )
    del "!output_file!" >nul 2>&1
)

echo.
echo Начинаем упаковку...
echo ========================================

rem Выполняем упаковку
repak.exe pack "!folder_path!" "!output_file!"

if errorlevel 1 (
    echo.
    echo ========================================
    echo ОШИБКА УПАКОВКИ!
    echo ========================================
    echo Проверьте:
    echo 1. Права доступа к папке
    echo 2. Достаточно ли места на диске
    echo 3. Не заблокирована ли папка другими программами
) else (
    echo.
    echo ========================================
    echo УПАКОВКА УСПЕШНО ЗАВЕРШЕНА!
    echo ========================================
    echo Создан файл: !output_file!
    echo Размер: %~z1 байт
)

:error
popd
echo.
echo Нажмите любую клавишу для выхода...
pause >nul
