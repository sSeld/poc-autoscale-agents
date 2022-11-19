. $PSScriptRoot\helpers.ps1

$type = $CONFIG.SCALE_TYPE
Invoke-Expression "pushd agents ; docker build -t localhost:5001/azp-agent:$type . ; docker push localhost:5001/azp-agent:$type ; popd"
