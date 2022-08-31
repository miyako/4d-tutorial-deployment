Class constructor
	
	This:C1470.applicationName:=cs:C1710.App.new().getName()
	
	This:C1470.RuntimeVLIconMacPath:=Get 4D folder:C485(Current resources folder:K5:16)+"SAMPLE.icns"
	This:C1470.ServerIconMacPath:=Get 4D folder:C485(Current resources folder:K5:16)+"SAMPLE.icns"
	This:C1470.ClientMacIconForMacPath:=Get 4D folder:C485(Current resources folder:K5:16)+"SAMPLE.icns"
	
	This:C1470.username:="keisuke.miyako@4d.com"
	This:C1470.password:="@keychain:altool"
	This:C1470.certificateName:="Developer ID Application: keisuke miyako (Y69CWUC25B)"
	This:C1470.keychainProfile:="notarytool"
	This:C1470.applicationsFolder:=Folder:C1567(fk applications folder:K87:20)
	This:C1470.resourcesFolder:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16); fk platform path:K87:2)
	
	This:C1470.version:=Application version:C493($build)
	If (Substring:C12(This:C1470.version; 3; 1)="0")
		This:C1470.folderName:="4D v"+Substring:C12(This:C1470.version; 1; 2)+"."+Substring:C12(This:C1470.version; 4; 1)
	Else 
		This:C1470.folderName:="4D v"+Substring:C12(This:C1470.version; 1; 2)+" R"+Substring:C12(This:C1470.version; 3; 1)
	End if 
	
	$releaseFolder:=Folder:C1567(Get 4D folder:C485(Database folder:K5:14); fk platform path:K87:2).parent.folder("Releases")
	$releaseFolder.create()
	
	This:C1470.releaseFolder:=$releaseFolder
	
Function _getCredentials()->$credentials : Object
	
	$credentials:=New object:C1471
	$credentials.username:=This:C1470.username
	$credentials.password:=This:C1470.password
	$credentials.keychainProfile:=This:C1470.keychainProfile
	
Function buildDesktop()->$that : cs:C1710.Build
	
	$that:=This:C1470
	
	$version:=This:C1470.version
	This:C1470.folderName:=This:C1470.folderName
	
	This:C1470.versionString:=cs:C1710.Version.new().getString()
	
	$buildApp:=BuildApp(New object:C1471)
	
	$buildApp.findLicenses(New collection:C1472("4DOE"; "4UOE"))
	
	$buildApp.settings.BuildApplicationName:=This:C1470.applicationName
	$buildApp.settings.BuildApplicationSerialized:=True:C214
	$buildApp.settings.BuildMacDestFolder:=This:C1470.releaseFolder.folder(This:C1470.versionString).platformPath
	$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLIncludeIt:=True:C214
	$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLMacFolder:=This:C1470.applicationsFolder.folder(This:C1470.folderName).folder("4D Volume Desktop.app").platformPath
	$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLIconMacPath:=This:C1470.RuntimeVLIconMacPath
	$buildApp.settings.SourcesFiles.RuntimeVL.IsOEM:=True:C214
	$buildApp.settings.SignApplication.MacSignature:=False:C215
	$buildApp.settings.SignApplication.AdHocSign:=False:C215
	
	$status:=$buildApp.build()
	
	If ($status.success)
		
		$status:=This:C1470._signApp($buildApp; "jp.dgw.desktop"; "Final Application"; $buildApp.settings.BuildApplicationName; False:C215)
		
	End if 
	
Function _escape_param($escape_param : Text)->$param : Text
	
	$param:=$escape_param
	
	$metacharacters:="\\!\"#$%&'()=~|<>?;*`[] "
	C_LONGINT:C283($i)
	For ($i; 1; Length:C16($metacharacters))
		$metacharacter:=Substring:C12($metacharacters; $i; 1)
		$param:=Replace string:C233($param; $metacharacter; "\\"+$metacharacter; *)
	End for 
	
