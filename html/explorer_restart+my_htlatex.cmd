@echo off
chcp 65001 >nul
taskkill /f /im explorer.exe
start explorer.exe
start "" my_htlatex+include_css+cleaning.cmd   %1
exit

