//%attributes = {"invisible":true}
$build:=cs:C1710.Build.new()

$build.versionString:=cs:C1710.Version.new().updatePatch().getString()

$status:=$build.buildDesktop()

