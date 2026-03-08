param(
  [int]$Port = 8000,
  [string]$HostName = "0.0.0.0",
  [string]$SiteDir = "website"
)

$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$serveDir = Join-Path $root $SiteDir

if (-not (Test-Path -Path $serveDir -PathType Container)) {
  Write-Error "Site directory not found: $serveDir`
Tip: pass -SiteDir . to serve repo root."
}

$localUrl = "http://localhost:$Port/"
$loopbackUrl = "http://127.0.0.1:$Port/"

Write-Host "Starting CYVL dev preview"
Write-Host "- Serving directory: $serveDir"
Write-Host "- Binding host: $HostName"
Write-Host "- Port: $Port"
Write-Host "- Site URL: $localUrl"
Write-Host "- Loopback URL: $loopbackUrl"

try {
  $lan = (Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Where-Object { $_.IPAddress -ne '127.0.0.1' -and $_.PrefixOrigin -ne 'WellKnown' } |
    Select-Object -First 1 -ExpandProperty IPAddress)
  if ($lan) {
    Write-Host "- LAN URL: http://$lan`:$Port/"
  }
} catch {
  # best-effort only
}

try {
  Start-Process $localUrl | Out-Null
  Write-Host "Opened browser automatically."
} catch {
  Write-Host "Could not auto-open a browser in this environment."
}

Write-Host "If this is WSL/VM/container, open the URL from your host machine browser."
Write-Host "Press Ctrl+C to stop."

python -m http.server $Port --bind $HostName --directory $serveDir
