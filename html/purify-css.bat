@echo off
@cmd /c purifycss.cmd %1 %2 -o pur-%1
@cmd /c cleancss.cmd -O2 --format keep-breaks -o %1 pur-%1
del pur-%1