Function _makeUpdaterDaemon($app : 4D:C1709.Folder)
	
	$plist:=$app.folder("Contents").folder("Resources").folder("Updater").folder("Updater.app").folder("Contents").file("Info.plist")
	
	If ($plist.exists)
		
		$dom:=DOM Parse XML source:C719($plist.platformPath)
		
		If (OK=1)
			
			$key:=DOM Find XML element:C864($dom; "/plist/dict/key[text()='LSUIElement']")
			
			If (OK=1)
				$value:=DOM Get next sibling XML element:C724($key)
				If (OK=1)
					DOM REMOVE XML ELEMENT:C869($value)
				End if 
				DOM REMOVE XML ELEMENT:C869($key)
			End if 
			
			$key:=DOM Create XML element:C865($dom; "/plist/dict/key")
			DOM SET XML ELEMENT VALUE:C868($key; "LSUIElement")
			$value:=DOM Create XML element:C865($dom; "/plist/dict/true")
			
			$key:=DOM Find XML element:C864($dom; "/plist/dict/key[text()='LSBackgroundOnly']")
			
			If (OK=1)
				$value:=DOM Get next sibling XML element:C724($key)
				If (OK=1)
					DOM REMOVE XML ELEMENT:C869($value)
				End if 
				DOM REMOVE XML ELEMENT:C869($key)
			End if 
			
			$key:=DOM Create XML element:C865($dom; "/plist/dict/key")
			DOM SET XML ELEMENT VALUE:C868($key; "LSBackgroundOnly")
			$value:=DOM Create XML element:C865($dom; "/plist/dict/true")
			
			DOM EXPORT TO FILE:C862($dom; $plist.platformPath)
			
			If (OK=1)
				
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $plist.parent.platformPath)
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "true")
				
				$command:="plutil -convert xml1 "+This:C1470._escape_param($plist.fullName)
				
				var $stdIn; $stdOut; $stdErr : Blob
				
				LAUNCH EXTERNAL PROCESS:C811($command; $stdIn; $stdOut; $stdErr; $pid)
				
			End if 
			
			DOM CLOSE XML:C722($dom)
			
		End if 
		
	End if 
	
Function _signApp($buildApp : Object; $identifier : Text; $folderName : Text; $appName : Text; $useOldTool : Boolean)->$status : Object
	
	$app:=$buildApp.getPlatformDestinationFolder().folder($folderName).folder($appName+".app")
	
	This:C1470._makeUpdaterDaemon($app)
	
	$status:=New object:C1471("app"; $app)
	
	$plist:=New object:C1471("CFBundleShortVersionString"; This:C1470.versionString; "CFBundleIdentifier"; $identifier)
	
	$credentials:=This:C1470._getCredentials()
	
	$signApp:=SignApp($credentials; $plist)
	
	$status.sign:=$signApp.sign($app)
	
	$status.archive:=$signApp.archive($app)
	
	If ($status.archive.success)
		$status.notarize:=$signApp.notarize($status.archive.file; $useOldTool)
		If ($status.notarize.success)
			$dmg:=$signApp.destination.folder($signApp.versionID).file($appName+".dmg")
			$ftp:=cs:C1710.FTP.new()
			$status.ftp:=$ftp.upload(This:C1470.versionString; $dmg)
		End if 
	End if 
	
Function buildAutoUpdateClientServer()->$that : cs:C1710.Build
	
	$that:=This:C1470
	
	This:C1470._prepareClientRuntime()
	
	$version:=This:C1470.version
	This:C1470.folderName:=This:C1470.folderName
	
	This:C1470.versionString:=cs:C1710.Version.new().updatePatch().getString()
	
	$buildApp:=BuildApp(New object:C1471)
	
	$buildApp.findLicenses(New collection:C1472("4DOE"; "4UOS"; "4DOM"))
	
	$buildApp.settings.BuildApplicationName:=This:C1470.applicationName
	$buildApp.settings.BuildMacDestFolder:=This:C1470.releaseFolder.folder(This:C1470.versionString).platformPath
	$buildApp.settings.SourcesFiles.CS.ServerIncludeIt:=True:C214
	$buildApp.settings.SourcesFiles.CS.ClientMacIncludeIt:=True:C214
	$buildApp.settings.SourcesFiles.CS.ServerMacFolder:=This:C1470.applicationsFolder.folder(This:C1470.folderName).folder("4D Server.app").platformPath
	$buildApp.settings.SourcesFiles.CS.ClientMacFolderToMac:=This:C1470.applicationsFolder.folder(This:C1470.folderName).folder("4D Volume Desktop.app").platformPath
	$buildApp.settings.SourcesFiles.CS.ServerIconMacPath:=This:C1470.ServerIconMacPath
	$buildApp.settings.SourcesFiles.CS.ClientMacIconForMacPath:=This:C1470.ClientMacIconForMacPath
	$buildApp.settings.SourcesFiles.CS.IsOEM:=True:C214
	$buildApp.settings.CS.BuildServerApplication:=True:C214
	$buildApp.settings.CS.BuildCSUpgradeable:=True:C214
	$buildApp.settings.CS.CurrentVers:=2
	$buildApp.settings.CS.RangeVersMin:=2
	$buildApp.settings.CS.RangeVersMax:=9
	$buildApp.settings.CS.LastDataPathLookup:="ByAppName"
	$buildApp.settings.SignApplication.MacSignature:=True:C214
	$buildApp.settings.SignApplication.MacCertificate:=This:C1470.certificateName
	$buildApp.settings.SignApplication.AdHocSign:=False:C215
	
	$status:=$buildApp.build()
	
	If ($status.success)
		
		$logsFolder:=Folder:C1567(fk logs folder:K87:17)
		$name:=$buildApp.lastSettingsFile.name
		$file:=$logsFolder.file($name+".log.xml")
		$dom:=DOM Parse XML source:C719($file.platformPath)
		$error:=DOM Find XML element:C864($dom; "/BuildApplicationLog/Log[CodeDesc = \"NO_LICENSE_OEMMAKER\"]")
		If (OK=1)
			TRACE:C157
		End if 
		DOM CLOSE XML:C722($dom)
		
		//あらためて署名する
		$status:=This:C1470._signApp($buildApp; "jp.dgw.server"; "Client Server executable"; $buildApp.settings.BuildApplicationName+" Server"; False:C215)
		$status:=This:C1470._signApp($buildApp; "jp.dgw.client"; "Client Server executable"; $buildApp.settings.BuildApplicationName+" Client"; False:C215)
		
		This:C1470.releaseFolder.folder(This:C1470.versionString).delete(Delete with contents:K24:24)
		
	End if 
	
