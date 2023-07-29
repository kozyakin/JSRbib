@echo off
chcp 65001 >nul
echo.
echo [92m1. Creation of %~n1.html[0m
echo.
:: The next two lines define forward slashed full path of input file %1
set "infile=%~f1"
set "infile=%infile:\=/%"
mk4ht htlatex %infile% "myconfig" " -cunihtf -utf8"
echo.
echo [92m2. "Cleaning" of %~n1.html[0m
echo.
call cleaning.cmd   %1
exit
