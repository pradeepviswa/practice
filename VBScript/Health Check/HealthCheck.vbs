'#######################################################################################################################
'We can set any name of this script file. Provided extension should be .VBS
'This script required an Input file named MachineList.txt, this should contain server/computer names or IP address.
'Script will follow the sequence of server name or IP mentioned in MachineList.txt
'Output of this script will be saved in a separate file named Info_Master.txt, this file will be autocreated.
'If Info_Master.txt is already present then existing data in this file will be removed and fresh information will be stored from script.
'Script File (.VBS), MachineList.text should be in same location.


'Script prepared by Pradeep
'#######################################################################################################################



Dim WSHShell
Dim objNTInfo
Dim GetComputerName

'Set objNTInfo = CreateObject("WinNTSystemInfo")
'GetComputerName = lcase(objNTInfo.ComputerName)

Set WSHShell = WScript.CreateObject("WScript.Shell")
strComputer = GetComputerName

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile("Info_Master.txt", True)
Set objFileTest = objFSO.CreateTextFile("Test.txt", True)




objFile.WriteLine "S No " & vbTAB & "Machine Name" & vbTAB & "Domain Name" & vbTAB & "Latency"  & vbTAB & "Model"_
		 & vbTAB & "Serial Number" & vbTAB & "CPU Name" & vbTAB & "MaxClockSpeed (MHz)" & vbTAB & "Physical Processor Count"_
		 & vbTAB & "Number of Core per CPU" & vbTAB & "Number of Logical Processors per CPU" & vbTAB & "Hyperthread"_
		 & vbTAB &  "Memory" & vbTAB & "OS Instal lDate" & vbTAB & "Uptime" & vbTAB & "Current Date Time" & vbTAB & "Operating System"_
		 & vbTAB &  "Service Pack Version" & vbTAB & "OS Build" & vbTAB & "OS Lang" & vbTAB & "DOT Net" & vbTAB & "WSUS Server"_
		 & vbTAB & "Last Patching Date" & vbTAB & "Reboot Req" & vbTAB & "Admin Group" & vbTAB & "RDP Status" & vbTAB & "Service Status"_
		 & vbTAB & "AV Date" & vbTAB & "AV Version" & vbTAB & "McAfee_ESP" & vbTAB & "McAfee_ETP"_
		 & vbTAB & "USB Disable" & vbTAB & "Interface Description" & vbTAB & "IP Address" & vbTAB & "MAC Address"_
		 & vbTAB & "McAfee Agent" & vbTAB & "AMCoreVersion" & vbTAB & "McAfee ESF" & vbTAB & "McAfee ESP" & vbTAB & "McAfee ESTP" & vbTAB & "McAfee Solidifier" & vbTAB & "Qualys Cloud Security Agent"_
		 & vbTAB & "Drive" & vbTAB & " Size " & vbTAB & "Free-Space"_
		 & vbTAB & "Drive" & vbTAB & " Size " & vbTAB & "Free-Space" 




'public variable declaration
'***************************
dim  MachineName
dim  DomainName
dim  Latency
dim  Model
dim  SerialNumber
dim  CPUName
dim  MaxClockSpeed
dim  ProcessorCount
dim  numberofCore
dim  NumberofLogicalProcessors
dim  Hyperthread
dim  OperatingSystem
dim  OSArchitecture
dim  ServicePackVersion
dim  OSLang
dim  OSBuild
dim  InterfaceDescription
dim  IPAddress
dim  MACAddress
dim  Memory
dim  OSInstallDate
dim  Uptime
dim  Currentdateandtime
'dim  DOTNet
dim  WSUSServer
dim  LastPatchingDate
dim  RebootReq
dim  Admingroup
dim  RDPStatus
dim  serviceStatus
dim  DiskSpace
dim  UsbDisable

dim  McAfee_Agent, McAfee_ESF, McAfee_ESP, McAfee_ETP, McAfee_Solidifier, Qualys_CSAgent



'initialize row number to insert values
intRow = 2
intErr = 0

'for registy value retrieval
const HKEY_LOCAL_MACHINE = &H80000002



