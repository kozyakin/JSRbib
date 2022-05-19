@echo off

cd /d %~dp0
FOR /F "tokens=*" %%i in ('kpsewhich -var-value=TEXMFDIST') do SET texfmdist=%%i

%texfmdist%\..\tlpkg\tlperl\bin\perl.exe authorindex-mod.pl -c %1

