@echo off
chcp 65001 >nul
echo.
call th.bat %~n1.html
powershell -ExecutionPolicy Bypass -Command "Set-Content %~n1.html -Value (Get-Content %~n1.html | ForEach-Object {$_ -replace '>,&nbsp;<','>, <'})"

echo To delete working files of make4ht press ENTER.
SET choice=
SET /p choice=To keep working files of make4ht enter any symbol and press ENTER:
IF NOT '%choice%'=='' GOTO exit

xcopy /Y *.html  %TEMP%\%~n1\ 
xcopy /Y *.svg  %TEMP%\%~n1\ 
make4ht -m clean -a info %1
xcopy /Y %TEMP%\%~n1\  .\ 
rd /S /Q  %TEMP%\%~n1 
call th.bat %~n1.html 
pause
::exit
exit

