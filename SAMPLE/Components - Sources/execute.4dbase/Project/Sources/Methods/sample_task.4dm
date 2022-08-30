//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($data : Variant; $signal : 4D:C1709.Signal)  //何も返してはいけない

$workerName:="TEST"

Case of 
	: (This:C1470#Null:C1517)
		
		ALERT:C41(JSON Stringify:C1217($data))
		
		KILL WORKER:C1390
		
	: (Count parameters:C259=2)
		
		ASSERT:C1129(OB Instance of:C1731($signal; 4D:C1709.Signal))
		
		var $returnValue : Object  //ワーカーから返したいもの（shared object or shared collection）
		
		$returnValue:=New shared object:C1526
		
		Use ($signal)
			$signal.data:=$returnValue
		End use 
		
		Use ($returnValue)
			$info:=Get system info:C1571
			$returnValue.info:=OB Copy:C1225($info; ck shared:K85:29; $returnValue)
		End use 
		
		If (Not:C34(Process aborted:C672))
			$signal.trigger()
		End if 
		
		KILL WORKER:C1390
		
	Else 
		
		$params:=New object:C1471
		$params.formula:=Formula:C1597(sample_task)
		
		execute_task("sample_task"; $params)
		
		KILL WORKER:C1390
		
End case 