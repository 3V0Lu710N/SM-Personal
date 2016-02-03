@echo off
set BZ2=%CD%\bzip2
forfiles /P files_to_do /S /M "*.*" /C "cmd /c echo. && 0x22%BZ2%0x22 -d @path"
echo Files bzipped successfully
pause
