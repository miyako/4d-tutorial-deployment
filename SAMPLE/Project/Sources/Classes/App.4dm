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