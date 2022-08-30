Class constructor
	
Function isThreadSafe()->$isThreadSafe : Boolean
	
	C_LONGINT:C283($state; $mode)
	C_REAL:C285($time)
	
	PROCESS PROPERTIES:C336(Current process:C322; $name; $state; $time; $mode)
	
	$isThreadSafe:=($mode ?? 1)