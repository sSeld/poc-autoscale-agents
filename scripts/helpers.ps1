$CONFIG = get-content -raw config.json | convertfrom-json

$CLUSTER = $CONFIG.CLUSTER_PATH
$ADO = $CONFIG.ADO_PATH


function check_for ($cmd){
    if(-not (Get-Command $cmd)){
        Write-Output "$cmd does not exist on this machine."
    } else{
        write-output "$cmd exists"
    }
}

function run($cmd){
    Write-Output "Running: $cmd"
    Invoke-Expression "$cmd"
}

function start_registry(){
    $regconExists = (docker container list -f name=kind-registry)
    $started =(docker inspect -f '{{.State.Running}}' "kind-registry") -eq "true"
    
    if($regconExists ){
        if(-not ($started)){
            run "docker container start kind-registry"
        }
    }else {
        run "docker run -d --restart=always -p '127.0.0.1:5001:5000' --name 'kind-registry' registry:2" ;
    }
}
function create_cluster(){
    run "kind create cluster --config $CLUSTER/k8cluster.yaml"
    run "docker network connect 'kind'  'kind-registry'"
    run "kubectl apply -f $CLUSTER/k8cluster-config.yaml"
}

function ingress_controller(){
    run "kubectl apply -f .$CLUSTER/ingress-controller.yaml"
}

function replace_tokens($tokenizedConfig){
    $scaleConfigContent = Get-Content $PSScriptRoot/../ado/$tokenizedConfig

    $CONFIG.PSObject.Properties | ForEach-Object {
        $scaleConfigContent = ($scaleConfigContent) -replace ("{{$($_.Name)}}", "$($_.Value)")
    }
    return $scaleConfigContent
}