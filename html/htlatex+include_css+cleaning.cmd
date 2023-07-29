@echo off
chcp 65001 >nul
echo.============================================================================
echo                                ВНИМАНИЕ!
echo.
echo Чтобы внедрить (с помощью опции css-in) в результирующий html-файл 
echo css-файл, создаваемый в процессе компиляции, [93mкорневая директория должна 
echo содержать модифицированный файл html5.4ht[0m !
echo.
echo ----------------------------------------------------------------------------
echo                                ATTENTION!
echo.
echo To inject (with the css-in option) the css-file created during the 
echo compilation process into the resulting html-file, [93mthe root directory 
echo must contain a modified html5.4ht file[0m !
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
mk4ht htlatex %infile% "myconfig" " -cunihtf -utf8"
echo.
echo [92m2. Embedding css-file %~n1.css in %~n1.html[0m
echo.
mk4ht htlatex %infile% "myconfig" " -cunihtf -utf8"
echo.
echo [92m3. "Cleaning" of %~n1.html[0m
echo.
call cleaning.cmd   %1
exit

