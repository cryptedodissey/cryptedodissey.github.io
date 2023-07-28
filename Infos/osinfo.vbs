'// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// NAME:        osinfo.vbs
'//
'// Original:    http://www.cluberti.com/blog
'// Last Update: 15th January 2010
'//
'// Comment:     VBS example file for use as an OS info gathering template.
'//
'// NOTE:        Provided as-is - usage of this source assumes that you are at the
'//              very least familiar with the vbscript language being used and
'//              the tools used to create and debug this file.
'//
'//              In other words, if you break it, you get to keep the pieces.
'//
'//              Also, if you want to use this on W2K, prepare to hack, as this
'//              was really designed with XP+ systems in mind.
'//
'// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// This script will require elevated privileges if run from a non-admin account, so
'// calling the ElevateThisScript() Sub should get the script a full admin token. This is
'// currently disabled, but if you need non-admin users to run this script, enable the
'// call to this subroutine to pop-up a dialog box (they'll of course need administrative
'// credentials to put in the challenge dialog before the script will execute with an
'// administrative token):
 
Dim ScriptHelper
Set ScriptHelper = New ScriptHelperClass
 
ScriptHelper.RunMeWithCScript()
'ScriptHelper.ElevateThisScript()
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Set variables and WMI connections for scripting against:
 
strComputer = ScriptHelper.Network.ComputerName
 
CONST HKEY_CLASSES_ROOT  = &H80000000
CONST HKEY_CURRENT_USER  = &H80000001
CONST HKEY_LOCAL_MACHINE = &H80000002
CONST HKEY_USERS         = &H80000003
CONST KEY_QUERY_VALUE      = 1
CONST KEY_SET_VALUE          = 2
CONST SEARCH_KEY = "DigitalProductID"
 
Dim arrSubKeys(4,1)
Dim foundKeys
Dim iValues, arrDPID
foundKeys = Array()
iValues = Array()
arrSubKeys(0,0) = "Windows PID Key:       "
arrSubKeys(0,1) = "SOFTWARE\Microsoft\Windows NT\CurrentVersion"
arrSubKeys(2,0) = "Office XP PID Key:     "
arrSubKeys(2,1) = "SOFTWARE\Microsoft\Office\10.0\Registration"
arrSubKeys(1,0) = "Office 2003 PID Key:   "
arrSubKeys(1,1) = "SOFTWARE\Microsoft\Office\11.0\Registration"
arrSubKeys(3,0) = "Office 2007 PID Key:   "
arrSubKeys(3,1) = "SOFTWARE\Microsoft\Office\12.0\Registration"
arrSubKeys(4,0) = "Office 2010 PID Key:   "
 
Arch = ""
Sku = ""
 
Set colOSItems = ScriptHelper.WMI.ExecQuery( _
    "SELECT * FROM Win32_OperatingSystem",,48)
 
Set colProcItems = ScriptHelper.WMI.ExecQuery( _
    "SELECT * FROM Win32_Processor",,48)
 
Set colCompSysItems = ScriptHelper.WMI.ExecQuery( _
    "SELECT * FROM Win32_ComputerSystem",,48)
 
Set colTZItems = ScriptHelper.WMI.ExecQuery( _
    "SELECT * FROM Win32_TimeZone",,48)
 
Set colCompSysProdItems = ScriptHelper.WMI.ExecQuery( _
    "SELECT * FROM Win32_ComputerSystemProduct",,48)
 
Set colBIOSItems = ScriptHelper.WMI.ExecQuery( _
    "SELECT * FROM Win32_BIOS",,48)
 
Set colDiskItems = ScriptHelper.WMI.ExecQuery( _
    "SELECT * FROM Win32_LogicalDisk",,48)
 
Set colNetAdapConfigItems = ScriptHelper.WMI.ExecQuery( _
    "SELECT * FROM Win32_NetworkAdapterConfiguration",,48)
 
Set colVideoItems = ScriptHelper.WMI.ExecQuery( _
    "SELECT * FROM Win32_VideoController",,48)
 
Set colSoundItems = ScriptHelper.WMI.ExecQuery( _
    "SELECT * FROM Win32_SoundDevice",,48)
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// If Office 2010 is installed, find the Office 2010 registry key holding the ProductID:
 
Dim strKey, subkey, arrSubkeys2, strOfficeKey, strValue
strKey = "SOFTWARE\Microsoft\Office\14.0\Registration"
 
ScriptHelper.Registry.EnumKey HKEY_LOCAL_MACHINE, strKey, arrSubkeys2
If IsNull(arrSubkeys2) Then
    'Office 2010 not installed, skip it
    arrSubKeys(4,1) = ""
Else
    For Each subkey In arrSubkeys2
        ScriptHelper.Registry.GetBinaryValue HKEY_LOCAL_MACHINE, strKey & "\" & subkey, SEARCH_KEY, strValue
        If IsNull(strValue) Then
            strOfficeKey = ""
        Else
            strOfficeKey = strKey & "\" & subkey
            arrSubKeys(4,1) = strOfficeKey
        End If
    Next
