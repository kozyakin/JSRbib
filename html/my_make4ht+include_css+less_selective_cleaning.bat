@echo off
chcp 65001 >nul
echo.============================================================================
echo                                ВНИМАНИЕ!
echo.
echo Для внедрения (с помощью опции css-in) создаваемого в процессе компиляции 
echo.css-файла в результирующий html-файл в корневой директории должен находиться 
echo модифицированный файл html5.4ht !
echo.============================================================================
echo.
echo 1. Создание файла %~n1.html
echo.
make4ht -sc myconfig.cfg %1 "0,mathjax,p-indent,charset=utf-8" " -cunihtf -utf8"
echo.
echo 2. Внедрение css-файла %~n1.css в %~n1.html
echo.
make4ht -sc myconfig.cfg -m draft %1 "0,mathjax,p-indent,charset=utf-8,css-in" " -cunihtf -utf8"
echo.
echo 3. "Подчистка" файла %~n1.html
echo.
perl -p -i.bak -e "s/>,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)</>, </g"; -e "s/.figure \&gt; p/.figure \> p/g" %~n1.html | rem

echo Для удаления рабочих файлов программы make4ht нажмите ENTER.
SET choice=
SET /p choice=Для сохранения рабочих файлов введите любой символ и нажмите ENTER: 
IF NOT '%choice%'=='' GOTO exit

perl -e "unlink qw/%~n1.html.bak %~n1.4ct %~n1.4tc %~n1.dvi %~n1.out  %~n1.idv %~n1.igv %~n1.lg %~n1.tmp %~n1.xref/" | rem

::exit
exit

