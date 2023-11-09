@echo off
chcp 65001 >nul
taskkill /f /im explorer.exe
start explorer.exe
exit

