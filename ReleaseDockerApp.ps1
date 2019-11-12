param (
    [Parameter(Mandatory=$true)]
    [string]$Environment
)

$pathKey = "PATH_TO_$($Environment)".ToUpper()
$path = (Get-Item env:$pathKey).Value

rm -rf $path
mv "bin/$($env:APP_ARTIFACT_NAME).$($env:RELEASE_ARTIFACTS_BIN_BUILDNUMBER)" $path

$dockerComposeYamlKey = "DOCKER_COMPOSE_YAML_$($Environment)".ToUpper()
$dockerComposeYaml = (Get-Item env:$dockerComposeYamlKey).Value

docker-compose -f $dockerComposeYaml restart