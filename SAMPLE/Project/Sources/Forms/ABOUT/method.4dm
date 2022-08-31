$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		$version:=cs:C1710.Version.new()
		$versionString:=$version.getString()
		Form:C1466.version:=$versionString
		
End case 