# 🎥 Kompresor Wideo do 10 MB (FFmpeg Batch)

Prosty i skuteczny skrypt `.bat`, który kompresuje dowolne pliki wideo z katalogu
do maksymalnie **10 MB**, automatycznie dobierając bitrate na podstawie długości filmu.

Skrypt działa na Windows i korzysta z **FFmpeg** oraz **FFprobe**.

Umieść pliki tak:

<img width="455" height="160" alt="4498msedge_GaZHN5TFYt" src="https://github.com/user-attachments/assets/3dbb4281-1972-47ef-b507-c9fad1284191" />

## ⚙️ Konfiguracja

W górnej części skryptu:

set "MAXSIZE=10485760"

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

<img width="921" height="328" alt="4500cmd_EFJmCbbv1H" src="https://github.com/user-attachments/assets/f73eb59d-8c95-46c5-9280-7d83150ccd9a" />
