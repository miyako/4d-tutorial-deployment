Class constructor
	
	This:C1470.major:=0
	This:C1470.minor:=0
	This:C1470.patch:=0
	
	If (Version type:C495 ?? Merged application:K5:28)
		
		$version:=This:C1470._getVersion()
		
		var $major; $minor; $patch : Integer
		
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		
		If (Match regex:C1019("(\\d+)\\.(\\d+)\\.(\\d+)"; $version; 1; $pos; $len))
			This:C1470.major:=Num:C11(Substring:C12($version; $pos{1}; $len{1}))
			This:C1470.minor:=Num:C11(Substring:C12($version; $pos{2}; $len{2}))
			This:C1470.patch:=Num:C11(Substring:C12($version; $pos{3}; $len{3}))
		End if 
		
	Else 
		This:C1470._getManifest()
	End if 
	
Function _getVersion()->$version : Text
	
	var $plistFile : 4D:C1709.File
	
	$plistFile:=Folder:C1567(Application file:C491; fk platform path:K87:2).folder("Contents").file("Info.plist")
	
	If ($plistFile.exists)
		$dom:=DOM Parse XML source:C719($plistFile.platformPath)
		If (OK=1)
			$domKey:=DOM Find XML element:C864($dom; "//key[text()='CFBundleShortVersionString']")
			If (OK=1)
				var $stringValue : Text
				DOM GET XML ELEMENT VALUE:C731(DOM Get next sibling XML element:C724($domKey); $stringValue)
				$version:=$stringValue
			End if 
		End if 
	End if 
	
Function _versionFile()->$file : 4D:C1709.File
	
	//to avoid cache
	
	$file:=Folder:C1567(fk resources folder:K87:11).file("manifest.json")
	
	$file:=File:C1566($file.platformPath; fk platform path:K87:2)
	
Function _getManifest()->$this : cs:C1710.Version
	
	$this:=This:C1470
	
	$versionFile:=This:C1470._versionFile()
	
	If ($versionFile.exists)
		$manifest:=JSON Parse:C1218($versionFile.getText(); Is object:K8:27)
		If (Not:C34(OB Is empty:C1297($manifest)))
			If ($manifest.major#Null:C1517)
				This:C1470.major:=Num:C11($manifest.major)
			End if 
			If ($manifest.minor#Null:C1517)
				This:C1470.minor:=Num:C11($manifest.minor)
			End if 
			If ($manifest.patch#Null:C1517)
				This:C1470.patch:=Num:C11($manifest.patch)
			End if 
		End if 
	End if 
	
Function _setManifest()->$this : cs:C1710.Version
	
	$this:=This:C1470
	
	var $manifest : Object
	
	$manifest:=New object:C1471("major"; This:C1470.major; "minor"; This:C1470.minor; "patch"; This:C1470.patch)
	
	$versionFile:=This:C1470._versionFile()
	
	$versionFile.setText(JSON Stringify:C1217($manifest; *))
	
Function updateMajor()->$this : cs:C1710.Version
	
	$this:=This:C1470
	
	This:C1470.major:=This:C1470.major+1
	This:C1470.minor:=0
	This:C1470.patch:=0
	This:C1470._setManifest()
	
Function updateMinor()->$this : cs:C1710.Version
	
	$this:=This:C1470
	
	This:C1470.minor:=This:C1470.minor+1
	This:C1470.patch:=0
	This:C1470._setManifest()
	
Function updatePatch()->$this : cs:C1710.Version
	
	$this:=This:C1470
	
	This:C1470.patch:=This:C1470.patch+1
	This:C1470._setManifest()
	
Function setVersion($version : Text)->$this : cs:C1710.Version
	
	$this:=This:C1470
	
	var $major; $minor; $patch : Integer
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019("(\\d+)\\.(\\d+)\\.(\\d+)"; $version; 1; $pos; $len))
		This:C1470.major:=Num:C11(Substring:C12($version; $pos{1}; $len{1}))
		This:C1470.minor:=Num:C11(Substring:C12($version; $pos{2}; $len{2}))
		This:C1470.patch:=Num:C11(Substring:C12($version; $pos{3}; $len{3}))
		This:C1470._setManifest()
	End if 
	
Function getResourceString()->$version : Text
	
	$version:=New collection:C1472(This:C1470.major; This:C1470.minor; This:C1470.patch).join(".")
	
Function getString()->$version : Text
	
	If (Version type:C495 ?? Merged application:K5:28)
		$version:=This:C1470._getVersion()
	Else 
		$version:=This:C1470.getResourceString()
	End if 