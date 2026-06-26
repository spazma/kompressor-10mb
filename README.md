# 🎥 Kompresor Wideo do 10 MB (FFmpeg Batch)

Prosty i skuteczny skrypt `.bat`, który kompresuje dowolne pliki wideo z katalogu
do maksymalnie **10 MB**, automatycznie dobierając bitrate na podstawie długości filmu.

Skrypt działa na Windows i korzysta z **FFmpeg** oraz **FFprobe**.

Wykrywa NVENC jak brak lecimy na CPU (libx264) :)

Umieść pliki tak:

<img width="455" height="160" alt="4498msedge_GaZHN5TFYt" src="https://github.com/user-attachments/assets/3dbb4281-1972-47ef-b507-c9fad1284191" />

## ⚙️ Konfiguracja

W górnej części skryptu:

set "MAXSIZE=10000000"

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

<img width="992" height="642" alt="kompressor-10mb" src="https://github.com/user-attachments/assets/cc259ac3-4301-4c66-8149-d9747802c3f4" />

