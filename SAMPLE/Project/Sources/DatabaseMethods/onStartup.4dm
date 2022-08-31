cs:C1710.Startup.new().linkComponents().restartIfNecessary()

If (Not:C34(Process aborted:C672))
	cs:C1710.Startup.new().switchDataIfNecessary()  //データファイル切り替え
End if 

If (Not:C34(Process aborted:C672))
	cs:C1710.App.new().setAbout().runTestForm()  //通常のスタートアップ
End if 