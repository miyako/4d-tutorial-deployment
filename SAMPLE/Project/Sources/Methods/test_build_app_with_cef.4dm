//%attributes = {"invisible":true}
$app:=cs:C1710.App.new()

$appName:=$app.getName()

$build:=cs:C1710.Build.new($appName)

$build.versionString:=cs:C1710.Version.new().updatePatch().getString()

//$build.certificateName:="Apple Distribution: keisuke miyako (Y69CWUC25B)"
$build.certificateName:="Developer ID Application: keisuke miyako (Y69CWUC25B)"

//$build.desktopAppIdentifier:="org.fourd."+$appName
$build.serverAppIdentifier:="org.fourd."+$appName
$build.clientAppIdentifier:="org.fourd."+$appName+".client"

$build.entitlements:=New object:C1471

$build.entitlements["com.apple.security.app-sandbox"]:=True:C214
//$build.entitlements["com.apple.security.application-groups"]:=New collection($build.desktopAppIdentifier)
$build.entitlements["com.apple.security.application-groups"]:=New collection:C1472($build.serverAppIdentifier)
$build.entitlements["com.apple.security.network.client"]:=True:C214
$build.entitlements["com.apple.security.network.server"]:=True:C214
$build.entitlements["com.apple.security.files.user-selected.read-write"]:=True:C214
$build.entitlements["com.apple.security.files.user-selected.executable"]:=True:C214

//$status:=$build.buildDesktop(".dmg")

$status:=$build.buildAutoUpdateClientServer(".dmg")

If ($status.build.success)
	If ($status.server.archive.success)
		If ($status.server.notarize.success)
			SHOW ON DISK:C922($status.server.app.platformPath)
		End if 
	End if 
	If ($status.client.archive.success)
		If ($status.client.notarize.success)
			SHOW ON DISK:C922($status.client.app.platformPath)
		End if 
	End if 
End if 