$path = $env:APP_PATH
$dockerComposeYaml = $env:DOCKERCOMPOSE_YAMLPATH

rm -rf $path
mv "bin/$($env:APP_ARTIFACT_NAME).$($env:RELEASE_ARTIFACTS_BIN_BUILDNUMBER)" $path

docker-compose -f $dockerComposeYaml restart