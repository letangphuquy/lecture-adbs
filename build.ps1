<#
.SYNOPSIS
  Build lecture decks with latexmk (pdflatex).
.EXAMPLE
  .\build.ps1            # build every week*/ folder
  .\build.ps1 week05     # build folders whose name starts with "week05"
  .\build.ps1 -Clean     # remove build/ folders
#>
param([string]$Week = "week", [switch]$Clean)
$root = $PSScriptRoot
$dirs = Get-ChildItem -Path $root -Directory -Filter "$Week*"
if (-not $dirs) { Write-Error "No folder matches '$Week*'"; exit 1 }
foreach ($d in $dirs) {
  Push-Location $d.FullName
  try {
    if ($Clean) { if (Test-Path build) { Remove-Item -Recurse -Force build }; "cleaned $($d.Name)"; continue }
    latexmk -interaction=nonstopmode -halt-on-error main.tex
    if ($LASTEXITCODE -ne 0) { Write-Error "Build failed: $($d.Name) (see $($d.Name)\build\main.log)" }
    else { "OK -> $($d.Name)\build\main.pdf" }
  } finally { Pop-Location }
}
