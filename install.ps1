# GlanceSwitch installer for Windows 10/11.
#
#   irm https://raw.githubusercontent.com/orelrockah/GlanceSwitch/main/install.ps1 | iex
#
# Downloads the latest release, verifies its SHA-256 against SHA256SUMS.txt,
# and runs the regular setup (per-user, no admin rights; it runs the
# GlanceSwitch self-test before reporting success). Files downloaded from
# PowerShell carry no "downloaded from the internet" mark, so SmartScreen does
# not block the setup.
#
# Set $env:GLANCESWITCH_DRY_RUN = "1" to download and verify without installing.
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"          # much faster downloads on PowerShell 5.1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Repo = "orelrockah/GlanceSwitch"
function Say($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }

Say "Looking up the latest GlanceSwitch release"
$release = Invoke-RestMethod "https://api.github.com/repos/$Repo/releases/latest" `
             -Headers @{ "User-Agent" = "GlanceSwitch-installer" }
$version = $release.tag_name.TrimStart("v")
$asset = $release.assets | Where-Object { $_.name -like "GlanceSwitch-Setup-*.exe" } | Select-Object -First 1
$sums = $release.assets | Where-Object { $_.name -eq "SHA256SUMS.txt" } | Select-Object -First 1
if (-not $asset -or -not $sums) { throw "The latest release has no Windows installer." }

$dir = Join-Path $env:TEMP ("GlanceSwitch-" + [guid]::NewGuid())
New-Item -ItemType Directory -Path $dir | Out-Null
try {
    $setup = Join-Path $dir $asset.name
    Say "Downloading GlanceSwitch $version"
    Invoke-WebRequest $asset.browser_download_url -OutFile $setup -UseBasicParsing
    $sumsText = (Invoke-WebRequest $sums.browser_download_url -UseBasicParsing).Content
    if ($sumsText -is [byte[]]) { $sumsText = [Text.Encoding]::UTF8.GetString($sumsText) }

    Say "Verifying the download"
    $line = ($sumsText -split "`n") | Where-Object { $_ -match ("\s" + [regex]::Escape($asset.name) + "\s*$") }
    if (-not $line) { throw "$($asset.name) is not listed in SHA256SUMS.txt" }
    $expected = ($line -split "\s+")[0].ToLower()
    $actual = (Get-FileHash $setup -Algorithm SHA256).Hash.ToLower()
    if ($expected -ne $actual) { throw "Checksum mismatch - the download is damaged or was modified." }
    Write-Host "SHA-256 OK: $actual"

    if ($env:GLANCESWITCH_DRY_RUN -eq "1") { Say "Dry run: verified, not installing"; return }

    Get-Process GlanceSwitch -ErrorAction SilentlyContinue | Stop-Process -Force
    Say "Installing"
    $p = Start-Process -FilePath $setup -ArgumentList "/SILENT", "/CURRENTUSER", "/NORESTART" -Wait -PassThru
    if ($p.ExitCode -ne 0) { throw "Setup failed (exit code $($p.ExitCode))." }
    Say "Installed and verified: GlanceSwitch $version"
    Start-Process (Join-Path $env:LOCALAPPDATA "Programs\GlanceSwitch\GlanceSwitch.exe")
}
finally {
    Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
}
