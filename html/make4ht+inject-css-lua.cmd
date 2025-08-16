@echo off
chcp 65001 >nul
for /F %%a in ('echo prompt $E ^| cmd') do (set "esc=%%a")
set "red=%esc%[91m"
set "green=%esc%[92m"
set "yellow=%esc%[93m%"
set "blue=%esc%[94m"
set "reset=%esc%[0m"
echo.============================================================================
echo                                ВНИМАНИЕ!
echo.
echo Для очистки и форматирования генерируемго css-файла, в системе %yellow%должна
echo быть установлена платформа Node.js (Node), а в ней с помощью команд 
echo "npm install -g purify-css" и "npm install -g clean-css-cli" установлены
echo модули "purifycss" и "cleancss"%reset% !
echo.
echo ----------------------------------------------------------------------------
echo                                ATTENTION!
echo.
echo To clean and format the generated css file, the Node.js (Node) platform
echo must be installed on the system, and %yellow%modules "purifycss" and "cleancss" must
echo be installed in it using the commands "npm install -g purify-css" and 
echo "npm install -g clean-css-cli"%reset% !
echo.============================================================================
echo.
:: Sometimes using the input file %1 without a full path, or with a full path 
:: where the directories are separated by a backslash (\), causes an error in 
:: the make4ht and htlatex programs. Therefore, in the next two lines, the 
:: input file %1 name is converted to a full path with a forward slash (/) as 
:: a directory separator.
set "infile=%~dpn1.tex"
set "infile=%infile:\=/%"
echo %green%1. Creation of %~n1.html%reset%
echo.
for %%f in (*.aux *.bbl *.blg %~n1.html %~n1.css) do (del /S /Q /F %%f >nul 2>&1)
echo make4ht.exe -lsm draft %infile%
echo.
make4ht.exe -lsm draft %infile% "myconfig,charset=utf-8" " -cunihtf -utf8"
echo.
echo Creating %~n1.bbl file
echo.
for %%f in (*.aux) do (bibtexu.exe -H -l ru -o ru %%~nf)
echo.
make4ht.exe -ls %infile% "myconfig,charset=utf-8" " -cunihtf -utf8"
echo.
echo %green%2. Purifying %~n1.css%reset%
call purify-css.cmd %~n1.css %~n1.html
echo.
echo %green%3. Injecting css-file %~n1.css in %~n1.html%reset%
texlua inject-css.lua %~n1.css %~n1.html
del /S /Q /F %~n1.css >nul 2>&1
echo.
echo %green%4. "Cleaning" %~n1.html%reset%
echo.
echo %blue%tidy-html5 pass...%reset%
call tidy-html5.cmd %~n1.html 
echo.
echo %blue%powershell search/replace pass...%reset%
powershell.exe -ExecutionPolicy Bypass -Command "Set-Content %~n1.html -Value (Get-Content -Raw %~n1.html | ForEach-Object {$_ -replace '>,&nbsp;<','>, <'})"
powershell.exe -ExecutionPolicy Bypass -Command "Set-Content %~n1.html -Value (Get-Content -Raw %~n1.html | ForEach-Object {$_ -replace '</a> <span','</a><span'})"
echo.
set choice=
set /p "choice=%yellow%To keep working files of make4ht press any key and then ENTER: %reset%"
if /i not "%choice%"=="" GOTO exit
echo.
for %%f in (*.html *.svg *.css) do (xcopy /Y %%f %TEMP%\%~n1\)
make4ht.exe -m clean -a info %1
xcopy /Y %TEMP%\%~n1\  .\ 
rd /S /Q  %TEMP%\%~n1 
for %%f in (*.aux *.bbl *.blg *.out *.toc) do (del /S /Q /F %%f >nul 2>&1)
pause
:exit
exit