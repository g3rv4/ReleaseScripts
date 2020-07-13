$dockerComposeYaml = $OctopusParameters["Yaml.Path"]

Write-Host 'Restarting docker...'
[Console]::Out.Flush()

Write-Host "##octopus[stderr-progress]"
docker-compose -f $dockerComposeYaml restart
if ($LASTEXITCODE) {
    Exit $LASTEXITCODE
}