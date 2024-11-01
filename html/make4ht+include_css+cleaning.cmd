@echo off
chcp 65001 >nul
echo.============================================================================
echo                                ВНИМАНИЕ!
echo.
echo Чтобы внедрить в результирующий html-файл создаваемый в процессе компиляции
echo css-файл (с помощью опции css-in), [93mкорневая директория должна содержать 
echo модифицированный файл html5.4ht[0m !
echo.
echo Для удаления неиспользуемых элементов форматирования в генерируемом
echo css-файле, в системе [93mдолжна быть установлена платформа Node.js (Node),
echo а в ней с помощью команды npm install -g purify-css установлен модуль 
echo purifycss[0m !
echo.
echo ----------------------------------------------------------------------------
echo                                ATTENTION!
echo.
echo To embed the css file created during compilation into the resulting html file
echo (using the css-in option), [93mthe root directory must contain a modified
echo html5.4ht file[0m !
echo.
echo To remove unused elements in the generated css file, the Node.js (Node)
echo platform must be installed on the system, and [93mthe purifycss module
echo must be installed in it using the npm install -g purify-css command[0m !
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
make4ht.exe -sm draft %infile% "myconfig,charset=utf-8,css-in" " -cunihtf -utf8"
echo.
echo Creating %~n1.bbl file
del /S /Q /F %~n1.bbl
bibtexu.exe -H -l ru -o ru %~n1
echo.
make4ht.exe -s %infile% "myconfig,charset=utf-8,css-in" " -cunihtf -utf8"
echo.
echo [92m2. Purifying %~n1.css[0m
call purify-css.bat %~n1.css %~n1.html -m
echo.
echo [92m3. Embedding css-file %~n1.css in %~n1.html[0m
echo.
make4ht.exe -sm draft %infile% "myconfig,charset=utf-8,css-in" " -cunihtf -utf8"
echo.
echo [92m4. "Cleaning" of %~n1.html[0m
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
make4ht.exe -m clean -a info %1
xcopy /Y %TEMP%\%~n1\  .\ 
rd /S /Q  %TEMP%\%~n1 

pause
::exit
exit