Function getLang(OSLang)
	On Error Resume Next
	Select Case OSLang
		Case 1 getLang = "Arabic"
		Case 4 getLang = "Chinese (Simplified)– China"
		Case 9 getLang = "English"
		Case 1025 getLang = "Arabic – Saudi Arabia"
		Case 1026 getLang = "Bulgarian"
		Case 1027 getLang = "Catalan"
		Case 1028 getLang = "Chinese (Traditional) – Taiwan"
		Case 1029 getLang = "Czech"
		Case 1030 getLang = "Danish"
		Case 1031 getLang = "German – Germany"
		Case 1032 getLang = "Greek"
		Case 1033 getLang = "English – United States"
		Case 1034 getLang = "Spanish – Traditional Sort"
		Case 1035 getLang = "Finnish"
		Case 1036 getLang = "French – France"
		Case 1037 getLang = "Hebrew"
		Case 1038 getLang = "Hungarian"
		Case 1039 getLang = "Icelandic"
		Case 1040 getLang = "Italian – Italy"
		Case 1041 getLang = "Japanese"
		Case 1042 getLang = "Korean"
		Case 1043 getLang = "Dutch – Netherlands"
		Case 1044 getLang = "Norwegian – Bokmal"
		Case 1045 getLang = "Polish"
		Case 1046 getLang = "Portuguese – Brazil"
		Case 1047 getLang = "Rhaeto-Romanic"
		Case 1048 getLang = "Romanian"
		Case 1049 getLang = "Russian"
		Case 1050 getLang = "Croatian"
		Case 1051 getLang = "Slovak"
		Case 1052 getLang = "Albanian"
		Case 1053 getLang = "Swedish"
		Case 1054 getLang = "Thai"
		Case 1055 getLang = "Turkish"
		Case 1056 getLang = "Urdu"
		Case 1057 getLang = "Indonesian"
		Case 1058 getLang = "Ukrainian"
		Case 1059 getLang = "Belarusian"
		Case 1060 getLang = "Slovenian"
		Case 1061 getLang = "Estonian"
		Case 1062 getLang = "Latvian"
		Case 1063 getLang = "Lithuanian"
		Case 1065 getLang = "Persian"
		Case 1066 getLang = "Vietnamese"
		Case 1069 getLang = "Basque (Basque) – Basque"		
		Case 1070 getLang = "Serbian"
		Case 1071 getLang = "Macedonian (FYROM)"
		Case 1072 getLang = "Sutu"
		Case 1073 getLang = "Tsonga"
		Case 1074 getLang = "Tswana"
		Case 1076 getLang = "Xhosa"
		Case 1077 getLang = "Zulu"
		Case 1078 getLang = "Afrikaans"
		Case 1080 getLang = "Faeroese"
		Case 1081 getLang = "Hindi"
		Case 1082 getLang = "Maltese"
		Case 1084 getLang = "Scottish Gaelic (United Kingdom)"
		Case 1085 getLang = "Yiddish"
		Case 1086 getLang = "Malay – Malaysia"
		Case 2049 getLang = "Arabic – Iraq"
		Case 2052 getLang = "Chinese (Simplified) – PRC"
		Case 2055 getLang = "German – Switzerland"
		Case 2057 getLang = "English – United Kingdom"
		Case 2058 getLang = "Spanish – Mexico"
		Case 2060 getLang = "French – Belgium"
		Case 2064 getLang = "Italian – Switzerland"
		Case 2067 getLang = "Dutch – Belgium"
		Case 2068 getLang = "Norwegian – Nynorsk"
		Case 2070 getLang = "Portuguese – Portugal"
		Case 2072 getLang = "Romanian – Moldova"
		Case 2073 getLang = "Russian – Moldova"
		Case 2074 getLang = "Serbian – Latin"
		Case 2077 getLang = "Swedish – Finland"
		Case 3073 getLang = "Arabic – Egypt"
		Case 3076 getLang = "Chinese (Traditional) – Hong Kong SAR"
		Case 3079 getLang = "German – Austria"
		Case 3081 getLang = "English – Australia"
		Case 3082 getLang = "Spanish – International Sort"
		Case 3084 getLang = "French – Canada"
		Case 3098 getLang = "Serbian – Cyrillic"
		Case 4097 getLang = "Arabic – Libya"
		Case 4100 getLang = "Chinese (Simplified) – Singapore"
		Case 4103 getLang = "German – Luxembourg"
		Case 4105 getLang = "English – Canada"
		Case 4106 getLang = "Spanish – Guatemala"
		Case 4108 getLang = "French – Switzerland"
		Case 5121 getLang = "Arabic – Algeria"
		Case 5127 getLang = "German – Liechtenstein"
		Case 5129 getLang = "English – New Zealand"
		Case 5130 getLang = "Spanish – Costa Rica"
		Case 5132 getLang = "French – Luxembourg"
		Case 6145 getLang = "Arabic – Morocco"
		Case 6153 getLang = "English – Ireland"
		Case 6154 getLang = "Spanish – Panama"
		Case 7169 getLang = "Arabic – Tunisia"
		Case 7177 getLang = "English – South Africa"
		Case 7178 getLang = "Spanish – Dominican Republic"
		Case 8193 getLang = "Arabic – Oman"
		Case 8201 getLang = "English – Jamaica"
		Case 8202 getLang = "Spanish – Venezuela"
		Case 9217 getLang = "Arabic – Yemen"
		Case 9226 getLang = "Spanish – Colombia"
		Case 10241 getLang = "Arabic – Syria"
		Case 10249 getLang = "English – Belize"
		Case 10250 getLang = "Spanish – Peru"
		Case 11265 getLang = "Arabic – Jordan"
		Case 11273 getLang = "English – Trinidad"
		Case 11274 getLang = "Spanish – Argentina"
		Case 12289 getLang = "Arabic – Lebanon"
		Case 12298 getLang = "Spanish – Ecuador"
		Case 13313 getLang = "Arabic – Kuwait"
		Case 13322 getLang = "Spanish – Chile"
		Case 14337 getLang = "Arabic – U.A.E."
		Case 14346 getLang = "Spanish – Uruguay"
		Case 15361 getLang = "Arabic – Bahrain"
		Case 15370 getLang = "Spanish – Paraguay"
		Case 16385 getLang = "Arabic – Qatar"
		Case 16394 getLang = "Spanish – Bolivia"
		Case 17418 getLang = "Spanish – El Salvador"
		Case 18442 getLang = "Spanish – Honduras"
		Case 19466 getLang = "Spanish – Nicaragua"
		Case 20490 getLang = "Spanish – Puerto Rico"

		Case Else getLang  = "could not retrieve"

        End Select 
