. $PSScriptRoot\helpers.ps1

$scaleConfigFileName = "azd-$($CONFIG.SCALE_TYPE)"
$scaleConfig = "$($scaleConfigFileName)-template.yaml"

$updatedConfig = replace_tokens $scaleConfig
(echo $updatedConfig > $PSScriptRoot/../ado/$scaleConfigFileName.yaml)


run "kubectl apply -f $PSScriptRoot/../ado/keda-template.yaml ; kubectl apply -f $PSScriptRoot/../ado/$($scaleConfigFileName).yaml"
