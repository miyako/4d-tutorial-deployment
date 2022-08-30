$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		SET MENU BAR:C67(Form:C1466.menu)
		
		Form:C1466.dialogWorker:=DialogWorker
		
		Form:C1466.dialogWorker.startWorker(Form:C1466.method)
		
	: ($event.code=On Close Box:K2:21)
		
		CANCEL:C270
		
	: ($event.code=On Unload:K2:2)
		
		Form:C1466.dialogWorker.stopWorker()
		
		$dialog:=cs:C1710.Dialog.new()
		
		$dialog.close()
		
End case 