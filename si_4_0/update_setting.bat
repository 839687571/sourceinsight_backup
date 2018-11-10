@echo off
set  SIDIR="C:\Users\%USERNAME%\Documents\Source Insight 4.0\Settings\"

echo list files
for /f %%i in ('dir /b %SIDIR%') do (echo %%i
)

mkdir  Settings

ECHO %SIDIR%/Settings/* 

xcopy /S /d  %SIDIR%*  .\Settings\*