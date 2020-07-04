Set-PSDebug -Trace 1

$path = $OctopusParameters["App.Path"]
$dockerComposeYaml = $OctopusParameters["Yaml.Path"]

$OctopusParameters | ConvertTo-Json | Write-Host

# rm -rf $path
# mv "bin/$($env:APP_ARTIFACT_NAME).$($env:RELEASE_ARTIFACTS_BIN_BUILDNUMBER)" $path

# docker-compose -f $dockerComposeYaml restart
