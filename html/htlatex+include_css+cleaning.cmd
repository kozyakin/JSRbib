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
echo [92m1. Creation of %~n1.html[0m
echo.
mk4ht htlatex %1 "myconfig" " -cunihtf -utf8"
echo.
echo [92m2. Embedding css-file %~n1.css in %~n1.html[0m
echo.
mk4ht htlatex %1 "myconfig" " -cunihtf -utf8"
echo.
echo [92m3. "Cleaning" of %~n1.html[0m
echo.
call cleaning.cmd   %1
exit

