Set-PSDebug -Trace 1

$path = $env:CONTENT_PATH
$cfZone = $env:CLOUDFLARE_ZONE
$cfToken = $env:CLOUDFLARE_APITOKEN
$staticFolderContent = if ($env:CONTENT_ARTIFACT) { $env:CONTENT_ARTIFACT } else { "site" }

rm -rf $path
mv "staticSite/$($staticFolderContent)" $path

$headers = @{
    "Authorization"="Bearer $($cfToken)";
    "Content-Type"="application/json"
}

$body = @{
    purge_everything=$true
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$($cfZone)/purge_cache" -Method 'DELETE' -Headers $headers -Body $body