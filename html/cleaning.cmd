@echo off
chcp 65001 >nul
SET /p choice=[93mTo start cleaning %~n1.html file press ENTER: [0m

call th.bat %~n1.html
powershell -ExecutionPolicy Bypass -Command "Set-Content %~n1.html -Value (Get-Content %~n1.html | ForEach-Object {$_ -replace '>,&nbsp;<','>, <'})"
call th.bat %~n1.html 

echo.
SET /p choice=[93mTo keep working files of make4ht enter any symbol and press ENTER: [0m
IF NOT '%choice%'=='' GOTO exit
echo.
xcopy /Y *.html  %TEMP%\%~n1\ 
xcopy /Y *.svg  %TEMP%\%~n1\ 
make4ht -m clean -a info %1
xcopy /Y %TEMP%\%~n1\  .\ 
rd /S /Q  %TEMP%\%~n1 

pause
::exit
exit

