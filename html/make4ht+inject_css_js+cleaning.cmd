@echo off
chcp 65001 >nul
for /F %%a in ('echo prompt $E ^| cmd') do (set "ESC=%%a")
echo.============================================================================
echo                                ВНИМАНИЕ!
echo.
echo Для очистки и форматирования генерируемго css-файла, в системе %ESC%[93mдолжна
echo быть установлена платформа Node.js (Node), а в ней с помощью команд 
echo "npm install -g purify-css" и "npm install -g clean-css-cli" установлены
echo модули "purifycss" и "cleancss"%ESC%[0m !
echo.
echo ----------------------------------------------------------------------------
echo                                ATTENTION!
echo.
echo To clean and format the generated css file, the Node.js (Node) platform
echo must be installed on the system, and %ESC%[93mmodules "purifycss" and "cleancss" must
echo be installed in it using the commands "npm install -g purify-css" and 
echo "npm install -g clean-css-cli"%ESC%[0m !
echo.============================================================================
echo.
:: Sometimes using the input file %1 without a full path, or with a full path 
:: where the directories are separated by a backslash (\), causes an error in 
:: the make4ht and htlatex programs. Therefore, in the next two lines, the 
:: input file %1 name is converted to a full path with a forward slash (/) as 
:: a directory separator.
set "infile=%~f1"
set "infile=%infile:\=/%"
echo %ESC%[92m1. Creation of %~n1.html%ESC%[0m
echo.
del /S /Q /F *.aux >nul 2>&1
del /S /Q /F *.bbl >nul 2>&1
del /S /Q /F *.blg >nul 2>&1
del /S /Q /F %~n1.html >nul 2>&1
del /S /Q /F %~n1.css >nul 2>&1
echo pdflatex.exe -draftmode --shell-escape %infile%
echo.
pdflatex.exe -draftmode --shell-escape %infile% >nul
echo.
echo Creating %~n1.bbl file
echo.
for %%f in (*.aux) do (bibtexu.exe -H -l ru -o ru %%~nf)
echo.
make4ht.exe -s %infile% "myconfig,charset=utf-8" " -cunihtf -utf8"
echo.
echo %ESC%[92m2. Purifying %~n1.css%ESC%[0m
call purify-css.bat %~n1.css %~n1.html
echo.
echo %ESC%[92m3. Injecting css-file %~n1.css in %~n1.html%ESC%[0m
echo.
echo %ESC%[93mTo inject css-file in html-file press ENTER%ESC%[0m
set choice=
set /p "choice=%ESC%[93mTo skip injecting press any key and then ENTER: %ESC%[0m"
if /i not "%choice%"=="" GOTO clean
node inject-css.js %~n1.css %~n1.html
del /S /Q /F %~n1.css >nul 2>&1
:clean
echo.
echo %ESC%[92m4. "Cleaning" %~n1.html%ESC%[0m
echo.
set choice=
set /p "choice=%ESC%[93mTo start cleaning %~n1.html file press ENTER: %ESC%[0m"

echo.
echo %ESC%[94m...tidy first pass...%ESC%[0m
call tidy-html5.bat %~n1.html
echo.
echo %ESC%[94m...powershell search/replace pass...%ESC%[0m
powershell.exe -ExecutionPolicy Bypass -Command "Set-Content %~n1.html -Value (Get-Content %~n1.html | ForEach-Object {$_ -replace '>,&nbsp;<','>, <'})"
echo.
echo %ESC%[94m...tidy second pass...%ESC%[0m
call tidy-html5.bat --show-info no %~n1.html 

echo.
set choice=
set /p "choice=%ESC%[93mTo keep working files of make4ht press any key and then ENTER: %ESC%[0m"
if /i not "%choice%"=="" GOTO exit
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
:exit
exit