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
echo compilation process into the resulting html-file, the [93mthe root directory 
echo must contain a modified html5.4ht file[0m !
echo.============================================================================
echo.
echo 1. Creation of %~n1.html
echo.
make4ht -sc myconfig.cfg %1 "0,mathjax,p-indent,charset=utf-8" " -cunihtf -utf8"
echo.
echo 2. Embedding css-file %~n1.css in %~n1.html
echo.
make4ht -sc myconfig.cfg -m draft %1 "0,mathjax,p-indent,charset=utf-8,css-in" " -cunihtf -utf8"
echo.
echo 3. "Cleaning" of %~n1.html
echo.
perl -p -i.bak -e "s/<\/a>,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)<a/<\/a>, <a/g";  -e "s/,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)<\/span>/, <\/span>/g"; -e "s/.figure \&gt; p/.figure \> p/g" %~n1.html | rem

echo To delete working files of make4ht press ENTER.
SET choice=
SET /p choice=To keep  working files of make4ht enter any symbol and press ENTER:
IF NOT '%choice%'=='' GOTO exit

perl -e "unlink qw/%~n1.html.bak %~n1.4ct %~n1.4tc %~n1.dvi %~n1.out  %~n1.idv %~n1.igv %~n1.lg %~n1.tmp %~n1.xref/" | rem

::exit
exit

