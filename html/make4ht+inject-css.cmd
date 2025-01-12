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
set "infile=%~f1"
set "infile=%infile:\=/%"
echo %green%1. Creation of %~n1.html%reset%
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
echo %green%2. Purifying %~n1.css%reset%
call purify-css.cmd %~n1.css %~n1.html
echo.
echo %green%3. Injecting css-file %~n1.css in %~n1.html%reset%
echo.
echo %yellow%To inject css-file in html-file press ENTER%reset%
set choice=
set /p "choice=%yellow%To skip injecting press any key and then ENTER: %reset%"
if /i not "%choice%"=="" GOTO clean
echo.
CHOICE /C tljp /M "%yellow%Select engine for injecting: [T] TexLua or [L] Lua or [J] JavaScript or [P] Perl%reset% "
If %ERRORLEVEL% EQU 1 goto sub_texlua
If %ERRORLEVEL% EQU 2 goto sub_lua
If %ERRORLEVEL% EQU 3 goto sub_js
If %ERRORLEVEL% EQU 4 goto sub_perl

:sub_texlua
texlua inject-css.lua %~n1.css %~n1.html
del /S /Q /F %~n1.css >nul 2>&1
GOTO clean

:sub_lua
lua inject-css.lua %~n1.css %~n1.html
del /S /Q /F %~n1.css >nul 2>&1
GOTO clean

:sub_js
node inject-css.js %~n1.css %~n1.html
del /S /Q /F %~n1.css >nul 2>&1
GOTO clean

:sub_perl
perl inject-css.pl %~n1.css %~n1.html
del /S /Q /F %~n1.css >nul 2>&1

:clean
echo.
echo %green%4. "Cleaning" %~n1.html%reset%
echo.
set choice=
set /p "choice=%yellow%To start cleaning %~n1.html file press ENTER: %reset%"

echo.
echo %blue%...tidy first pass...%reset%
call tidy-html5.cmd %~n1.html
echo.
echo %blue%...powershell search/replace pass...%reset%
powershell.exe -ExecutionPolicy Bypass -Command "Set-Content %~n1.html -Value (Get-Content %~n1.html | ForEach-Object {$_ -replace '>,&nbsp;<','>, <'})"
echo.
echo %blue%...tidy second pass...%reset%
call tidy-html5.cmd --show-info no %~n1.html 

echo.
set choice=
set /p "choice=%yellow%To keep working files of make4ht press any key and then ENTER: %reset%"
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
del /S /Q /F *.out >nul 2>&1
del /S /Q /F *.toc >nul 2>&1
pause
:exit
exit