end Function



Set Fso = CreateObject("Scripting.FileSystemObject")
Set InputFile = fso.OpenTextFile("MachineList.Txt")

'loop start this will read Machinelist.txt file
'**********************************************
Do While Not (InputFile.atEndOfStream)
	strComputer = InputFile.ReadLine	'save computer name
	strComputer = Trim(strComputer)		'remove space if any
	Err.Clear
	On Error Resume Next

	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2") 	'create service object
	Set objWMIServiceGrp = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")	'created for admin group detail
 

	Select Case Err.Number
		Case 0
	
			set objComputerSystem = objWMIService.ExecQuery("SELECT * FROM Win32_ComputerSystem")
			set objBIOS = objWMIService.ExecQuery("SELECT * FROM Win32_BIOS") 
			set objCPU = objWMIService.ExecQuery("SELECT * FROM Win32_Processor") 
			set objOs = objWMIService.ExecQuery("Select * from Win32_OperatingSystem") 
			Set objIPConfigSet = objWMIService.ExecQuery("Select * from Win32_NetworkAdapterConfiguration WHERE IPEnabled = 'True'")
			set objLogicaldisk = objWMIService.ExecQuery("Select * from Win32_Logicaldisk") 
			Set objDisks = objWMIService.ExecQuery("Select * from Win32_LogicalDisk where drivetype <> 10")
			Set objProduct = objWMIService.ExecQuery("Select * from Win32_Product") 
			Set objSession = CreateObject("Microsoft.Update.Session",""& strComputer &"")	'to fetch windows update related information
			Set objSearcher = objSession.CreateUpdateSearcher   'to fetch windows update related information

			'OS related information
			'*******************************
			Set dtmInstallDate = CreateObject("WbemScripting.SWbemDateTime")
			For Each objItem in objOS 
				'OperatingSystem = objItem.Name & ", " & objItem.OSArchitecture
				OperatingSystem = objItem.Name 
				OSArchitecture = objItem.OSArchitecture

					if(InStr(OperatingSystem,"2000") or InStr(OperatingSystem,"2003")) then
						OperatingSystem = objItem.Name 
					else
						OperatingSystem = OperatingSystem & ", " & OSArchitecture 
					end if

				ServicePackVersion = objItem.ServicePackMajorVersion
				OSBuild = objItem.buildnumber
				dtmInstallDate.Value = objItem.InstallDate
				OSInstallDate = dtmInstallDate.GetVarDate
				dtmInstallDate.Value = objItem.LastBootUpTime
				Uptime = dtmInstallDate.GetVarDate
				Currentdateandtime = now()
				OSLang = objItem.OSLanguage
				OSLang = getLang(OSLang)
			Next



			For Each objItem in objComputerSystem 
				MachineName = objItem.Name
				ProcessorCount = objItem.NumberOfProcessors			'physical processor count
				DomainName = objItem.Domain
				Manufacturer = objItem.Manufacturer
				Model = Manufacturer  & " " & objItem.Model
				Memory = round(((objItem.totalphysicalmemory)/(1024*1024)),2)
			Next

			'get serial number
			'*****************
			For Each objItem in objBIOS
				SerialNumber = objItem.SerialNumber
			Next

			For Each objItem in objCPU 
				CPUName = objItem.Name & ", " & objItem.Caption
				numberofCore = objItem.NumberOfCores
				NumberofLogicalProcessors = objItem.NumberOfLogicalProcessors
				MaxClockSpeed = objItem.MaxClockSpeed
			Next
			'if cpu model belongs to x86 family then add "32 bit" with OperatingSystem
			if(InStr(CPUName,"x86 Family")) then
				OperatingSystem = OperatingSystem & ", 32 bit"
			end if
			'decide hyperthread on the basis of System model, ProcessorCount, numberofCore, and NumberofLogicalProcessors 
			if(InStr(Model,"VMware")) then
				Hyperthread = "Disabled"	' Hyperthread is No Applicable for VM Servers
				ProcessorCount = ""		'for vmware physical processor count is wrongly retrieved wmic ComputerSystem get NumberOfProcessors
				numberofCore = ""		'for vmware number of core count is wrongly retrieved wmic cpu get NumberOfCores
				NumberofLogicalProcessors = ""	'for vmware physical processor count is wrongly retrieved wmic cpu get NumberOfLogicalProcessors
			else
				Hyperthread = ""		'check Hyperthread status manually using SIW.exe
			end if 

			
			'get mac & IP address
			tmp1 = ""
			tmp2 = ""
			tmp3 = ""
			For Each objItem in objIPConfigSet
				'Wscript.Echo objItem.MACAddress
				'tmp1 = tmp1 & "" & objItem.IPAddress(i) & ", " & vbCrLf
				'tmp2 = tmp2 & "" & objItem.MACAddress & ", " & vbCrLf
				'tmp3 = tmp3 & "" & objItem.Description & ", " & vbCrLf

				tmp1 = tmp1 & "" & objItem.IPAddress(i) & ", "
				tmp2 = tmp2 & "" & objItem.MACAddress & ", "
				tmp3 = tmp3 & "" & objItem.Description & ", "
			Next
			IPAddress = mid(tmp1,1,len(tmp1)-2)
			MACAddress = mid(tmp2,1,len(tmp2)-2)
			InterfaceDescription = mid(tmp3,1,len(tmp3)-2)


			'get admin group members
			'***********************
			Dim strQuery, colItems, Path, strMembers
			strQuery = "select * from Win32_GroupUser where GroupComponent = " & chr(34) & "Win32_Group.Domain='" & MachineName & "',Name='Administrators'" & Chr(34)
			Set ColItems = objWMIServiceGrp.ExecQuery(strQuery)
			strMembers = ""
			For Each Path In ColItems
        			Dim strMemberName, NamesArray, strDomainName, DomainNameArray
        			NamesArray = Split(Path.PartComponent,",")
        			strMemberName = Replace(Replace(NamesArray(1),Chr(34),""),"Name=","")
        			DomainNameArray = Split(NamesArray(0),"=")
        			strDomainName = Replace(DomainNameArray(1),Chr(34),"")
        			'If strDomainName <> strComputer or strDomainName = strComputer Then
					strMemberName = strDomainName & "\" & strMemberName
					strMembers = strMembers & strMemberName & ", "
	        		'End If
			Next
			Admingroup = mid(strMembers,1,len(strMembers)-2)
			'msgbox(Admingroup )


			Set colHistory = objSearcher.QueryHistory(0, 1)

			For Each objEntry in colHistory
				LastPatchingDate = objEntry.date
			Next

			if (Trim(LastPatchingDate) = "") then
				LastPatchingDate = "Not yet patched"
			end if

			RebootReq="No"
			strKeyPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update"
			oReg.EnumKey HKEY_LOCAL_MACHINE, strKeyPath, arrSubKeys
			For Each subkey In arrSubKeys
				'Wscript.Echo subkey
				if (subkey = "RebootRequired") then
					RebootReq="Yes"
				exit for
				end if
			Next
			tmp = ""


			Set StdOut = WScript.StdOut
			Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
			strKeyPath = "SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
			oReg.EnumValues HKEY_LOCAL_MACHINE, strKeyPath, arrValueNames, arrValueTypes
 
			For i=0 To UBound(arrValueNames)
				if (arrValueNames(i)="WUServer") then 
					'StdOut.WriteLine "File Name: " & arrValueNames(i) & " -- " 	     
					oReg.GetStringValue HKEY_LOCAL_MACHINE,strKeyPath,_	
					arrValueNames(i),strValue
					'StdOut.WriteLine "Location: " & strValue
					'StdOut.WriteBlankLines(1)
					WSUSServer = strValue
				exit for
				else
					WSUSServer = "No WSUS Server"
				end if
			Next

			if Trim(WSUSServer)="" then
				WSUSServer = "No WSUS Server"
			end if

			strKeyPath = "SOFTWARE\Microsoft\NET Framework Setup\NDP"
			oReg.EnumKey HKEY_LOCAL_MACHINE, strKeyPath, arrSubKeys
			For Each subkey In arrSubKeys
				tmp = tmp & subkey & ", "
			Next
			DOTNet = mid(tmp,1,len(tmp)-2)
			tmp = ""

			Dim objShell, objExec, strCmd, strTemp 
			strCmd = "ping -n 1 " & strComputer 
			Set objShell = CreateObject("WScript.Shell") 
			Set objExec = objShell.Exec(strCmd) 
			strTemp = UCase(objExec.StdOut.ReadAll) 
			Latency = Trim(Mid(strTemp,InStr(strTemp,"TIME")+5,4))
			strTemp = ""

			RDPStatus = "Not checked"
			'returns 0 if port is listening
			'returns 1 if port is not listening
			'returns 2 if port is listening or filtered 
			Set WshShell = WScript.CreateObject("WScript.Shell")
			tmp_rdp = WshShell.Run("PortQry.exe -n " & strComputer & " -p tcp -e 3389 -q", 1, true)
			if(tmp_rdp=0) then 
				RDPStatus = "Telnet Sucess"
			elseif(tmp_rdp=1) then
				RDPStatus = "Telnet Failed"
			end if
			tmp_rdp=""

			'option explicit
			Dim colServices
			Dim Service
			dim objWMIService
			Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2") 
			Set colServices =objWMIService.ExecQuery("select * from Win32_Service")
			tmp = ""
			For each Service in colServices
				if (Service.StartMode = "Auto") and (Service.State = "Stopped") then
					tmp = tmp & Service.DisplayName & "(" & Service.Name & "), "
				end if
			Next
			serviceStatus = mid(tmp,1,len(tmp)-2)
			tmp=""


			'Symantec Check
			'****************
			McAfee_Agent = ""
			McAfee_ESF = chr(34) & ""
			McAfee_ESP = ""
			McAfee_ETP = ""
                        UsbDisable=""

			Set objReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv") 
			'objReg.GetREG_BINARYValue HKEY_LOCAL_MACHINE, "SOFTWARE\Symantec\Symantec Endpoint Protection\AV", "PatternFileDate", McAfee_Agent
			objReg.GetStringValue HKEY_LOCAL_MACHINE,"SOFTWARE\Symantec\Symantec Endpoint Protection\CurrentVersion\SharedDefs", "DEFWATCH_10", McAfee_Agent