Function buildServer()->$that : cs:C1710.Build
	
	$that:=This:C1470
	
	$version:=This:C1470.version
	This:C1470.folderName:=This:C1470.folderName
	
	This:C1470.versionString:=cs:C1710.Version.new().updatePatch().getString()
	
	$buildApp:=BuildApp(New object:C1471)
	
	$buildApp.findLicenses(New collection:C1472("4DOE"; "4UOS"; "4DOM"))
	
	$buildApp.settings.BuildApplicationName:="Doctor’s Good Will"
	$buildApp.settings.BuildMacDestFolder:=This:C1470.releaseFolder.folder(This:C1470.versionString).platformPath
	$buildApp.settings.SourcesFiles.CS.ServerIncludeIt:=True:C214
	$buildApp.settings.SourcesFiles.CS.ClientMacIncludeIt:=False:C215
	$buildApp.settings.SourcesFiles.CS.ServerMacFolder:=This:C1470.applicationsFolder.folder(This:C1470.folderName).folder("4D Server.app").platformPath
	$buildApp.settings.SourcesFiles.CS.ClientMacFolderToMac:=This:C1470.applicationsFolder.folder(This:C1470.folderName).folder("4D Volume Desktop.app").platformPath
	$buildApp.settings.SourcesFiles.CS.ServerIconMacPath:=This:C1470.ServerIconMacPath
	$buildApp.settings.SourcesFiles.CS.ClientMacIconForMacPath:=This:C1470.ClientMacIconForMacPath
	$buildApp.settings.SourcesFiles.CS.IsOEM:=True:C214
	$buildApp.settings.CS.BuildServerApplication:=True:C214
	$buildApp.settings.CS.LastDataPathLookup:="ByAppName"
	$buildApp.settings.SignApplication.MacSignature:=False:C215
	$buildApp.settings.SignApplication.AdHocSign:=False:C215
	
	$status:=$buildApp.build()
	
	If ($status.success)
		
		$logsFolder:=Folder:C1567(fk logs folder:K87:17)
		$name:=$buildApp.lastSettingsFile.name
		$file:=$logsFolder.file($name+".log.xml")
		$dom:=DOM Parse XML source:C719($file.platformPath)
		$error:=DOM Find XML element:C864($dom; "/BuildApplicationLog/Log[CodeDesc = \"NO_LICENSE_OEMMAKER\"]")
		If (OK=1)
			TRACE:C157
		End if 
		DOM CLOSE XML:C722($dom)
		
		$app:=$buildApp.getPlatformDestinationFolder().folder("Client Server executable").folder($buildApp.settings.BuildApplicationName+" Server"+".app")
		
		$clientFolder:=$app.folder("Contents").folder("Upgrade4DClient")
		$clientFolder.create()
		$dmg.moveTo($clientFolder)
		
		$status:=This:C1470._signApp($buildApp; "jp.dgw.server"; "Client Server executable"; $buildApp.settings.BuildApplicationName+" Server"; False:C215)
		
	End if 
	
Function _prepareClientRuntime()->$that : cs:C1710.Build
	
/*
	
追加のentitlementsがあるのでさきに署名する
ただし4D Volume Desktopのバージョンは書き換えない
	
*/
	
	$that:=This:C1470
	
	$version:=This:C1470.version
	This:C1470.folderName:=This:C1470.folderName
	
	This:C1470.versionString:=cs:C1710.Version.new().getString()
	
	$buildApp:=BuildApp(New object:C1471)
	
	$app:=This:C1470.applicationsFolder.folder(This:C1470.folderName).folder("4D Volume Desktop.app")
	
	$identifier:="jp.dgw.client"
	
	$plist:=New object:C1471("CFBundleIdentifier"; $identifier)
	
	$credentials:=This:C1470._getCredentials()
	
	$signApp:=SignApp($credentials; $plist)
	
	$status:=$signApp.sign($app)
	