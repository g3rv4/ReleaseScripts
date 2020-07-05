Set-PSDebug -Trace 1

$path = $OctopusParameters["App.Path"]
$nupkgPath = $OctopusParameters["Octopus.Action.Package[Package].PackageFilePath"]
$dockerComposeYaml = $OctopusParameters["Yaml.Path"]

rm -rf $path

mkdir $path
mv $nupkgPath $path

Push-Location $path
unzip -j Package.nupkg
rm Package.nupkg
Pop-Location

docker-compose -f $dockerComposeYaml restart 2>&1
if ($LASTEXITCODE) {
    Exit $LASTEXITCODE
}
