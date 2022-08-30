Class constructor
	
	This:C1470.close_method:=Formula:C1597(run_dialog).source
	
Function open_window($formRect : Object; $windowType : Integer; $title : Text)->$window : Integer
	
	If (Not:C34(This:C1470.is_preemtive()))
		//%T-
		If ($formRect.x=0) & ($formRect.y=0)
			C_LONGINT:C283($left; $top; $right; $bottom; $screen)
			$screen:=Menu bar screen:C441
			SCREEN COORDINATES:C438($left; $top; $right; $bottom; $screen)
			$cx:=($right-$left)/2
			$cy:=($bottom-$top)/2
			$formRect.x:=$cx-($formRect.width/2)
			$formRect.y:=$cy-($formRect.height/2)
		End if 
		$window:=Open window:C153($formRect.x; $formRect.y; $formRect.x+$formRect.width; $formRect.y+$formRect.height; $windowType; $title; This:C1470.close_method)
		//%T+
	End if 
	
Function activate_window($window : Integer)
	
	If (Not:C34(This:C1470.is_preemtive()))
		//%T-
		GET WINDOW RECT:C443($x; $y; $r; $b; $window)
		SET WINDOW RECT:C444($x; $y; $r; $b; $window)
		//%T+
	End if 
	
Function get_user_windows()->$windowNumbers : Collection
	
	$processes:=Get process activity:C1495(Processes only:K5:35)
	
	$windowNumbers:=New collection:C1472
	
	If (Not:C34(This:C1470.is_preemtive()))
		//%T-
		ARRAY LONGINT:C221($windows; 0)
		WINDOW LIST:C442($windows; *)
		For ($i; 1; Size of array:C274($windows))
			$windowNumber:=$windows{$i}
			$windowNumbers.push($windowNumber)
		End for 
		//%T+
	End if 
	