End If
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Get OS SKU from Win32_OperatingSystem class:
 
    For Each objOSItem in colOSItems
    If objOSItem.BuildNumber => 6000 Then
        Arch = objOSItem.OSArchitecture
 
        Select Case objOSItem.OperatingSystemSKU
            Case 0 Sku = "Unknown Windows version"
            Case 1 Sku = "Ultimate Edition"
            Case 2 Sku = "Home Basic Edition"
            Case 3 Sku = "Home Premium Edition"
            Case 4 Sku = "Enterprise Edition"
            Case 5 Sku = "Home Basic N Edition"
            Case 6 Sku = "Business Edition"
            Case 7 Sku = "Standard Server Edition"
            Case 8 Sku = "Datacenter Server Edition"
            Case 9 Sku = "Small Business Server Edition"
            Case 10 Sku = "Enterprise Server Edition"
            Case 11 Sku = "Starter Edition"
            Case 12 Sku = "Datacenter Server Core Edition"
            Case 13 Sku = "Standard Server Core Edition"
            Case 14 Sku = "Enterprise Server Core Edition"
            Case 15 Sku = "Enterprise Server Edition for Itanium-Based Systems"
            Case 16 Sku = "Business N Edition"
            Case 17 Sku = "Web Server Edition"
            Case 18 Sku = "Cluster Server Edition"
            Case 19 Sku = "Home Server Edition"
            Case 20 Sku = "Storage Express Server Edition"
            Case 21 Sku = "Storage Standard Server Edition"
            Case 22 Sku = "Storage Workgroup Server Edition"
            Case 23 Sku = "Storage Enterprise Server Edition"
            Case 24 Sku = "Server For Small Business Edition"
            Case 25 Sku = "Small Business Server Premium Edition"
            Case Else
            Sku = "Could Not Determine Operating System SKU"
        End Select
    End If
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Get current OS locale setting from Win32_OperatingSystem class:
 
        Select Case objOSItem.Locale
            Case 0436 Locale = "Afrikaans (South Africa)"
            Case 041c Locale = "Albanian (Albania)"
            ' Case 045e Locale = "Amharic (Ethiopia)"
            Case 0401 Locale = "Arabic (Saudi Arabia)"
            Case 1401 Locale = "Arabic (Algeria)"
            Case 3c01 Locale = "Arabic (Bahrain)"
            Case 0c01 Locale = "Arabic (Egypt)"
            Case 0801 Locale = "Arabic (Iraq)"
            Case 2c01 Locale = "Arabic (Jordan)"
            Case 3401 Locale = "Arabic (Kuwait)"
            Case 3001 Locale = "Arabic (Lebanon)"
            Case 1001 Locale = "Arabic (Libya)"
            Case 1801 Locale = "Arabic (Morocco)"
            Case 2001 Locale = "Arabic (Oman)"
            Case 4001 Locale = "Arabic (Qatar)"
            Case 2801 Locale = "Arabic (Syria)"
            Case 1c01 Locale = "Arabic (Tunisia)"
            Case 3801 Locale = "Arabic (U.A.E.)"
            Case 2401 Locale = "Arabic (Yemen)"
            Case 042b Locale = "Armenian (Armenia)"
            Case 044d Locale = "Assamese"
            Case 082c Locale = "Azeri (Cyrillic)"
            Case 042c Locale = "Azeri (Latin)"
            Case 042d Locale = "Basque"
            Case 0423 Locale = "Belarusian"
            Case 0445 Locale = "Bengali (India)"
            Case 0845 Locale = "Bengali (Bangladesh)"
            Case 141A Locale = "Bosnian (Bosnia/Herzegovina)"
            Case 0402 Locale = "Bulgarian"
            Case 0455 Locale = "Burmese"
            Case 0403 Locale = "Catalan"
            Case 045c Locale = "Cherokee (United States)"
            Case 0804 Locale = "Chinese (PRC)"
            Case 1004 Locale = "Chinese (Singapore)"
            Case 0404 Locale = "Chinese (Taiwan)"
            Case 0c04 Locale = "Chinese (Hong Kong SAR)"
            Case 1404 Locale = "Chinese (Macao SAR)"
            Case 041a Locale = "Croatian"
            Case 101a Locale = "Croatian (Bosnia/Herzegovina)"
            Case 0405 Locale = "Czech"
            Case 0406 Locale = "Danish"
            Case 0465 Locale = "Divehi"
            Case 0413 Locale = "Dutch (Netherlands)"
            Case 0813 Locale = "Dutch (Belgium)"
            Case 0466 Locale = "Edo"
            Case 0409 Locale = "English (United States)"
            Case 0809 Locale = "English (United Kingdom)"
            Case 0c09 Locale = "English (Australia)"
            Case 2809 Locale = "English (Belize)"
            Case 1009 Locale = "English (Canada)"
            Case 2409 Locale = "English (Caribbean)"
            Case 3c09 Locale = "English (Hong Kong SAR)"
            Case 4009 Locale = "English (India)"
            Case 3809 Locale = "English (Indonesia)"
            Case 1809 Locale = "English (Ireland)"
            Case 2009 Locale = "English (Jamaica)"
            Case 4409 Locale = "English (Malaysia)"
            Case 1409 Locale = "English (New Zealand)"
            Case 3409 Locale = "English (Philippines)"
            Case 4809 Locale = "English (Singapore)"
            Case 1c09 Locale = "English (South Africa)"
            Case 2c09 Locale = "English (Trinidad)"
            Case 3009 Locale = "English (Zimbabwe)"
            Case 0425 Locale = "Estonian"
            Case 0438 Locale = "Faroese"
            Case 0429 Locale = "Farsi"
            Case 0464 Locale = "Filipino"
            Case 040b Locale = "Finnish"
            Case 040c Locale = "French (France)"
            Case 080c Locale = "French (Belgium)"
            Case 2c0c Locale = "French (Cameroon)"
            Case 0c0c Locale = "French (Canada)"
            Case 240c Locale = "French (DRC)"
            Case 300c Locale = "French (Cote d'Ivoire)"
            Case 3c0c Locale = "French (Haiti)"
            Case 140c Locale = "French (Luxembourg)"
            Case 340c Locale = "French (Mali)"
            Case 180c Locale = "French (Monaco)"
            Case 380c Locale = "French (Morocco)"
            Case e40c Locale = "French (North Africa)"
            Case 200c Locale = "French (Reunion)"
            Case 280c Locale = "French (Senegal)"
            Case 100c Locale = "French (Switzerland)"
            Case 1c0c Locale = "French (West Indies)"
            Case 0462 Locale = "Frisian (Netherlands)"
            Case 0467 Locale = "Fulfulde (Nigeria)"
            Case 042f Locale = "FYRO Macedonian"
            Case 083c Locale = "Gaelic (Ireland)"
            Case 043c Locale = "Gaelic (Scotland)"
            Case 0456 Locale = "Galician"
            Case 0437 Locale = "Georgian"
            Case 0407 Locale = "German (Germany)"
            Case 0c07 Locale = "German (Austria)"
            Case 1407 Locale = "German (Liechtenstein)"
            Case 1007 Locale = "German (Luxembourg)"
            Case 0807 Locale = "German (Switzerland)"
            Case 0408 Locale = "Greek"
            Case 0474 Locale = "Guarani (Paraguay)"
            Case 0447 Locale = "Gujarati"
            Case 0468 Locale = "Hausa (Nigeria)"
            Case 0475 Locale = "Hawaiian (United States)"
            Case 040d Locale = "Hebrew"
            Case 0439 Locale = "Hindi"
            ' Case 040e Locale = "Hungarian"
            Case 0469 Locale = "Ibibio (Nigeria)"
            Case 040f Locale = "Icelandic"
            Case 0470 Locale = "Igbo (Nigeria)"
            Case 0421 Locale = "Indonesian"
            Case 045d Locale = "Inuktitut"
            Case 0410 Locale = "Italian (Italy)"
            Case 0810 Locale = "Italian (Switzerland)"
            Case 0411 Locale = "Japanese"
            Case 044b Locale = "Kannada"
            Case 0471 Locale = "Kanuri (Nigeria)"
            Case 0860 Locale = "Kashmiri"
            Case 0460 Locale = "Kashmiri (Arabic)"
            Case 043f Locale = "Kazakh"
            Case 0453 Locale = "Khmer"
            Case 0457 Locale = "Konkani"
            Case 0412 Locale = "Korean"
            Case 0440 Locale = "Kyrgyz (Cyrillic)"
            Case 0454 Locale = "Lao"
            Case 0476 Locale = "Latin"
            Case 0426 Locale = "Latvian"
            Case 0427 Locale = "Lithuanian"
            ' Case 043e Locale = "Malay (Malaysia)"
            ' Case 083e Locale = "Malay (Brunei Darussalam)"
            Case 044c Locale = "Malayalam"
            Case 043a Locale = "Maltese"
            Case 0458 Locale = "Manipuri"
            Case 0481 Locale = "Maori (New Zealand)"
            ' Case 044e Locale = "Marathi"
            Case 0450 Locale = "Mongolian (Cyrillic)"
            Case 0850 Locale = "Mongolian (Mongolian)"
            Case 0461 Locale = "Nepali"
            Case 0861 Locale = "Nepali (India)"
            Case 0414 Locale = "Norwegian (Bokmål)"
            Case 0814 Locale = "Norwegian (Nynorsk)"
            Case 0448 Locale = "Oriya"
            Case 0472 Locale = "Oromo"
            Case 0479 Locale = "Papiamentu"
            Case 0463 Locale = "Pashto"
            Case 0415 Locale = "Polish"
            Case 0416 Locale = "Portuguese (Brazil)"
            Case 0816 Locale = "Portuguese (Portugal)"
            Case 0446 Locale = "Punjabi"
            Case 0846 Locale = "Punjabi (Pakistan)"
            Case 046B Locale = "Quecha (Bolivia)"
            Case 086B Locale = "Quecha (Ecuador)"
            Case 0C6B Locale = "Quecha (Peru)"
            Case 0417 Locale = "Rhaeto-Romanic"
            Case 0418 Locale = "Romanian"
            Case 0818 Locale = "Romanian (Moldava)"
            Case 0419 Locale = "Russian"
            Case 0819 Locale = "Russian (Moldava)"
            Case 043b Locale = "Sami (Lappish)"
            Case 044f Locale = "Sanskrit"
            Case 046c Locale = "Sepedi"
            Case 0c1a Locale = "Serbian (Cyrillic)"
            Case 081a Locale = "Serbian (Latin)"
            Case 0459 Locale = "Sindhi (India)"
            Case 0859 Locale = "Sindhi (Pakistan)"
            Case 045b Locale = "Sinhalese (Sri Lanka)"
            Case 041b Locale = "Slovak"
            Case 0424 Locale = "Slovenian"
            Case 0477 Locale = "Somali"
            ' Case 042e Locale = "Sorbian"
            Case 0c0a Locale = "Spanish (Spain - Modern Sort)"
            Case 040a Locale = "Spanish (Spain - Traditional Sort)"
            Case 2c0a Locale = "Spanish (Argentina)"
            Case 400a Locale = "Spanish (Bolivia)"
            Case 340a Locale = "Spanish (Chile)"
            Case 240a Locale = "Spanish (Colombia)"
            Case 140a Locale = "Spanish (Costa Rica)"
            Case 1c0a Locale = "Spanish (Dominican Republic)"
            Case 300a Locale = "Spanish (Ecuador)"
            Case 440a Locale = "Spanish (El Salvador)"
            Case 100a Locale = "Spanish (Guatemala)"
            Case 480a Locale = "Spanish (Honduras)"
            Case 580a Locale = "Spanish (Latin America)"
            Case 080a Locale = "Spanish (Mexico)"
            Case 4c0a Locale = "Spanish (Nicaragua)"
            Case 180a Locale = "Spanish (Panama)"
            Case 3c0a Locale = "Spanish (Paraguay)"
            Case 280a Locale = "Spanish (Peru)"
            Case 500a Locale = "Spanish (Puerto Rico)"
            Case 540a Locale = "Spanish (United States)"
            Case 380a Locale = "Spanish (Uruguay)"
            Case 200a Locale = "Spanish (Venezuela)"
            Case 0430 Locale = "Sutu"
            Case 0441 Locale = "Swahili"
            Case 041d Locale = "Swedish"
            Case 081d Locale = "Swedish (Finland)"
            Case 045a Locale = "Syriac"
            Case 0428 Locale = "Tajik"
            Case 045f Locale = "Tamazight (Arabic)"
            Case 085f Locale = "Tamazight (Latin)"
            Case 0449 Locale = "Tamil"
            Case 0444 Locale = "Tatar"
            Case 044a Locale = "Telugu"
            ' Case 041e Locale = "Thai"
            Case 0851 Locale = "Tibetan (Bhutan)"
            Case 0451 Locale = "Tibetan (PRC)"
            Case 0873 Locale = "Tigrigna (Eritrea)"
            Case 0473 Locale = "Tigrigna (Ethiopia)"
            Case 0431 Locale = "Tsonga"
            Case 0432 Locale = "Tswana"
            Case 041f Locale = "Turkish"
            Case 0442 Locale = "Turkmen"
            Case 0480 Locale = "Uighur (China)"
            Case 0422 Locale = "Ukrainian"
            Case 0420 Locale = "Urdu"
            Case 0820 Locale = "Urdu (India)"
            Case 0843 Locale = "Uzbek (Cyrillic)"
            Case 0443 Locale = "Uzbek (Latin)"
            Case 0433 Locale = "Venda"
            Case 042a Locale = "Vietnamese"
            Case 0452 Locale = "Welsh"
            Case 0434 Locale = "Xhosa"
            Case 0478 Locale = "Yi"
            Case 043d Locale = "Yiddish"
            Case 046a Locale = "Yoruba"
            Case 0435 Locale = "Zulu"
            Case 04ff Locale = "HID (Human Interface Device)"
            Case Else
            Locale = "Could Not Determine OS Locale"
        End Select
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Set variables gathered from Win32_OperatingSystem class:
 
        Caption = objOSItem.Caption
        CSDVersion = objOSItem.CSDVersion
        CSName = objOSItem.CSName
        Version = objOSItem.Version
        BuildType = objOSItem.BuildType
        BuildNumber = objOSItem.BuildNumber
        SerialNumber = objOSItem.SerialNumber
 
        ScriptHelper.SWbemDateTime.Value = objOSItem.InstallDate
        InstallDate = ScriptHelper.SWbemDateTime.GetVarDate(True)
 
        ScriptHelper.SWbemDateTime.Value = objOSItem.LastBootUpTime
        LastBootUpTime = ScriptHelper.SWbemDateTime.GetVarDate(True)
 
        Status = objOSItem.Status
    Next
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Set variables gathered from Win32_ComputerSystem class:
 
    For Each objCompSysItem in colCompSysItems
        CurrentTimeZone = objCompSysItem.CurrentTimeZone
        DaylightInEffect = objCompSysItem.DaylightInEffect
        TotalMemory = FormatNumber(objCompSysItem.TotalPhysicalMemory/1024^3, 2)
    Next
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Set variables gathered from Win32_TimeZone class:
 
    For Each objTZItem in colTZItems
        TZName = objTZItem.StandardName
    Next
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Set variables gathered from Win32_ComputerSystemProduct class:
 
    For Each objCompSysProdItem in colCompSysProdItems
        CompSysName = objCompSysProdItem.Name
        IdentifyingNumber = objCompSysProdItem.IdentifyingNumber
        UUID = objCompSysProdItem.UUID
    Next
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Set variables gathered from Win32_BIOS class:
 
    For Each objBIOSItem in colBIOSItems
        SMBIOSVersion = objBIOSItem.SMBIOSBIOSVersion
    Next
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Start echoing output to the screen
 
    Wscript.Echo "     ------------------------------------------"
    Wscript.Echo "                   System Details"
    Wscript.Echo "     ------------------------------------------"
    Wscript.Echo ""
    Wscript.Echo "     Computer Name:        " & CSName
    Wscript.Echo ""
    Wscript.Echo ""
    Wscript.Echo "     Operating System Information:"
    Wscript.Echo "     ============================="
    Wscript.Echo "     Operating System:     " & Caption & Arch
    Wscript.Echo "     Version:               " & Version & " " & Sku & " " & CSDVersion
    Wscript.Echo "     Build Type:            " & BuildType
    Wscript.Echo "     Locale:                " & Locale
    Wscript.Echo "     Serial Number:         " & SerialNumber
    Wscript.Echo ""
    Wscript.Echo "     Current Time Zone:     " & TZName
    Wscript.Echo "     Offset from UTC:       " & CurrentTimeZone/60 & " hours"
    Wscript.Echo "     DST In Effect:         " & DaylightInEffect
    Wscript.Echo ""
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Get the product keys (function at the end of script):
 
