# 🎥 Kompresor Wideo do 10 MB (FFmpeg Batch)

Prosty i skuteczny skrypt `.bat`, który kompresuje dowolne pliki wideo z katalogu
do maksymalnie **10 MB**, automatycznie dobierając bitrate na podstawie długości filmu.

Skrypt działa na Windows i korzysta z **FFmpeg** oraz **FFprobe**.

Umieść pliki tak:

📂 folder_z_programem
 ├── kompresor.bat
 ├── ffmpeg.exe
 ├── ffprobe.exe
 ├── 📂 do_kompresji
 └── 📂 kompress_10mb   (tworzy się automatycznie)

## ⚙️ Konfiguracja

W górnej części skryptu
np. set "MAXSIZE=10485760"

set "OPEN_OUTPUT=1" 
1 → otworzy folder po zakończeniu
0 → nie otworzy

wymaga:
ffmpeg.exe i ffprobe.exe w tym samym folderze co skrypt
(lub dodane do PATH)

FFmpeg stąd:
https://ffmpeg.org/download.html

✔️ Licencja
Skrypt jest darmowy — możesz go dowolnie modyfikować i używać
