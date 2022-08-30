//%attributes = {"invisible":true,"shared":true,"preemptive":"capable"}
#DECLARE($data : Object; $signal : 4D:C1709.Signal)  //何も返してはいけない

Case of 
	: (This:C1470#Null:C1517)
		
		CALL FORM:C1391($data.window; $data.method; $data)
		
		KILL WORKER:C1390
		
	: (Count parameters:C259=2)
		
		ASSERT:C1129(OB Instance of:C1731($signal; 4D:C1709.Signal))
		
		var $returnValue : Object
		
		$returnValue:=New shared object:C1526
		
		Use ($signal)
			$signal.data:=$returnValue
		End use 
		
		$timestamp:=Timestamp:C1445
		
		Use ($returnValue)
			$returnValue.timestamp:=$timestamp
			$returnValue.window:=$data.params.window
			$returnValue.method:=$data.params.method
		End use 
		
		If (Not:C34(Process aborted:C672))
			$signal.trigger()
		End if 
		
		KILL WORKER:C1390
		
	Else 
		
		$process:=cs:C1710.Process.new()
		
		If (Not:C34($process.isThreadSafe()))
			
			//%T-
			If (Form:C1466#Null:C1517)
				
				Form:C1466.timestamp:=$data.timestamp
				
			End if 
			//%T+
		End if 
		
End case 