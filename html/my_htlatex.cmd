@echo off
chcp 65001 >nul
echo.
echo [92m1. Creation of %~n1.html[0m
echo.
:: Sometimes using the input file %1 without a full path, or with a full path 
:: where the directories are separated by a backslash (\), causes an error in 
:: the make4ht and htlatex programs. Therefore, in the next two lines, the 
:: input file %1 name is converted to a full path with a forward slash (/) as 
:: a directory separator.
set "infile=%~f1"
set "infile=%infile:\=/%"
mk4ht htlatex %infile% "myconfig" " -cunihtf -utf8"
echo.
echo [92m2. "Cleaning" of %~n1.html[0m
echo.
call cleaning.cmd   %1
exit