McAfee_Agent=Right(McAfee_Agent,12)
McAfee_Agent=Left(McAfee_Agent,8)

			objReg.GetDWORDValue HKEY_LOCAL_MACHINE, "SOFTWARE\Symantec\Symantec Endpoint Protection\AV", "PatternFileRevision", McAfee_ESF
			objReg.GetStringValue HKEY_LOCAL_MACHINE, "SOFTWARE\Symantec\Symantec Endpoint Protection\SMC\SYLINK\SyLink", "PreferredGroup", McAfee_ESP
			objReg.GetStringValue HKEY_LOCAL_MACHINE, "SOFTWARE\Symantec\Symantec Endpoint Protection\SMC\SYLINK\SyLink", "PreferredMode", McAfee_ETP
                        objReg.GetDWORDValue HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\USBSTOR", "Start", UsbDisable


			'Disk Detail
			'***************
			diskDetail = ""
			For each objDisk in objDisks
				percentfree = (objDisk.Freespace / objDisk.Size) * 100
				With objDisk
					'objExcel.Cells(1, x).Value = "Drive Letter"
					diskDetail = diskDetail & vbTAB & objDisk.DeviceId
		
					'objExcel.Cells(1, x).Value = "Total Space (GB)"
					diskDetail = diskDetail & vbTAB & round(objDisk.Size/(1024*1024*1024),2)

					'objExcel.Cells(1, x).Value = "Free Space (GB)"
					diskDetail = diskDetail & vbTAB & round(objDisk.Freespace/(1024*1024*1024),2)
						
					'msgbox(diskDetail )
				End With 
			Next


