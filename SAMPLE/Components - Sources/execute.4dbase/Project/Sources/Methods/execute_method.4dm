//%attributes = {"invisible":true,"shared":true,"preemptive":"capable"}
#DECLARE($formula : Object; $that : Object; $params : Variant)

Case of 
	: (Count parameters:C259=3)
		
		If (OB Instance of:C1731($formula; 4D:C1709.Function))
			
			$o:=New object:C1471
			$o.formula:=$formula
			$o.that:=$that
			$o.params:=$params
			
			CALL WORKER:C1389(1; Current method name:C684; $o)
			
		End if 
		
	: (Count parameters:C259=1)
		
		If (Not:C34(OB Instance of:C1731($formula; 4D:C1709.Function)))
			$formula.formula.call($formula.that; $formula.params)
		End if 
		
End case 