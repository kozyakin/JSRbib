@echo off
chcp 65001 >nul
echo.============================================================================
echo                                ВНИМАНИЕ!
echo.
echo Для внедрения (с помощью опции css-in) создаваемого в процессе компиляции 
echo .css-файла в результирующий html-файл в корневой директории должен находиться 
echo модифицированный файл html5.4ht !
echo
echo ----------------------------------------------------------------------------
echo                                ATTENTION!
echo.
echo To embed (using the css-in option) generated at compile-time
echo .css file to the resulting html file in the root directory should be
echo modified html5.4ht file!
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