if UsbDisable=4 then
UsbDisable="Yes" 
else
UsbDisable="No" 
end if

if McAfee_ETP=1 then
McAfee_ETP="Yes" 
else
McAfee_ETP="No" 
end if

McAfeeAgent = ""
AMCoreVersion = ""
McAfeeESF = ""
McAfeeESP = ""
McAfeeESTP = ""
McAfeeSolidifier = ""
QualysCloudSecurityAgent = ""
			Set StdOut = WScript.StdOut
			Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
			objReg.GetDWORDValue HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\QualysAgent", "DisplayName", DisplayName
			objReg.GetDWORDValue HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\QualysAgent", "DisplayVersion", DisplayVersion
			if DisplayName <> "" then
				QualysCloudSecurityAgent = DisplayName & "("& DisplayVersion &")"
			end if
			

			Set StdOut = WScript.StdOut
			Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
			objReg.GetDWORDValue HKEY_LOCAL_MACHINE, "SOFTWARE\McAfee\AVSolution\DS\DS", "DisplayName", dwContentMajorVersion
			objReg.GetDWORDValue HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\QualysAgent", "DisplayVersion", dwContentMinorVersion
			if dwContentMajorVersion <> "" then
				AMCoreVersion = dwContentMajorVersion & "."& dwContentMinorVersion
			end if
			

	' List All Installed Software
	Const HKLM = &H80000002 'HKEY_LOCAL_MACHINE
	strComputer = "."
	strKey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"
	strEntry1a = "DisplayName"
	strEntry1b = "QuietDisplayName"
	strEntry2 = "InstallDate"
	strEntry3 = "VersionMajor"
	strEntry4 = "VersionMinor"
	strEntry5 = "EstimatedSize"

	Set objReg = GetObject("winmgmts://" & strComputer & _
	 "/root/default:StdRegProv")
	objReg.EnumKey HKLM, strKey, arrSubkeys
	
	For Each strSubkey In arrSubkeys
	  intRet1 = objReg.GetStringValue(HKLM, strKey & strSubkey, _
	   strEntry1a, strValue1)
	  If intRet1 <> 0 Then
		objReg.GetStringValue HKLM, strKey & strSubkey, _
		 strEntry1b, strValue1
	  End If
	  If strValue1 <> "" Then
		if strValue1 = "McAfee Agent" then
		  objReg.GetDWORDValue HKLM, strKey & strSubkey, _
		   strEntry3, intValue3
		  objReg.GetDWORDValue HKLM, strKey & strSubkey, _
		   strEntry4, intValue4		
			McAfeeAgent = "Display Name: " & strValue1 & " (" & intValue3 & "." & intValue4 &")"
		end if
		if strValue1 = "McAfee Endpoint Security Firewall" then
		  objReg.GetDWORDValue HKLM, strKey & strSubkey, _
		   strEntry3, intValue3
		  objReg.GetDWORDValue HKLM, strKey & strSubkey, _
		   strEntry4, intValue4		
			McAfeeESF = "Display Name: " & strValue1 & " (" & intValue3 & "." & intValue4 &")"
		end if
		if strValue1 = "McAfee Endpoint Security Platform" then
		  objReg.GetDWORDValue HKLM, strKey & strSubkey, _
		   strEntry3, intValue3
		  objReg.GetDWORDValue HKLM, strKey & strSubkey, _
		   strEntry4, intValue4		
			McAfeeESP = "Display Name: " & strValue1 & " (" & intValue3 & "." & intValue4 &")"
		end if
		if strValue1 = "McAfee Endpoint Security Threat Prevention" then
		  objReg.GetDWORDValue HKLM, strKey & strSubkey, _
		   strEntry3, intValue3
		  objReg.GetDWORDValue HKLM, strKey & strSubkey, _
		   strEntry4, intValue4		
			McAfeeESTP = "Display Name: " & strValue1 & " (" & intValue3 & "." & intValue4 &")"
		end if
		if strValue1 = "McAfee Solidifier" then
		  objReg.GetDWORDValue HKLM, strKey & strSubkey, _
		   strEntry3, intValue3
		  objReg.GetDWORDValue HKLM, strKey & strSubkey, _
		   strEntry4, intValue4		
			McAfeeSolidifier = "Display Name: " & strValue1 & " (" & intValue3 & "." & intValue4 &")"
		end if
	  End If
	  
	Next
			

