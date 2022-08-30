Class constructor
	
	This:C1470.shouldRestart:=False:C215
	
	This:C1470.components:=New collection:C1472("builder")
	
	This:C1470.projectFolder:=Folder:C1567(Get 4D folder:C485(Database folder:K5:14); fk platform path:K87:2)
	This:C1470.componentsFolder:=This:C1470.projectFolder.folder("Components")
	This:C1470.builtComponentsFolder:=This:C1470.projectFolder.parent.parent.folder("Components - Releases").folder("Components")
	
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
				: ($aliasFile.isAlias)
					
					RESOLVE ALIAS:C695($aliasFile.platformPath; $path)
					If (Test path name:C476($path)#Is a folder:K24:2)
						$aliasFile.delete()
						$doIt:=True:C214
					End if 
					
				: ($aliasFile.isPackage)
					
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
	