Function find_window($titleToSearch : Text)->$match : Integer
	
	$windows:=This:C1470.get_user_windows()
	
	C_LONGINT:C283($window)
	
	If (Not:C34(This:C1470.is_preemtive()))
		//%T-
		For each ($window; $windows) Until ($match#0)
			$title:=Get window title:C450($window)
			If ($title=$titleToSearch)
				$match:=$window
			End if 
		End for each 
		//%T+
	End if 
	
Function get_window_position($formIdentifier : Text; $iWidth : Integer; $iHeight : Integer)->$formRect : Object
	
	C_OBJECT:C1216($info)
	
	$info:=This:C1470.split_form_identifier($formIdentifier)
	
	If ($info#Null:C1517)
		
		C_TEXT:C284($tableName; $formName)
		$tableName:=$info.table
		$formName:=$info.form
		
		var $formFile : 4D:C1709.File
		
		$formFile:=This:C1470.get_window_bounds_file($tableName; $formName)
		
		C_OBJECT:C1216($formRect)
		
		C_LONGINT:C283($left; $top; $right; $bottom)
		
		$appVersion:=Application version:C493
		If (Not:C34(This:C1470.is_preemtive()))
			//%T-
			$screen:=Menu bar screen:C441
			SCREEN COORDINATES:C438($left; $top; $right; $bottom; $screen)
			//%T+
		End if 
		
		If ($formFile.exists)
			$json:=$formFile.getText("utf-8"; Document with CR:K24:21)
			$formRect:=JSON Parse:C1218($json; Is object:K8:27)
			//for backward compatibility with old code
			If ($formRect.left=Null:C1517)
				$formRect.left:=$formRect.x
			End if 
			If ($formRect.top=Null:C1517)
				$formRect.top:=$formRect.y
			End if 
			If ($formRect.screen=Null:C1517)
				$formRect.screen:=1
			End if 
		Else 
			
			If (Not:C34(This:C1470.is_preemtive()))
				C_LONGINT:C283($width; $height)
				//%T-
				If (Count parameters:C259>3)
					$width:=$iWidth
					$height:=$iHeight
				Else 
					If ($tableName="{projectForm}")
						FORM GET PROPERTIES:C674($formName; $width; $height)
					Else 
						$tableNumber:=ds:C1482[$tableName].getInfo().tableNumber
						C_POINTER:C301($table)
						$table:=Table:C252($tableNumber)
						FORM GET PROPERTIES:C674($table->; $formName; $width; $height)
					End if 
				End if 
				//%T+
				$formRect:=New object:C1471("x"; 0; "y"; 0; "width"; $width; "height"; $height; "screen"; $screen; "left"; 0; "top"; 0)
			End if 
			
		End if 
		
		If ($formRect#Null:C1517)
			
			C_LONGINT:C283($x; $y; $s)
			
			If (Not:C34(This:C1470.is_preemtive()))
				//%T-
				$s:=Menu bar screen:C441
				SCREEN COORDINATES:C438($sleft; $stop; $sright; $sbottom; $s)
				$x:=$formRect.left*($sright-$sleft)
				$y:=$formRect.top*($sbottom-$stop)
				If ($s#$formRect.screen)
					SCREEN COORDINATES:C438($sleft; $stop; $sright; $sbottom; $formRect.screen)
					If ($formRect.x>=$sleft) & ($formRect.x<=$sright) & ($formRect.y>=$stop) & ($formRect.y<=$sbottom)
						$x:=$formRect.x
						$y:=$formRect.y
					End if 
				End if 
				//%T+
			End if 
			
			$formRect.x:=$x
			$formRect.y:=$y
			
			$0:=$formRect
			
		End if 
		
	End if 
	
Function set_window_position($formIdentifier : Text; $window : Integer)
	
	$info:=This:C1470.split_form_identifier($formIdentifier)
	
	If ($info#Null:C1517)
		
		C_TEXT:C284($tableName; $formName)
		$tableName:=$info.table
		$formName:=$info.form
		
		var $formFile : 4D:C1709.File
		
		$formFile:=This:C1470.get_window_bounds_file($tableName; $formName)
		
		C_OBJECT:C1216($formRect)
		
		If (Not:C34(This:C1470.is_preemtive()))
			
			If ($window#0)
				
				C_REAL:C285($left; $top)
				C_LONGINT:C283($x; $y; $right; $bottom; $screen; $s)
				//%T-
				GET WINDOW RECT:C443($x; $y; $right; $bottom; $window)
				C_LONGINT:C283($sleft; $stop; $sright; $sbottom)
				$screen:=Menu bar screen:C441
				SCREEN COORDINATES:C438($sleft; $stop; $sright; $sbottom; $screen)
				$left:=($x-$sleft)/($sright-$sleft)
				$top:=($y-$stop)/($sbottom-$stop)
				For ($s; 1; Count screens:C437)
					SCREEN COORDINATES:C438($sleft; $stop; $sright; $sbottom; $s)
					If ($x>=$sleft) & ($x<=$sright) & ($y>=$stop) & ($y<=$sbottom)
						$screen:=$s
						$left:=($x-$sleft)/($sright-$sleft)
						$top:=($y-$stop)/($sbottom-$stop)
					End if 
				End for 
				//%T+
				
				$formRect:=New object:C1471("x"; $x; "y"; $y; "width"; $right-$x; "height"; $bottom-$y; "screen"; $screen; "left"; $left; "top"; $top)
				
				$json:=JSON Stringify:C1217($formRect; *)
				$formFile.setText($json; "utf-8"; Document with CR:K24:21)
				
			End if 
			
		End if 
		
	End if 
	
Function get_window_bounds_file($tableName : Text; $formName : Text)->$file : 4D:C1709.File
	
	$prefFolder:=Folder:C1567(fk user preferences folder:K87:10).parent.folder("Makoto-Ya")
	
	$file:=$prefFolder.folder($tableName).file($formName+".json")
	
Function is_preemtive()->$is_preemtive : Boolean
	
	C_LONGINT:C283($state; $mode)
	C_REAL:C285($time)
	
	PROCESS PROPERTIES:C336(Current process:C322; $name; $state; $time; $mode)
	
	$is_preemtive:=$mode ?? 1
	
Function get_form_identifier()->$formIdentifier : Text
	
	var $table : Pointer
	
	$table:=Current form table:C627
	
	var $name : Text
	
	$name:=Current form name:C1298
	
	If (Is nil pointer:C315($table))
		$formIdentifier:=$name
	Else 
		$formIdentifier:="["+Table name:C256($table)+"]"+$name
	End if 
	
Function is_runtime()->$dialog_is_runtime : Boolean
	
	$dialog_is_runtime:=OB Is defined:C1231(Form:C1466)
	
	If (Not:C34($dialog_is_runtime))
		
		OBJECT SET VISIBLE:C603(*; "@"; False:C215)
		
		ARRAY LONGINT:C221($events; 1)
		$events{1}:=On Unload:K2:2
		OBJECT SET EVENTS:C1239(*; ""; $events; Disable events others unchanged:K42:39)
		
	End if 
	
Function split_form_identifier($formIdentifier : Text)->$status : Object
	
	$status:=New object:C1471("table"; Null:C1517; "form"; Null:C1517; "tableNumber"; Null:C1517)
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019("\\[([^]]+)\\](.+)"; $formIdentifier; 1; $pos; $len))
		
		$status.table:=Substring:C12($formIdentifier; $pos{1}; $len{1})
		$status.form:=Substring:C12($formIdentifier; $pos{2}; $len{2})
		
		$table:=Parse formula:C1576("["+$status.table+"]"; Formula out with tokens:K88:3)
		
		If (Match regex:C1019("\\[[^:]+:(\\d+)\\]"; $table; 1; $pos; $len))
			$status.tableNumber:=Num:C11(Substring:C12($table; $pos{1}; $len{1}))
		End if 
		
	Else 
		
		$status.table:="{projectForm}"
		$status.form:=$formIdentifier
		
	End if 
	
Function run($params : Object)
	
	CALL WORKER:C1389(1; Formula:C1597(run_dialog).source; $params)
	
Function close()
	
	This:C1470.set_window_position(This:C1470.get_form_identifier(); Current form window:C827)