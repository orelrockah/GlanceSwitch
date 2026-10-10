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
# Follow the /releases/latest redirect instead of the REST API: the API allows
# only 60 anonymous requests per hour per IP, which shared networks exhaust.
$req = [Net.HttpWebRequest]::Create("https://github.com/$Repo/releases/latest")
$req.Method = "HEAD"
$req.AllowAutoRedirect = $false
$req.UserAgent = "GlanceSwitch-installer"
$resp = $req.GetResponse()
$location = $resp.Headers["Location"]
$resp.Close()
if (-not $location -or $location -notmatch "/tag/(v[0-9][^/]*)$") { throw "Could not find the latest release." }
$tag = $Matches[1]
$version = $tag.TrimStart("v")
$base = "https://github.com/$Repo/releases/download/$tag"
$assetName = "GlanceSwitch-Setup-$version.exe"

$dir = Join-Path $env:TEMP ("GlanceSwitch-" + [guid]::NewGuid())
New-Item -ItemType Directory -Path $dir | Out-Null
try {
    $setup = Join-Path $dir $assetName
    Say "Downloading GlanceSwitch $version"
    Invoke-WebRequest "$base/$assetName" -OutFile $setup -UseBasicParsing
    $sumsText = (Invoke-WebRequest "$base/SHA256SUMS.txt" -UseBasicParsing).Content
    if ($sumsText -is [byte[]]) { $sumsText = [Text.Encoding]::UTF8.GetString($sumsText) }

    Say "Verifying the download"
    $line = ($sumsText -split "`n") | Where-Object { $_ -match ("\s" + [regex]::Escape($assetName) + "\s*$") }
    if (-not $line) { throw "$assetName is not listed in SHA256SUMS.txt" }
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
