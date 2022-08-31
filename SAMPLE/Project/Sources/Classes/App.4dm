Class constructor($menu : Variant)
	
	If (Count parameters:C259=1)
		This:C1470.menu:=$menu
	Else 
		This:C1470.menu:=1
	End if 
	
Function runTestForm()
	
	$dialog:=cs:C1710.Dialog.new()
	
	$params:=New object:C1471
	
	$params.title:="TEST"
	$params.type:=Plain fixed size window:K34:6
	$params.name:="TEST"
	$params.form:=New object:C1471("method"; Formula:C1597(dialog_TEST); "interval"; 1)
	
	$params.form.menu:=This:C1470.menu
	
	$dialog.run($params)
	
Function _getAboutMenuTitle()->$title : Text
	
	$name:=Folder:C1567(fk database folder:K87:14).name
	
	$title:=$name+"について…"
	
Function setAbout()->$that : cs:C1710.App
	
	$that:=This:C1470
	
	SET ABOUT:C316(This:C1470._getAboutMenuTitle(); Formula:C1597(run_ABOUT).source)
	
Function runAboutForm()
	
	$window:=Open form window:C675("ABOUT")
	
	SET WINDOW TITLE:C213(This:C1470._getAboutMenuTitle(); $window)
	
	DIALOG:C40("ABOUT")