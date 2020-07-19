Set-PSDebug -Trace 1

$path = $OctopusParameters["App.Path"]
$packagePath = $OctopusParameters["Octopus.Action.Package[Package].ExtractedPath"]
$dockerComposeYaml = $OctopusParameters["Yaml.Path"]

rm -rf $path
mv $packagePath $path

if ($dockerComposeYaml) {
    Write-Host "About to restart docker!"
    Write-Host "##octopus[stderr-progress]"
    docker-compose -f $dockerComposeYaml restart
    if ($LASTEXITCODE) {
        Exit $LASTEXITCODE
    }
}
