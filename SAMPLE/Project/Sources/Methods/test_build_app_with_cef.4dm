//%attributes = {"invisible":true}
$app:=cs:C1710.App.new()

$appName:=$app.getName()

$build:=cs:C1710.Build.new()

$build.versionString:=cs:C1710.Version.new().updatePatch().getString()

$build.certificateName:="Apple Distribution: keisuke miyako (Y69CWUC25B)"
//$build.certificateName:="Developer ID Application: keisuke miyako (Y69CWUC25B)"

$build.desktopAppIdentifier:="org.fourd."+$appName
$build.entitlements:=New object:C1471

$build.entitlements["com.apple.security.app-sandbox"]:=False:C215
$build.entitlements["com.apple.security.application-groups"]:=New collection:C1472("Y69CWUC25B.org.fourd")
$build.entitlements["com.apple.security.inherit"]:=True:C214
$build.entitlements["com.apple.security.network.client"]:=True:C214
$build.entitlements["com.apple.security.network.server"]:=True:C214
$build.entitlements["com.apple.security.files.user-selected.read-write"]:=True:C214
$build.entitlements["com.apple.security.files.user-selected.executable"]:=True:C214

$status:=$build.buildDesktop(".dmg")

If ($status.build.success)
	If ($status.archive.success)
		If ($status.notarize.success)
			SHOW ON DISK:C922($status.app.platformPath)
		End if 
	End if 
End if 