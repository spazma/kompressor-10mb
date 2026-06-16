@echo off
setlocal enabledelayedexpansion

REM ===========================================
REM   KOLORY ANSI
REM ===========================================
for /f "delims=" %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"

REM ===========================================
REM   KONFIGURACJA
REM ===========================================
set "INPUT_DIR=%~dp0do_kompresji"
set "OUTPUT_DIR=%~dp0kompress_10mb"
set "MAXSIZE=10000000"
set "OPEN_OUTPUT=1"

echo.
echo %ESC%[96m============================================
echo   START KOMPRESJI DO 10 MB
echo ============================================%ESC%[0m
echo.

if not exist "%INPUT_DIR%" mkdir "%INPUT_DIR%"
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo Folder zrodlowy: %ESC%[92m%INPUT_DIR%%ESC%[0m
echo Folder wyjsciowy: %ESC%[92m%OUTPUT_DIR%%ESC%[0m
echo Koder: %ESC%[92mNVIDIA HEVC_NVENC (GPU)%ESC%[0m
echo.

REM ===========================================
REM   LICZENIE PLIKOW
REM ===========================================
set FILECOUNT=0
for %%X in ("%INPUT_DIR%\*.mp4") do if exist "%%~X" set /a FILECOUNT+=1
for %%X in ("%INPUT_DIR%\*.mov") do if exist "%%~X" set /a FILECOUNT+=1
for %%X in ("%INPUT_DIR%\*.mkv") do if exist "%%~X" set /a FILECOUNT+=1

if %FILECOUNT%==0 (
    echo %ESC%[91mBrak plikow do przetworzenia.%ESC%[0m
    pause
    goto :eof
)

echo %ESC%[92mZnaleziono %FILECOUNT% plikow.%ESC%[0m
echo.

REM ===========================================
REM   PETLE DLA FORMATOW
REM ===========================================
set PROCESSED=0
set FAILED=0

for %%F in ("%INPUT_DIR%\*.mp4") do if exist "%%~F" call :process "%%~F"
for %%F in ("%INPUT_DIR%\*.mov") do if exist "%%~F" call :process "%%~F"
for %%F in ("%INPUT_DIR%\*.mkv") do if exist "%%~F" call :process "%%~F"

echo.
echo %ESC%[96m============================================
echo   PODSUMOWANIE
echo ============================================%ESC%[0m
echo Przetworzono:  %ESC%[92m%PROCESSED%/%FILECOUNT%%ESC%[0m
if %FAILED% gtr 0 echo Bledy:         %ESC%[91m%FAILED%%ESC%[0m
echo Wyniki:        %ESC%[92m%OUTPUT_DIR%%ESC%[0m
echo %ESC%[96m============================================%ESC%[0m
echo.

if "%OPEN_OUTPUT%"=="1" (
    echo %ESC%[92mOtwieram katalog wynikowy...%ESC%[0m
    timeout /t 2 >nul
    start "" "%OUTPUT_DIR%"
)

pause
goto :eof


REM ===========================================
REM   FUNKCJA PROCESS
REM ===========================================
:process
set "FILE=%~1"

echo %ESC%[96m-------------------------------------------%ESC%[0m
echo %ESC%[96mPrzetwarzam:%ESC%[0m %~nx1

REM Pobranie czasu trwania
for /f "usebackq tokens=1" %%D in (`ffprobe -v error -show_entries format^=duration -of default^=nokey^=1:noprint_wrappers^=1 "%FILE%" 2^>nul`) do (
    set "DURATION_RAW=%%D"
)

REM Obciecie po kropce (float → int)
for /f "tokens=1 delims=." %%A in ("!DURATION_RAW!") do set "DURATION=%%A"

if "!DURATION!"=="" set "DURATION=1"
if "!DURATION!"=="0" set "DURATION=1"

REM OBLICZENIE BITRATE (MAX 10 MB) - Z ZAPASEM 5%%
set /a BITRATE_TARGET=(MAXSIZE*8)/1024/DURATION
set /a BITRATE_TARGET=!BITRATE_TARGET! * 95 / 100
if %BITRATE_TARGET% lss 200 set BITRATE_TARGET=200

REM GENEROWANIE NAZWY - TIMESTAMP + RANDOM
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do set "D=%%c%%a%%b"
for /f "tokens=1-2 delims=/:" %%a in ('time /t') do set "T=%%a%%b"

set "OUTNAME=kompress-%D%-%T%-%RANDOM%.mp4"

echo Czas: %ESC%[93m%DURATION%s%ESC%[0m  Bitrate: %ESC%[93m%BITRATE_TARGET%kbps%ESC%[0m
echo Zapis: %ESC%[92m%OUTNAME%%ESC%[0m
echo.

REM ===========================================
REM   FFMPEG - NVENC
REM ===========================================
ffmpeg -hide_banner -loglevel error -stats -i "%FILE%" -c:v hevc_nvenc -rc vbr -cq 23 -b:v %BITRATE_TARGET%k -maxrate %BITRATE_TARGET%k -c:a aac -b:a 64k "%OUTPUT_DIR%\%OUTNAME%"

if !errorlevel! equ 0 (
    set /a PROCESSED+=1
    for %%Z in ("%OUTPUT_DIR%\%OUTNAME%") do (
        set "FILESIZE=%%~zZ"
        set /a FILESIZE_MB=!FILESIZE! / 1048576
        if !FILESIZE! leq %MAXSIZE% (
            echo %ESC%[92m[OK] !FILESIZE_MB! MB%ESC%[0m
        ) else (
            echo %ESC%[91m[WARN] !FILESIZE_MB! MB - za duzo%ESC%[0m
        )
    )
) else (
    set /a FAILED+=1
    echo %ESC%[91m[BLAD]%ESC%[0m
)

echo.
goto :eof
