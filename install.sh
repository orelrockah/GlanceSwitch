#!/bin/bash
# GlanceSwitch installer for macOS (Apple Silicon).
#
#   curl -fsSL https://raw.githubusercontent.com/orelrockah/GlanceSwitch/main/install.sh | bash
#
# Downloads the latest release, verifies its SHA-256 against SHA256SUMS.txt,
# and installs it with the regular .pkg installer (which runs the
# GlanceSwitch self-test before reporting success). Files downloaded with curl
# are not quarantined, so macOS does not show the "could not verify" dialog.
#
# Set GLANCESWITCH_DRY_RUN=1 to download and verify without installing.
set -euo pipefail

REPO="orelrockah/GlanceSwitch"
say() { printf '\033[1m==> %s\033[0m\n' "$*"; }
die() { printf '\033[31mError: %s\033[0m\n' "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || die "this script is for macOS. On Windows use install.ps1."
[ "$(uname -m)" = "arm64" ] || die "GlanceSwitch needs a Mac with Apple Silicon (M1 or later)."

say "Looking up the latest GlanceSwitch release"
latest_url=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$REPO/releases/latest")
tag="${latest_url##*/}"
[[ "$tag" == v* ]] || die "could not find the latest release"
version="${tag#v}"
pkg="GlanceSwitch-${version}-macOS-arm64.pkg"
base="https://github.com/$REPO/releases/download/$tag"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
say "Downloading GlanceSwitch $version"
curl -fL --progress-bar -o "$tmp/$pkg" "$base/$pkg"
curl -fsSL -o "$tmp/SHA256SUMS.txt" "$base/SHA256SUMS.txt"

say "Verifying the download"
expected=$(awk -v f="$pkg" '$2 == f {print $1}' "$tmp/SHA256SUMS.txt")
actual=$(shasum -a 256 "$tmp/$pkg" | awk '{print $1}')
[ -n "$expected" ] || die "$pkg is not listed in SHA256SUMS.txt"
[ "$expected" = "$actual" ] || die "checksum mismatch - the download is damaged or was modified"
echo "SHA-256 OK: $actual"

if [ "${GLANCESWITCH_DRY_RUN:-0}" = "1" ]; then
  say "Dry run: verified, not installing"
  exit 0
fi

pkill -x GlanceSwitch 2>/dev/null && sleep 1 || true      # close a running copy
say "Installing (macOS asks for your password)"
sudo installer -pkg "$tmp/$pkg" -target /
say "Installed and verified: GlanceSwitch $version"
open /Applications/GlanceSwitch.app
