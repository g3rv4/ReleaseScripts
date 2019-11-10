param (
    [Parameter(Mandatory=$true)]
    [string]$Environment
)

$pathKey = "PATH_TO_$($Environment)".ToUpper()
$path = (Get-Item env:$pathKey).Value

rm -rf $path
mv staticSite/site $path

$cfZone = $env:CLOUDFLARE_ZONE
$cfToken = $env:CLOUDFLARE_API_TOKEN

$headers = @{
    "Authorization"="Bearer $($cfToken)";
    "Content-Type"="application/json"
}

$body = @{
    purge_everything=$true
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$($cfZone)/purge_cache" -Method 'DELETE' -Headers $headers -Body $body