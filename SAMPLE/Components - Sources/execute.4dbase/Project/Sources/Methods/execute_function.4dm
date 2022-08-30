//%attributes = {"invisible":true,"shared":true,"preemptive":"capable"}
#DECLARE($function : Object; $params : Object)

Case of 
	: (Count parameters:C259=0)
		
		//ON ERR CALL
		
	: (Count parameters:C259=2)
		
		//entry point 
		
		If (OB Instance of:C1731($function; 4D:C1709.Function))
			
			$local_settings:=local_settings
			
			$o:=New object:C1471
			
			$o.CLIENT_ID:=$local_settings.Get_flag("CLIENT_ID")
			$o.formula:=$function
			$o.params:=$params.params
			$o.name:=String:C10($params.name)
			$o.executeOnServer:=Bool:C1537($params.executeOnServer)
			
			If ($o.name="")
				$o.name:=$function.source
			End if 
			
			If ($function.executeOnServer)
				//$p:=Execute on server(Current method name; 0; $o.name; $o)
			Else 
				CALL WORKER:C1389($o.name; Current method name:C684; $o)
			End if 
			
		End if 
		
	: (Count parameters:C259=1)
		
		$function.formula.call($function; $function.params)
		
		KILL WORKER:C1390
		
End case 