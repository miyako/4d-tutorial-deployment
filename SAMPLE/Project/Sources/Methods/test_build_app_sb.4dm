//%attributes = {"invisible":true}
$build:=cs:C1710.Build.new()

$build.versionString:=cs:C1710.Version.new()/*.updatePatch()*/.getString()

$build.certificateName:="Apple Distribution: keisuke miyako (Y69CWUC25B)"
$build.entitlements:=New object:C1471
$build.entitlements["com.apple.security.app-sandbox"]:=True:C214

$status:=$build.buildDesktop(".dmg")

If ($status.build.success)
	If ($status.archive.success)
		If ($status.notarize.success)
			SHOW ON DISK:C922($status.app.platformPath)
		End if 
	End if 
End if 