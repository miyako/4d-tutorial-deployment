//%attributes = {"invisible":true}
/*

* ビルド

*/

$buildApp:=cs:C1710.BuildApp.new()

$buildApp.findLicenses(New collection:C1472("4DOE"; "4UOE"; "4DDP"; "4UUD"))
$isOEM:=($buildApp.settings.Licenses.ArrayLicenseMac.Item.indexOf("@:4DOE@")#-1)

$buildApp.settings.BuildApplicationName:=Folder:C1567(fk database folder:K87:14).name
$buildApp.settings.BuildApplicationSerialized:=True:C214
$buildApp.settings.BuildMacDestFolder:=Temporary folder:C486+Generate UUID:C1066
$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLIncludeIt:=True:C214
$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLMacFolder:=$buildApp.getAppFolderForVersion().folder("4D Volume Desktop.app").platformPath
$buildApp.settings.SourcesFiles.RuntimeVL.IsOEM:=$isOEM
$buildApp.settings.SignApplication.MacSignature:=False:C215
$buildApp.settings.SignApplication.AdHocSign:=False:C215

$status:=$buildApp.build()

/*

署名

*/

$plist:=New object:C1471
$plist.CFBundleIdentifier:="com.4D.test"

$credentials:=New object:C1471
$credentials.username:="keisuke.miyako@4d.com"
$credentials.password:="@keychain:altool"
$credentials.keychainProfile:="notarytool"
//$credentials.certificateName:="Apple Distribution: keisuke miyako (Y69CWUC25B)"
$credentials.certificateName:="Developer ID Application: keisuke miyako (Y69CWUC25B)"

$signApp:=cs:C1710.SignApp.new($credentials; $plist)

$signApp.entitlements["com.apple.security.app-sandbox"]:=False:C215
$signApp.entitlements["com.apple.security.application-groups"]:=New collection:C1472("Y69CWUC25B."+$plist.CFBundleIdentifier)
$signApp.entitlements["com.apple.security.inherit"]:=True:C214
$signApp.entitlements["com.apple.security.network.client"]:=True:C214
$signApp.entitlements["com.apple.security.network.server"]:=True:C214

$app:=Folder:C1567($buildApp.settings.BuildMacDestFolder; fk platform path:K87:2).folder("Final Application").folder($buildApp.settings.BuildApplicationName+".app")

$status.sign:=$signApp.sign($app)

/*

公証 

*/

$status.archive:=$signApp.archive($app; ".pkg")

$status.notarize:=$signApp.notarize($status.archive.file)