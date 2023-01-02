Set-PSDebug -Trace 1

$azureContainerName = $OctopusParameters["Azure.Container.Name"]
$azureDockerPath = $OctopusParameters["Azure.Docker.Path"]
$azureUploadPath = Join-Path $azureDockerPath 'volumes' 'data'
$mssqlDataPath = Join-Path $OctopusParameters["MSSQL.Data.Path"] "backup"
$mssqlPassword = $OctopusParameters["MSSQL.Password"]
$dbs = $OctopusParameters["MSSQL.Databases"].Split(',')

Write-Host "##octopus[stderr-progress]"

$date = Get-Date (Get-Date).ToUniversalTime() -Format yyyyMMddHHmmss

foreach ($db in $dbs){
    $filename = "$date-$db"
    $uid = sh -c 'id -u'
    $gid = sh -c 'id -g'

    docker exec mssql-mssql-1 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $mssqlPassword -Q "BACKUP DATABASE [$db] TO DISK = N'/var/opt/mssql/data/backup/$filename.bak' WITH NOFORMAT, NOINIT, SKIP, NOREWIND, NOUNLOAD, STATS = 10"

    docker exec mssql-mssql-1 chown "$($uid):$($gid)" "/var/opt/mssql/data/backup/$filename.bak"

    $filenameWithPath = Join-Path $mssqlDataPath $filename
    $filenameWithAzPath = Join-Path $azureUploadPath $filename
    tar -czf "$filenameWithPath.tgz" -C $mssqlDataPath "$filename.bak"

    rm "$filenameWithPath.bak"
    Write-Host "moving $filenameWithPath.tgz to $filenameWithAzPath.tgz"
    mv "$filenameWithPath.tgz" "$filenameWithAzPath.tgz"

    Write-Output "Uploading $filename.tgz"
    docker compose --no-ansi -f "$azureDockerPath/docker-compose.yml" run --rm azcli az storage blob upload --container-name $azureContainerName --file "/var/data/$filename.tgz" --name "$filename.tgz"

    rm "$filenameWithAzPath.tgz"
}
