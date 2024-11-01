@echo off
@call purifycss.cmd %1 %2 -o %1
@call cleancss.cmd -O2 --format keep-breaks -o %1.clean %1 
if exist %1.clean move %1.clean %1
