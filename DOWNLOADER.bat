@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ===== Force Working Directory to Batch File Location =====
cd /d "%~dp0"

cls
echo Made by Byron for impressme with love
echo.

REM ===== Dependency Check & Direct Download =====
call :CHECK_AND_INSTALL yt-dlp.exe
call :CHECK_AND_INSTALL ffmpeg.exe
call :CHECK_AND_INSTALL deno.exe

REM ===== Check for Drag-and-Drop =====
if not "%~1"=="" (
    call :PROCESS_ARGS %*
    goto ASK_MORE
)

:MANUAL_INPUT
set "INPUT="
set /p INPUT="Enter URL or local file path: "
if "!INPUT!"=="" goto MANUAL_INPUT
REM Strip surrounding quotes if manually pasted
set "INPUT=!INPUT:"=!"
call :PROCESS_ITEM "!INPUT!"

:ASK_MORE
set "MORE="
set /p MORE="Do you want to process another item? (y/n): "
if /i "!MORE!"=="y" goto MANUAL_INPUT
echo Bye.
pause
exit /b

REM ==================================================
REM Subroutines
REM ==================================================

:CHECK_AND_INSTALL
set "BIN_FILE=%~1"
if exist "!BIN_FILE!" exit /b
where !BIN_FILE! >nul 2>&1
if not errorlevel 1 exit /b

echo [!] !BIN_FILE! is missing. Downloading directly to current folder...

if "!BIN_FILE!"=="yt-dlp.exe" (
    curl -L -o yt-dlp.exe "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
)

if "!BIN_FILE!"=="deno.exe" (
    curl -L -o deno.zip "https://github.com/denoland/deno/releases/latest/download/deno-x86_64-pc-windows-msvc.zip"
    tar -xf deno.zip
    del deno.zip
)

if "!BIN_FILE!"=="ffmpeg.exe" (
    curl -L -o ffmpeg.zip "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"
    mkdir ffmpeg_temp
    tar -xf ffmpeg.zip -C ffmpeg_temp
    REM Search inside the extracted folders for ffmpeg.exe and move it to the main directory
    for /r ffmpeg_temp %%F in (ffmpeg.exe) do if exist "%%F" move /Y "%%F" . >nul
    rmdir /s /q ffmpeg_temp
    del ffmpeg.zip
)

if exist "!BIN_FILE!" (
    echo [OK] !BIN_FILE! downloaded successfully.
    echo.
) else (
    echo ERROR: Failed to download !BIN_FILE!.
    pause
    exit
)
exit /b

:PROCESS_ARGS
:ARGS_LOOP
if "%~1"=="" exit /b
call :PROCESS_ITEM "%~1"
shift
goto ARGS_LOOP

:PROCESS_ITEM
set "TARGET=%~1"
set "IS_FILE=0"
if exist "!TARGET!" set "IS_FILE=1"

echo.
echo --------------------------------------------------
echo Target: !TARGET!
echo --------------------------------------------------

if "!IS_FILE!"=="1" (
    echo [Local File Mode]
    echo 1. Extract Audio to MP3 ^(default^)
    echo 2. Re-mux to MP4
    echo 3. Re-mux to MKV
) else (
    echo [Web Download Mode]
    echo 1. Download Video as MP4 ^(default^)
    echo 2. Download Video as MKV
    echo 3. Download Audio as MP3
    echo 4. Download Source Video ^(Native Format^)
)

set "CHOICE="
set /p CHOICE="Select action (1/2/3/4): "
if "!CHOICE!"=="" set "CHOICE=1"

REM yt-dlp settings (Removed youtube:player_client=web to prevent 360p cap)
set "JS=--js-runtimes deno"
set "YTFIX=--remote-components ejs:github --force-ipv4"

REM Execution
if "!IS_FILE!"=="1" (
    for %%F in ("!TARGET!") do set "BASENAME=%%~nF"
    if "!CHOICE!"=="1" ffmpeg -i "!TARGET!" -q:a 0 -map a "!BASENAME!.mp3"
    if "!CHOICE!"=="2" ffmpeg -i "!TARGET!" -c copy "!BASENAME!.mp4"
    if "!CHOICE!"=="3" ffmpeg -i "!TARGET!" -c copy "!BASENAME!.mkv"
) else (
    if "!CHOICE!"=="1" yt-dlp --progress --newline !JS! !YTFIX! -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --merge-output-format mp4 --live-from-start "!TARGET!"
    if "!CHOICE!"=="2" yt-dlp --progress --newline !JS! !YTFIX! -f "bestvideo+bestaudio/best" --merge-output-format mkv --live-from-start "!TARGET!"
    if "!CHOICE!"=="3" yt-dlp --progress --newline !JS! !YTFIX! -x --audio-format mp3 --audio-quality 0 --live-from-start "!TARGET!"
    if "!CHOICE!"=="4" yt-dlp --progress --newline !JS! !YTFIX! -f "bestvideo+bestaudio/best" --live-from-start "!TARGET!"
)

echo.
echo Task complete.
exit /b
