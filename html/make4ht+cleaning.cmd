@echo off
chcp 65001 >nul
echo.============================================================================
echo                                ВНИМАНИЕ!
echo.
echo Для очистки и форматирования генерируемго css-файла, в системе [93mдолжна
echo быть установлена платформа Node.js (Node), а в ней с помощью команд 
echo "npm install -g purify-css" и "npm install -g clean-css-cli" установлены
echo модули "purifycss" и "cleancss"[0m !
echo.
echo ----------------------------------------------------------------------------
echo                                ATTENTION!
echo.
echo To clean and format the generated css file, the Node.js (Node) platform
echo must be installed on the system, and [93mmodules "purifycss" and "cleancss" must
echo be installed in it using the commands "npm install -g purify-css" and 
echo "npm install -g clean-css-cli"[0m !
echo.============================================================================
echo.
:: Sometimes using the input file %1 without a full path, or with a full path 
:: where the directories are separated by a backslash (\), causes an error in 
:: the make4ht and htlatex programs. Therefore, in the next two lines, the 
:: input file %1 name is converted to a full path with a forward slash (/) as 
:: a directory separator.
set "infile=%~f1"
set "infile=%infile:\=/%"
echo [92m1. Creation of %~n1.html[0m
echo.
del /S /Q /F *.aux >nul 2>&1
del /S /Q /F *.bbl >nul 2>&1
del /S /Q /F *.blg >nul 2>&1
pdflatex.exe -draftmode %infile% >nul
echo.
echo Creating %~n1.bbl file
for %%f in (*.aux) do (bibtexu.exe -H -l ru -o ru %%~nf)
echo.
make4ht.exe -s %infile% "myconfig,charset=utf-8" " -cunihtf -utf8"
echo.
echo [92m2. Purifying %~n1.css[0m
call purify-css.bat %~n1.css %~n1.html
echo.
echo [92m3. Cleaning %~n1.html[0m
echo.
SET /p choice=[93mTo start cleaning %~n1.html file press ENTER: [0m

echo.
echo [94m...tidy first pass...[0m
call tidy-html5.bat %~n1.html
echo.
echo [94m...powershell search/replace pass...[0m
powershell.exe -ExecutionPolicy Bypass -Command "Set-Content %~n1.html -Value (Get-Content %~n1.html | ForEach-Object {$_ -replace '>,&nbsp;<','>, <'})"
echo.
echo [94m...tidy second pass...[0m
call tidy-html5.bat --show-info no %~n1.html 

echo.
SET /p choice=[93mTo keep working files of make4ht enter any symbol and press ENTER: [0m
IF NOT '%choice%'=='' GOTO exit
echo.
xcopy /Y *.html  %TEMP%\%~n1\ 
xcopy /Y *.svg  %TEMP%\%~n1\ 
xcopy /Y *.css  %TEMP%\%~n1\ 
make4ht.exe -m clean -a info %1
xcopy /Y %TEMP%\%~n1\  .\ 
rd /S /Q  %TEMP%\%~n1 
del /S /Q /F *.aux >nul 2>&1
del /S /Q /F *.bbl >nul 2>&1
del /S /Q /F *.blg >nul 2>&1
del /S /Q /F *.toc >nul 2>&1
pause
::exit
exit