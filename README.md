# yt-dlp & FFmpeg Batch Wrapper

A versatile Windows batch script designed to automate web media downloads and local file conversions. Built for speed and simplicity, it features drag-and-drop support and automatic, portable dependency fetching without requiring system installations or administrator rights. 

Created by Byron for impressme.

## Features

* **Drag-and-Drop Workflow:** Drop single or multiple URLs/files directly onto the `.bat` file to queue and process them automatically.
* **Auto-Dependency Resolution:** If `yt-dlp`, `FFmpeg`, or `Deno` are not found in your system PATH, the script uses native Windows tools (`curl` and `tar`) to download and extract portable versions directly to its folder.
* **Dual Execution Modes:**
  * **Web Download Mode:** Downloads videos or extracts audio from supported URLs using `yt-dlp`. Features modern JavaScript challenge workarounds via `Deno`.
  * **Local File Mode:** Instantly converts or re-muxes local media files using `FFmpeg`.

## Prerequisites

* Windows 10 or Windows 11.
* An active internet connection (required for downloading web media or fetching missing dependencies on the first run).

## Usage

### Method 1: Interactive Menu
1. Double-click the `.bat` file.
2. Paste a URL or local file path when prompted.
3. Select your desired output format from the menu.

### Method 2: Drag-and-Drop (Recommended)
1. Select one or more files (or internet shortcuts) in Windows Explorer.
2. Drag and drop them directly onto the `.bat` file icon.
3. The script will bypass the path prompt, automatically detect the input type, and present the relevant format menu.

## Menu Options

**Web Download Mode (URLs):**
1. Download Video as MP4 (default)
2. Download Video as MKV
3. Download Audio as MP3

**Local File Mode (Local Files):**
1. Extract Audio to MP3 (default)
2. Re-mux to MP4
3. Re-mux to MKV

## License

This project is licensed under the MIT License. You are free to use, modify, and distribute this script as you see fit.

## Acknowledgments

This script relies on the following open-source projects:
* yt-dlp
* FFmpeg
* Deno
