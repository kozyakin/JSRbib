@echo off
@cmd /c purifycss.cmd "%1" "%2" -o "%TEMP%\%1"
@cmd /c cleancss.cmd -O2 --format keep-breaks -o "%1" "%TEMP%\%1"
del /Q "%TEMP%\%1"
