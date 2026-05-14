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
set "MAXSIZE=10485760"
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
for %%F in ("%INPUT_DIR%\*.mp4") do if exist "%%~F" call :process "%%~F"
for %%F in ("%INPUT_DIR%\*.mov") do if exist "%%~F" call :process "%%~F"
for %%F in ("%INPUT_DIR%\*.mkv") do if exist "%%~F" call :process "%%~F"

echo.
echo %ESC%[96m============================================
echo   ZAKONCZONE wyniki w "%OUTPUT_DIR%"
echo ============================================%ESC%[0m
echo.

if "%OPEN_OUTPUT%"=="1" (
    echo %ESC%[92mOtwieram katalog wynikowy...%ESC%[0m
    timeout /t 3 >nul
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
for /f "usebackq tokens=1" %%D in (`ffprobe -v error -show_entries format^=duration -of default^=nokey^=1:noprint_wrappers^=1 "%FILE%"`) do (
    set "DURATION_RAW=%%D"
)

REM Obciecie po kropce (float → int)
for /f "tokens=1 delims=." %%A in ("!DURATION_RAW!") do set "DURATION=%%A"

if "!DURATION!"=="0" set "DURATION=1"

REM POPRAWNE OBLICZENIE BITRATE (MAX 10 MB)
set /a BITRATE=(MAXSIZE*8)/1024/DURATION
if %BITRATE% lss 300 set BITRATE=300

REM GENEROWANIE NAZWY
set "NOW=%time%"
set "NOW=!NOW: =0!"
set "NOW=!NOW:,=.!"

for /f "tokens=1-4 delims=:." %%h in ("!NOW!") do (
    set "HH=%%h"
    set "MM=%%i"
    set "SS=%%j"
)

for /f "tokens=1 delims=." %%S in ("!SS!") do set "SS=%%S"

set OUTNAME=kompress-%HH%-%MM%-%SS%.mp4

echo Czas: %DURATION% s
echo Bitrate: %BITRATE% kbps
echo ---
echo Zapis: %ESC%[92m%OUTPUT_DIR%\%OUTNAME%%ESC%[0m
echo ---

REM ===========================================
REM   FFMPEG Z PASKIEM POSTEPU (1 LINIA)
REM ===========================================
ffmpeg -hide_banner -loglevel error -stats -i "%FILE%" ^
    -c:v libx264 -b:v %BITRATE%k -maxrate %BITRATE%k -bufsize 2M ^
    -c:a aac -b:a 96k ^
    "%OUTPUT_DIR%\%OUTNAME%"

echo %ESC%[Zrobione%ESC%[0m
goto :eof
