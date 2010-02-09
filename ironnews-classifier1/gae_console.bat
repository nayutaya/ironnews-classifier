@echo off

if "%COMPUTERNAME%" == "MACBETH" goto MACBETH
if "%COMPUTERNAME%" == "CAESAR2" goto CAESAR2
goto ELSE

:MACBETH
set PATH=%PATH%;C:\Program Files\Java\jdk1.6.0_13\bin
set RUBYOPT=-rrubygems
goto END

:CAESAR2
set PATH=%PATH%;C:\Program Files\Java\jdk1.6.0_17\bin
set RUBYOPT=-rrubygems
goto END

:ELSE
echo Unknown Host
goto END

:END

cmd