GetKeys()
 
    Wscript.Echo ""
    Wscript.Echo "     Install Date:          " & InstallDate
    Wscript.Echo "     Last Boot Time:        " & LastBootUpTime
    Wscript.Echo "     Local Date/Time:       " & Now()
    Wscript.Echo ""
    Wscript.Echo "     System Status:         " & Status
    Wscript.Echo ""
    Wscript.Echo ""
    Wscript.Echo "     Hardware Information:"
    Wscript.Echo "     ====================="
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Set and echo variables gathered from Win32_Processor class:
 
    For Each objProcItem in colProcItems
        Select Case objProcItem.Architecture
            Case 0 CPUArch = "x86"
            Case 1 CPUArch = "MIPS"
            Case 2 CPUArch = "Alpha"
            Case 3 CPUArch = "PowerPC"
            Case 6 CPUArch = "Itanium"
            Case 9 CPUArch = "x64"
            Case Else
            CPUArch = "Could Not Determine CPU Architecture"
        End Select
    Wscript.Echo "     CPU:                  " & objProcItem.Name & " (" & CPUArch & ")"
    Next
    Wscript.Echo ""
    Wscript.Echo "     Physical Memory:      " & TotalMemory & " GB"
    Wscript.Echo ""
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Set variables gathered from Win32_VideoController class:
 
    For Each objVideoItem in colVideoItems
        Wscript.Echo "     Video Card:           " & objVideoItem.Name
 
        If Not objVideoItem.AdapterDACType = "" Then
            Wscript.Echo "     Adapter DAC:           " & objVideoItem.AdapterDACType
        End if
 
        Wscript.Echo "     PNP Device ID:         " & objVideoItem.PNPDeviceID
 
        If Not objVideoItem.AdapterRAM = "" Then
            Wscript.Echo "     Video RAM:             " & objVideoItem.AdapterRAM/1024^2 & " MB"
        End If
 
        Wscript.Echo "     Driver Version:        " & objVideoItem.DriverVersion
 
        On Error Resume Next
        ScriptHelper.SWbemDateTime.Value = objVideoItem.DriverDate
            If Err.number <> 0 Then
                DriverDate = ""
                ' No DriverDate, do not echo
            Else
                DriverDate = ScriptHelper.SWbemDateTime.GetVarDate(False)
                Wscript.Echo "     Driver Date:           " & DriverDate
            End If
        On Error Goto 0
        Wscript.Echo ""
    Next
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Set variables gathered from Win32_SoundDevice class:
 
    For Each objSoundItem in colSoundItems
        Wscript.Echo "     Sound Card:           " & objSoundItem.Name
        Wscript.Echo "     Manufacturer:          " & objSoundItem.Manufacturer
        Wscript.Echo "     PNP Device ID:         " & objSoundItem.PNPDeviceID
        Wscript.Echo ""
    Next
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Set variables gathered from Win32_LogicalDisk class:
 
    For Each objDiskItem in colDiskItems
        If objDiskItem.DriveType = 3 Then
            Wscript.Echo "     Volume:               " & objDiskItem.Caption
            Wscript.Echo "     Compressed:            " & objDiskItem.Compressed
            Wscript.Echo "     File System:           " & objDiskItem.FileSystem
            Wscript.Echo "     Volume Size:           " & FormatNumber(objDiskItem.Size/1024^3, 2) & " GB"
            Wscript.Echo "     Free Space:            " & FormatNumber(objDiskItem.FreeSpace/1024^3, 2) & " GB"
            Wscript.Echo ""
        End If
    Next


 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Set variables gathered from Win32_NetworkAdapterConfiguration class:
 
    For Each objNetAdapConfigItem in colNetAdapConfigItems
        If isNull(objNetAdapConfigItem.IPAddress) Then
            '// Skip adapter, not currently used
        Else
            Wscript.Echo "     Network Adapter:      " & objNetAdapConfigItem.Description
            Wscript.Echo "     MAC Address:           " & objNetAdapConfigItem.MACAddress
            Wscript.Echo "     DHCP Enabled:          " & objNetAdapConfigItem.DHCPEnabled
            Wscript.Echo "     Local IP Address:            " & Join(objNetAdapConfigItem.IPAddress, ",")
            Wscript.Echo "     Subnet Mask:           " & Join(objNetAdapConfigItem.IPSubnet, ",")
            Wscript.Echo "     Default Gateway:       " & Join(objNetAdapConfigItem.DefaultIPGateway, ",")
            If objNetAdapConfigItem.DHCPEnabled = True Then
 
                ScriptHelper.SWbemDateTime.Value = objNetAdapConfigItem.DHCPLeaseObtained
                DHCPLeaseObtained = ScriptHelper.SWbemDateTime.GetVarDate(True)
                Wscript.Echo "     Lease Obtained:        " & DHCPLeaseObtained
 
                ScriptHelper.SWbemDateTime.Value = objNetAdapConfigItem.DHCPLeaseExpires
                DHCPLeaseExpires = ScriptHelper.SWbemDateTime.GetVarDate(True)
                Wscript.Echo "     Lease Exipres:         " & DHCPLeaseExpires
 
                Wscript.Echo "     DHCP Servers:          " & objNetAdapConfigItem.DHCPServer
            End If
         '//   Wscript.Echo "     DNS Server:            " & Join(objNetAdapConfigItem.DNSServerSearchOrder, ",")
            If Not objNetAdapConfigItem.WINSPrimaryServer = "" Then
                Wscript.Echo "     WINS Primary Server:   " & objNetAdapConfigItem.WINSPrimaryServer
                If Not objNetAdapConfigItem.WINSSecondaryServer = "" Then
                    Wscript.Echo "     WINS Secondary Server: " & objNetAdapConfigItem.WINSPrimaryServer
                End If
                Wscript.Echo "     Enable LMHosts Lookup: " & objNetAdapConfigItem.WINSEnableLMHostsLookup
            End If
            Wscript.Echo ""
        End If
    Next
    Wscript.Echo ""
    Wscript.Echo "     System Information:"
    Wscript.Echo "     ==================="
    Wscript.Echo "     Computer:             " & CompSysName
    Wscript.Echo "     Serial Number:         " & IdentifyingNumber
    Wscript.Echo "     BIOS Version:          " & SMBIOSVersion
    Wscript.Echo "     UUID:                  " & UUID
    Wscript.Echo ""
    Wscript.Echo ""
    Wscript.Echo "     Antivirus List:"
    Wscript.Echo "     ==================="
