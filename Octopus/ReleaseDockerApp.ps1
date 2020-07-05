Set-PSDebug -Trace 1

$OctopusParameters | ConvertTo-Json | Write-Host

$path = $OctopusParameters["App.Path"]
$packagePath = $OctopusParameters["Octopus.Action.Package[Package].ExtractedPath"]
$dockerComposeYaml = $OctopusParameters["Yaml.Path"]

rm -rf $path
mv $packagePath $path

docker-compose -f $dockerComposeYaml restart *>&1
if ($LASTEXITCODE) {
    Exit $LASTEXITCODE
}
