<#
.SYNOPSIS
  Build lecture decks with latexmk (pdflatex).
.EXAMPLE
  .\build.ps1            # build every week*/ folder
  .\build.ps1 week05     # build folders whose name starts with "week05"
  .\build.ps1 week05 -Notes   # also build main-notes.pdf (only slides with speaker notes)
  .\build.ps1 -Clean     # remove build/ folders
#>
param([string]$Week = "week", [switch]$Clean, [switch]$Notes)
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
    if ($Notes -and (Test-Path main-notes.tex)) {
      # step 1: every slide + notes (records note pages); step 2: keep noted slides only
      latexmk -interaction=nonstopmode -halt-on-error main-notes-full.tex
      if ($LASTEXITCODE -eq 0) { latexmk -interaction=nonstopmode -halt-on-error main-notes.tex }
      if ($LASTEXITCODE -ne 0) { Write-Error "Notes build failed: $($d.Name) (see $($d.Name)\build\main-notes.log)" }
      else { "OK -> $($d.Name)\build\main-notes.pdf" }
    }
  } finally { Pop-Location }
}