Set objWMIService = GetObject("winmgmts:\\.\root\SecurityCenter2")

Set colItems = objWMIService.ExecQuery("Select * From AntiVirusProduct")

For Each objItem in colItems
	WScript.Echo "     " & objItem.displayName
Next

'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// This pause call is disabled, but you may wish to enable it if running this script
'// with the ElevateThisScript() subroutine call enabled above:
 
' PressEnter()
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Functions: GetKeys() and decodeKey(iValues, strProduct)
'//
'// Credit where credit is due - I found and modified script posted by user "Parabellum"
'// found on http://www.visualbasicscript.com/m42793.aspx, hacked it up a bit, and used
'// it here to post keys:
 
Public Function GetKeys()
     
    For x = LBound(arrSubKeys, 1) To UBound(arrSubKeys, 1)
    ScriptHelper.Registry.GetBinaryValue HKEY_LOCAL_MACHINE, arrSubKeys(x,1), SEARCH_KEY, arrDPIDBytes
 
        If Not IsNull(arrDPIDBytes) Then
            Call decodeKey(arrDPIDBytes, arrSubKeys(x,0))
        Else
            ScriptHelper.Registry.EnumKey HKEY_LOCAL_MACHINE, arrSubKeys(x,1), arrGUIDKeys
 
            If Not IsNull(arrGUIDKeys) Then
                For Each GUIDKey In arrGUIDKeys
                    ScriptHelper.Registry.GetBinaryValue HKEY_LOCAL_MACHINE, arrSubKeys(x,1) & "\" & GUIDKey, SEARCH_KEY, arrDPIDBytes
         
                    If Not IsNull(arrDPIDBytes) Then
                        Call decodeKey(arrDPIDBytes, arrSubKeys(x,0))
                    End If
                Next
            End If
        End If
    Next
 
