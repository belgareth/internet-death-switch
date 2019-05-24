@echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
@echo off
:: CHANGE DEFAULT GW IP BELOW. IT IS USED IF THE SCRIPT CAN'T DETECT YOUR GW IP
set defgw=192.168.0.1
@For /f "tokens=3" %%1 in (
   'route.exe print 0.0.0.0 ^|findstr "\<0.0.0.0.*0.0.0.0\>"') Do set defgw=%%1
cls
:start
cls
echo.
color 0A
echo VPN IP KILL SWITCH
echo.
echo.
echo Your NON-VPN (ISP) gateway is probably "%defgw%"
echo.
echo USAGE:
echo.
echo -Press "1" to REMOVE default gateway (IP "%defgw%")
echo -Press "2" to RESTORE default gateway (IP "%defgw%")
echo -Press "3" Flush DNS
echo -Press "4" To Ping EVIL
echo -Press "h" for more info.
echo -Press "x" or CTRL-C to exit script.
echo.
set /p choice=Your choice:
if '%Choice%'=='1' goto :choice1
if '%Choice%'=='2' goto :choice2
if '%Choice%'=='3' goto :choice3
if '%Choice%'=='4' goto :choice4
if '%Choice%'=='x' goto :exit
if '%Choice%'=='h' goto :help
echo Insert 1, 2, 3, x or h
timeout 2
goto start
:choice1
route delete 0.0.0.0 %defgw%
echo Default gateway "%defgw%" removed
timeout 2
goto start
:choice2
route add 0.0.0.0 mask 0.0.0.0 %defgw%
echo Default gateway "%defgw%" restored
timeout 2
goto start
:choice3
echo
ipconfig /flushdns
timeout 2
goto start
:choice4
ping 8.8.8.8
timeout 1
goto start
:help
cls
timeout /T -1
goto start
:exit
exit
