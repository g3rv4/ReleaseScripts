$dockerComposeYaml = $OctopusParameters["Yaml.Path"]

Write-Host 'Restarting docker...'
Write-Host "##octopus[stderr-progress]"
[Console]::Out.Flush()
docker-compose -f $dockerComposeYaml restart
if ($LASTEXITCODE) {
    Exit $LASTEXITCODE
}