End Function
 
 
    Public Function decodeKey(iValues, strProduct)
 
        Dim arrDPID
        arrDPID = Array()
 
            For i = 52 to 66
                ReDim Preserve arrDPID( UBound(arrDPID) + 1 )
                arrDPID( UBound(arrDPID) ) = iValues(i)
            Next
 
        Dim arrChars
        arrChars = Array("B","C","D","F","G","H","J","K","M","P","Q","R","T","V","W","X","Y","2","3","4","6","7","8","9")
 
            For i = 24 To 0 Step -1
                k = 0
         
                For j = 14 To 0 Step -1
                    k = k * 256 Xor arrDPID(j)
                    arrDPID(j) = Int(k / 24)
                    k = k Mod 24
                Next
         
                strProductKey = arrChars(k) & strProductKey
         
                If i Mod 5 = 0 And i <> 0 Then
                    strProductKey = "-" & strProductKey
                End If
            Next
     
        ReDim Preserve foundKeys( UBound(foundKeys) + 1 )
        foundKeys( UBound(foundKeys) ) = strProductKey
        strKey = UBound(foundKeys)
        Wscript.Echo "     " & strProduct & "" & foundKeys(strKey)
    End Function
 
 
'//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// Subroutine: PressEnter()
'//
'// Adds a pause with a "Press the ENTER key to continue." message when called.
'//
'// Usage:  Call this Subroutine to get a pause that will clear when the user presses the
'// ENTER key (and ONLY the ENTER key) on their keyboard:
 