objFile.WriteLine ""& intRow-1 & vbTAB &  MachineName & vbTAB & DomainName & vbTAB & Latency& vbTAB & Model & vbTAB & SerialNumber _
		 & vbTAB & CPUName & vbTAB & MaxClockSpeed & vbTAB & ProcessorCount & vbTAB & numberofCore & vbTAB & NumberofLogicalProcessors _
		 & vbTAB & Hyperthread & vbTAB & Memory & vbTAB & OSInstallDate & vbTAB & Uptime & vbTAB & Currentdateandtime & vbTAB & OperatingSystem _
		 & vbTAB &  ServicePackVersion & vbTAB & OSBuild & vbTAB & OSLang & vbTAB & DOTNet & vbTAB & WSUSServer & vbTAB & LastPatchingDate _
		 & vbTAB & RebootReq & vbTAB & Admingroup & vbTAB & RDPStatus & vbTAB & serviceStatus _
		 & vbTAB & McAfee_Agent & vbTAB & McAfee_ESF & vbTAB & McAfee_ESP & vbTAB & McAfee_ETP _
		 & vbTAB & UsbDisable & vbTAB & InterfaceDescription & vbTAB & IPAddress  & vbTAB & MACAddress _
		 & vbTAB & McAfeeAgent & vbTAB & AMCoreVersion & vbTAB & McAfeeESF & vbTAB & McAfeeESP & vbTAB & McAfeeESTP & vbTAB & McAfeeSolidifier & vbTAB & QualysCloudSecurityAgent _
		 & diskDetail &""



  Case 70

 	objFile.WriteLine intRow-1 & vbTAB & strComputer & vbTAB & "Run-time error '70': Permission denied"
	intErr = intErr + 1

  Case 462

 	objFile.WriteLine intRow-1 & vbTAB & strComputer & vbTAB & "The remote server machine does not exist or is unavailable"
	intErr = intErr + 1

  Case -2147217375

 	objFile.WriteLine intRow-1 & vbTAB & strComputer & vbTAB & "Unknown/undocumented runtime error (till this time), Error no. - " & CStr(Err.Number)
	intErr = intErr + 1

  Case Else

 	objFile.WriteLine intRow-1 & vbTAB & strComputer & vbTAB & "Unhandled Run-time error (till this time), description - " & Err.Description
	intErr = intErr + 1

End Select
Err.Clear
On Error GoTo 0

	

intRow = intRow + 1


Loop

Set colItems = Nothing
Set objWMIService = Nothing

msgbox("Servers checked = " & intRow-2 & vbnewline & "Error = " & intErr & vbnewline & "Success = " & intRow-2-intErr)

WScript.Quit(1)
