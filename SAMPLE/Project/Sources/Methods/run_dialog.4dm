//%attributes = {"invisible":true,"preemptive":"incapable"}
#DECLARE($params : Object)

Case of 
	: (Count parameters:C259=0)
		
	Else 
		
		$dialog:=cs:C1710.Dialog.new()
		
		$title:=$params.title
		
		$window:=$dialog.find_window($title)
		
		If ($window#0)
			$dialog.activate_window($window)
		Else 
			
			$windowType:=$params.type
			
			C_OBJECT:C1216($formRect; $status)
			C_POINTER:C301($table)
			
			$status:=$dialog.split_form_identifier($params.name)
			
			If ($status.table="{projectForm}")
				var $name : Text
				$name:=$params.name
				FORM GET PROPERTIES:C674($name; $width; $height)
				$formRect:=$dialog.get_window_position($params.name; $width; $height)
				$window:=$dialog.open_window($formRect; $windowType; $title)
				DIALOG:C40($params.name; $params.form; *)
			Else 
				$formRect:=$dialog.get_window_position($params.name)
				$window:=$dialog.open_window($formRect; $windowType; $title)
				$table:=Table:C252($status.tableNumber)
				DIALOG:C40($table->; $status.form; $params.form; *)
			End if 
			
		End if 
		
End case 