Sub PressEnter()
    Wscript.Echo ""
    strMessage = "Press the ENTER key to continue. "
   Wscript.StdOut.Write strMessage
 
   Do While Not WScript.StdIn.AtEndOfLine
       Input = WScript.StdIn.Read(1)
   Loop
End Sub
 
 
 
'// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'//
'// ScriptHelperClass and EnvironmentClass are helper classes to simplify
'// script work. Declare and use globally throughout the script.
'//
'//     Example code:
'//
'//     Option Explicit
'//     Dim ScriptHelper
'//     Set ScriptHelper = New ScriptHelperClass
'//     ScriptHelper.RunMeWithCScript()
'//     ScriptHelper.ElevateThisScript()
'//     WScript.Echo "User profile : " & ScriptHelper.Environment.UserProfile
'//     WScript.Echo "Domain : " & ScriptHelper.Network.UserDomain
'//     ScriptHelper.CreateFolder "\\SERVER\Share\Folder\With\Path"
'//     ScriptHelper.FileSystem.FileExists("C:\command.com")
'//     ScriptHelper.Shell.RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ProductOptions\ProductType")
'//
'// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Class ScriptHelperClass
 
        Private objEnvironment
        Private objFileSystem
        Private objNetwork
        Private objShell
        Private objSWBemlocator
        Private objWMI
        Private objRegistry
        Private objSWbemDateTime
 
        Public Computer
 
        Public Property Get Environment
            If objEnvironment Is Nothing Then
                Set objEnvironment = New EnvironmentClass
                objEnvironment.Shell = Shell
            End If
            Set Environment = objEnvironment
        End Property
 
        Public Property Get FileSystem
            If objFileSystem Is Nothing Then Set objFileSystem = CreateObject("Scripting.FileSystemObject")
            Set FileSystem = objFileSystem
        End Property
 
        Public Property Get Network
            If objNetwork Is Nothing Then Set objNetwork = CreateObject("WScript.Network")
            Set Network = objNetwork
        End Property
 
        Public Property Get Shell
            If objShell Is Nothing Then Set objShell = CreateObject("WScript.Shell")
            Set Shell = objShell
        End Property
 
        Public Property Get WMI
            If objWMI Is Nothing Then
                On Error Resume Next
                Set objSWBemlocator = CreateObject("WbemScripting.SWbemLocator")
                Set objWMI = objSWBemlocator.ConnectServer(Computer, "root\CIMV2")
                objWMI.Security_.ImpersonationLevel = 3
                On Error Goto 0
            End If
            Set WMI = objWMI
        End Property
 
        Public Property Get Registry
            If objRegistry Is Nothing Then Set objRegistry = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
            Set Registry = objRegistry
        End Property
 
        Public Property Get SWbemDateTime
            If objSWbemDateTime Is Nothing Then Set objSWbemDateTime = CreateObject("WbemScripting.SWbemDateTime")
            Set SWbemDateTime = objSWbemDateTime
        End Property
 
        Private Sub Class_Initialize()
            Computer = "."
            Set objEnvironment = Nothing
            Set objFileSystem = Nothing
            Set objNetwork = Nothing
            Set objShell = Nothing
            Set objSWBemlocator = Nothing
            Set objWMI = Nothing
            Set objRegistry = Nothing
            Set objSWbemDateTime = Nothing
        End Sub
 
        Private Sub Class_Terminate
            Set objSWbemDateTime = Nothing
            Set objRegistry = Nothing
            Set objWMI = Nothing
            Set objSWBemlocator = Nothing
            Set objShell = Nothing
            Set objNetwork = Nothing
            Set objFileSystem = Nothing
            Set objEnvironment = Nothing
        End Sub
 
        Public Property Get ScriptPath()
            ScriptPath = FileSystem.GetFile(WScript.ScriptFullName).ParentFolder
        End Property
 
        Public Function GetCurrentUserSID()
            Dim intCount, colItems, objItem, strSID
 
            Set colItems = WMI.ExecQuery("SELECT * FROM Win32_UserAccount WHERE Name = '" & Network.Username & "' AND Domain = '" & Network.UserDomain & "'", , 48)
                     
            intCount = 0
            For Each objItem In colItems
                strSID = Cstr(objItem.SID)
                intCount = intCount + 1
            Next
             
            If intCount > 0 Then
                GetCurrentUserSID = strSID
            Else
                GetCurrentUserSID = "NOTFOUND"
            End If
        End Function
 
        Public Sub CreateFolder(strFldPath)
            Dim fldArray, x, intStartIndex, blnUNC, strDestFold : strDestFold = ""
             
            If Left(strFldPath, 2) = "\\"  Then
                blnUNC = True
                intStartIndex = 3                                        'Start at the first folder in UNC path
            Else
                blnUNC = False
                intStartIndex = 0
            End If
             
            fldArray = Split(strFldPath, "\")                                                        'Split folders into array
             
            If fldArray(intStartIndex) = "" Then Exit Sub
             
            For x = intStartIndex To UBound(fldArray)
         
                If strDestFold = "" Then
                    If blnUNC Then
                        strDestFold = "\\" & fldArray(x-1) & "\" & fldArray(x)                    'Prefix UNC with server and share
                    Else
                        strDestFold = fldArray(x)                                                
                    End If
                Else
                    strDestFold = strDestFold & "\" & fldArray(x)                                'Append each folder to end of path
                End If
 
                If Not FileSystem.FolderExists(strDestFold) Then FileSystem.CreateFolder(strDestFold)
            Next
        End Sub
 
        Public Sub DeleteFolder(strFldPath)
            If FileSystem.FolderExists(strFldPath) Then FileSystem.DeleteFolder strFldPath, True
        End Sub
 
        '//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        '// Subroutine: RunMeWithCScript()    
        '//
        '// Purpose:    Forces the currently running script to use Cscript.exe as the Script
        '//             engine.  If the script is already running with cscript.exe the sub exits
        '//             and continues the script.
        '//
        '//             Sub Attempts to call the script with its original arguments.  Arguments
        '//             that contain a space will be wrapped in double quotes when the script
        '//             calls itself again.  To verify your command string you can echo out the
        '//             scriptCommand variable.
        '//
        '// Usage:      Add a call to this sub (RunMeWithCscript) to the beggining of your script
        '//             to ensure that cscript.exe is used as the script engine.
        '//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
        Public Sub RunMeWithCScript()
         
            Dim scriptEngine, engineFolder, Args, arg, scriptName, argString, scriptCommand
         
            scriptEngine = Ucase(Mid(Wscript.FullName,InstrRev(Wscript.FullName,"\")+1))
            engineFolder = Left(Wscript.FullName,InstrRev(Wscript.FullName,"\"))
            argString = ""
             
            If scriptEngine = "WSCRIPT.EXE" Then   
                Dim Shell : Set Shell = CreateObject("Wscript.Shell")
                Set Args = Wscript.Arguments
                 
                For each arg in Args                        'loop though argument array as a collection to rebuild argument string
                    If instr(arg," ") > 0 Then arg = """" & arg & """"    'if the argument contains a space wrap it in double quotes
                    argString = argString & " " & Arg
                Next
         
                'Create a persistent command prompt for the cscript output window and call the script with its original arguments    
                scriptCommand = "cmd.exe /k " & engineFolder & "cscript.exe """ & Wscript.ScriptFullName & """" & argString
         
                Shell.Run scriptCommand,,False
                Wscript.Quit
            Else
                Exit Sub                    'Already Running with Cscript Exit this Subroutine
            End If
         
         
        End Sub
         
        '//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        '// Subroutine: ElevateThisScript()    
        '//
        '// Purpose:    (Intended for Vista+)
        '//             Forces the currently running script to prompt for UAC elevation if it
        '//             detects that the current user credentials do not have administrative
        '//             privileges.
        '//
        '//             If run on Windows XP this script will cause the RunAs dialog to appear if
        '//             the user does not have administrative rights, giving the opportunity to
        '//             run as an administrator.
        '//
        '//             This Sub Attempts to call the script with its original arguments.
        '//             Arguments that contain a space will be wrapped in double quotes when the
        '//             script calls itself again.
        '//
        '// Usage:      Add a call to this sub (ElevateThisScript) to the beginning of your
        '//             script to ensure that the script gets an administrative token.
        '//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Public Sub ElevateThisScript()
             
            Const HKEY_CLASSES_ROOT  = &H80000000
            Const HKEY_CURRENT_USER  = &H80000001
            Const HKEY_LOCAL_MACHINE = &H80000002
            Const HKEY_USERS         = &H80000003
            const KEY_QUERY_VALUE      = 1
            Const KEY_SET_VALUE          = 2
         
            Dim scriptEngine, engineFolder, argString, arg, Args, scriptCommand, HasRequiredRegAccess
            Dim objShellApp : Set objShellApp = CreateObject("Shell.Application")
                 
             
            scriptEngine = Ucase(Mid(Wscript.FullName,InstrRev(Wscript.FullName,"\")+1))
            engineFolder = Left(Wscript.FullName,InstrRev(Wscript.FullName,"\"))
            argString = ""
             
            Set Args = Wscript.Arguments
             
            For each arg in Args                        'loop though argument array as a collection to rebuild argument string
                If instr(arg," ") > 0 Then arg = """" & arg & """"    'if the argument contains a space wrap it in double quotes
                argString = argString & " " & Arg
            Next
         
            scriptCommand = engineFolder & scriptEngine
                 
            Dim objReg, bHasAccessRight
            Set objReg=GetObject("winmgmts:"_
                & "{impersonationLevel=impersonate}!\\" &_
                Computer & "\root\default:StdRegProv")
             
         
            'Check for administrative registry access rights
            objReg.CheckAccess HKEY_LOCAL_MACHINE, "System\CurrentControlSet\Control\CrashControl", _
                KEY_SET_VALUE, bHasAccessRight
             
            If bHasAccessRight = True Then
             
                HasRequiredRegAccess = True
                Exit Sub
                 
            Else
                 
                HasRequiredRegAccess = False
                objShellApp.ShellExecute scriptCommand, " """ & Wscript.ScriptFullName & """" & argString, "", "runas"
                WScript.Quit
            End If
             
        End Sub
    End Class
     
    Class EnvironmentClass
        Private objShell
        Private strLogonServer
        Private strProgramFiles
        Private strProgramFilesX86
        Private strUserProfile
        Private strWinDir
         
        Public Cache
         
        Public Property Let Shell(objParentShell)
            Set objShell = objParentShell
        End Property
         
        Public Property Get LogonServer
            If IsNull(strLogonServer) Or Cache = False Then strLogonServer = objShell.ExpandEnvironmentStrings("%LOGONSERVER%")
            LogonServer = strLogonServer
        End Property
 
        Public Property Get ProgramFiles
            If IsNull(strProgramFiles) Or Cache = False Then strProgramFiles = objShell.ExpandEnvironmentStrings("%PROGRAMFILES%")
            ProgramFiles = strProgramFiles
        End Property
 
        Public Property Get ProgramFilesX86
            If IsNull(strProgramFilesX86) Or Cache = False Then strProgramFilesX86 = objShell.ExpandEnvironmentStrings("%PROGRAMFILES(x86)%")
            ProgramFilesX86 = strProgramFilesX86
        End Property
 
        Public Property Get UserProfile
            If IsNull(strUserProfile) Or Cache = False Then strUserProfile = objShell.ExpandEnvironmentStrings("%USERPROFILE%")
            UserProfile = strUserProfile
        End Property
 
        Public Property Get WinDir
            If IsNull(strWinDir) Or Cache = False Then strWinDir = objShell.ExpandEnvironmentStrings("%WINDIR%")
            WinDir = strWinDir
        End Property
 
        Private Sub Class_Initialize()
            Cache = True
            strLogonServer = Null
            strProgramFiles = Null
            strProgramFilesX86 = Null
            strUserProfile = Null
            strWinDir = Null
        End Sub
    End Class
