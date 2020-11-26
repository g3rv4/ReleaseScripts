$path = $OctopusParameters["App.Path"]
$packagePath = $OctopusParameters["Octopus.Action.Package[Package].ExtractedPath"]
$dockerComposeYaml = $OctopusParameters["Yaml.Path"]

rm -rf $path
mv $packagePath $path

if ($dockerComposeYaml) {
    Write-Host "About to restart docker!"
    Write-Host "##octopus[stderr-progress]"
    Write-Host "really"
    Write-Output "##octopus[stderr-progress]"
    Write-host "really"
    [Console]::Out.Flush()
    docker-compose -f $dockerComposeYaml restart
    if ($LASTEXITCODE) {
        Exit $LASTEXITCODE
    }
}
