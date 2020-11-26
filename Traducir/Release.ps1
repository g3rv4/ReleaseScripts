$path = $OctopusParameters["App.Path"]
$staticFilesPath = $OctopusParameters["StaticFiles.Path"]
$dockerNginxPath = $OctopusParameters["Yaml.Nginx.Path"]
$packagePath = $OctopusParameters["Octopus.Action.Package[Package].ExtractedPath"]
$dockerComposeYaml = $OctopusParameters["Yaml.Path"]
$instanceNames = $OctopusParameters["DockerInstance.Names"].Split(',')

Write-Host "##octopus[stderr-progress]"

docker-compose -f $dockerComposeYaml stop
if ($LASTEXITCODE) {
    Exit $LASTEXITCODE
}

rm -rf $path
mv $packagePath $path

rm -rf $staticFilesPath
cp -r "$($path)/wwwroot" $staticFilesPath

docker-compose -f $dockerComposeYaml up -d
if ($LASTEXITCODE) {
    Exit $LASTEXITCODE
}

# Give it 5 seconds for it to start
Start-Sleep -s 5

# Run migrations
foreach ($instanceName in $instanceNames) {
    Write-Output "Running migrations on $instanceName"
    docker exec $instanceName wget http://localhost:5000/admin/migrate -O -
    if ($LASTEXITCODE) {
        Exit $LASTEXITCODE
    }
}

# when messing with multiple containers, nginx gets confused... restarting it clears it up
if ($instanceNames.Count -gt 1) {
    docker-compose -f $dockerNginxPath restart
    if ($LASTEXITCODE) {
        Exit $LASTEXITCODE
    }
}
