Class constructor
	
	This:C1470.shouldRestart:=False:C215
	
	This:C1470.components:=New collection:C1472("builder"; "execute")
	
	This:C1470.projectFolder:=Folder:C1567(Get 4D folder:C485(Database folder:K5:14); fk platform path:K87:2)
	This:C1470.componentsFolder:=This:C1470.projectFolder.folder("Components")
	This:C1470.builtComponentsFolder:=This:C1470.projectFolder.folder("Components - Releases").folder("Components")
	
Function switchDataIfNecessary()->$this : cs:C1710.Startup
	
	$app:=cs:C1710.App.new()
	
	$name:=$app.getName()
	
	This:C1470.defaultDataFolder:=Folder:C1567(fk database folder:K87:14).folder("Default Data")
	This:C1470.defaultDataFile:=This:C1470.defaultDataFolder.file("default.4DD")
	This:C1470.defaultDataSettingsFolder:=This:C1470.defaultDataFolder.folder("Settings")
	
	This:C1470.deploymentDataFolder:=Folder:C1567(fk user preferences folder:K87:10).parent.folder($name).folder("Data")
	This:C1470.deploymentDataFile:=This:C1470.deploymentDataFolder.file("data.4DD")
	
	$this:=This:C1470
	
	If (This:C1470._shouldSwitchDataFile())
		If (This:C1470.deploymentDataFile.exists)
			OPEN DATA FILE:C312(This:C1470.deploymentDataFile.platformPath)
		Else 
			If (This:C1470.defaultDataSettingsFolder.exists)
				This:C1470.deploymentDataFolder.create()
				If (Not:C34(This:C1470.deploymentDataFolder.folder(This:C1470.defaultDataSettingsFolder.fullName).exists))
					This:C1470.defaultDataSettingsFolder.copyTo(This:C1470.deploymentDataFolder)
				End if 
			End if 
			CREATE DATA FILE:C313(This:C1470.deploymentDataFile.platformPath)
		End if 
	Else 
		If (This:C1470._shouldUseLogFile())
			SELECT LOG FILE:C345(This:C1470.deploymentDataFile.parent.file("data.journal").platformPath)
		End if 
	End if 
	
Function _shouldUseLogFile()->$shouldUseLogFile : Boolean
	
	$shouldUseLogFile:=False:C215
	
	If (Version type:C495 ?? Merged application:K5:28)
		If (Application type:C494=4D Volume desktop:K5:2) | (Application type:C494=4D Server:K5:6)
			If (Log file:C928="")
				If (Not:C34(Is data file locked:C716))
					$shouldUseLogFile:=True:C214
				End if 
			End if 
		End if 
	End if 
	
Function _shouldSwitchDataFile()->$shouldCheckDataFile : Boolean
	
	$shouldCheckDataFile:=False:C215
	
	If (Version type:C495 ?? Merged application:K5:28)
		If (Application type:C494=4D Volume desktop:K5:2) | (Application type:C494=4D Server:K5:6)
			If (Data file:C490=This:C1470.defaultDataFile.platformPath)
				If (Is data file locked:C716)
					$shouldCheckDataFile:=True:C214
				End if 
			End if 
		End if 
	End if 
	
Function linkComponents()->$this : cs:C1710.Startup
	
	$this:=This:C1470
	
	If (Not:C34(Is compiled mode:C492))
		
		This:C1470.componentsFolder.create()
		
		var $alias; $path : Text
		var $aliasFile : 4D:C1709.File
		var $targetFolder : 4D:C1709.Folder
		
		For each ($alias; This:C1470.components)
			$aliasFile:=This:C1470.componentsFolder.file($alias+".4dbase")
			
			$doIt:=False:C215
			
			Case of 
				: (This:C1470.componentsFolder.folder($alias+".4dbase").exists)
				: ($aliasFile.isPackage)
				: ($aliasFile.isAlias)
					
					RESOLVE ALIAS:C695($aliasFile.platformPath; $path)
					
					If (Test path name:C476($path)#Is a folder:K24:2)
						$aliasFile.delete()
						$doIt:=True:C214  //recreate alias
					End if 
					
				Else 
					If ($aliasFile.exists)
						$aliasFile.delete()
					End if 
					$doIt:=True:C214
			End case 
			
			If ($doIt)
				$targetFolder:=This:C1470.builtComponentsFolder.folder($alias+".4dbase")
				If ($targetFolder.isPackage)
					CREATE ALIAS:C694($targetFolder.platformPath; $aliasFile.platformPath)
					This:C1470.shouldRestart:=True:C214
				End if 
			End if 
			
		End for each 
	End if 
	
Function restartIfNecessary()
	
	If (This:C1470.shouldRestart)
		RESTART 4D:C1292
	End if 
	