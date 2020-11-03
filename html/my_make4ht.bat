@echo off
chcp 65001 >nul
echo.
echo 1. Создание файла %~n1.html
echo.
make4ht -sc myconfig.cfg %1 "0,mathjax,p-indent,charset=utf-8" " -cunihtf -utf8"
echo.
echo 2. "Подчистка" файла %~n1.html
echo.
perl -p -i.bak -e "s/>,(\xC2\xA0|\x00\xA0|&#xC2A0;|&#x00A0;)</>, </g" %~n1.html | rem

echo Для удаления рабочих файлов программы make4ht нажмите ENTER.
SET choice=
SET /p choice=Для сохранения рабочих файлов введите любой символ и нажмите ENTER: 
IF NOT '%choice%'=='' GOTO exit

perl -e "unlink qw/%~n1.html.bak %~n1.4ct %~n1.4tc %~n1.dvi %~n1.out  %~n1.idv %~n1.igv %~n1.lg %~n1.tmp %~n1.xref/" | rem

::exit
exit
