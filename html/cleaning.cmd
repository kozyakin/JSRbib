@echo off
chcp 65001 >nul
echo.
perl -p -i.bak -e "s/>,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)</>, </g"; -e "s/>(\xC2\xA0)<\/span><a/> <\/span><a/g"; -e "s/.figure \&gt; p/.figure \> p/g" %~n1.html | rem

echo To delete working files of make4ht press ENTER.
SET choice=
SET /p choice=To keep working files of make4ht enter any symbol and press ENTER:
IF NOT '%choice%'=='' GOTO exit

del /S /F /Q "%~n1.html.bak"
xcopy /Y *.html  %TEMP%\%~n1\ 
xcopy /Y *.svg  %TEMP%\%~n1\ 
make4ht -m clean -a info %1
xcopy /Y %TEMP%\%~n1\  .\ 
rd /S /Q  %TEMP%\%~n1  
call th.bat %~n1.html
pause
::exit
exit

