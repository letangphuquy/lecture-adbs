#!/usr/bin/env sh
# Build lecture decks with latexmk (pdflatex).  POSIX sh — Linux / macOS / Git Bash.
#
#   ./build.sh                       build every week*/ folder
#   ./build.sh week05                build folders whose name starts with "week05"
#   ./build.sh --notes [weekNN]      also build main-notes.pdf (only slides with speaker notes)
#   ./build.sh --clean [weekNN]      remove build/ folders
#   ./build.sh --new week06-topic    create a new week from templates/new-week
set -eu
root=$(cd "$(dirname "$0")" && pwd)
cd "$root"

case "${1:-}" in
  -h|--help) sed -n '2,8p' "$0"; exit 0 ;;
  --new)
    name=${2:?usage: ./build.sh --new weekNN-topic}
    if [ -e "$name" ]; then echo "error: '$name' already exists" >&2; exit 1; fi
    cp -R templates/new-week "$name"
    echo "created $name/ - edit $name/main.tex"; exit 0 ;;
  --clean) clean=1; notes=0; week=${2:-week} ;;
  --notes) clean=0; notes=1; week=${2:-week} ;;
  *) clean=0; notes=0; week=${1:-week} ;;
esac

found=0; failed=0
for d in "$week"*/; do
  d=${d%/}
  [ -f "$d/main.tex" ] || continue
  found=1
  if [ "$clean" = 1 ]; then
    (cd "$d" && rm -rf build)
    echo "cleaned $d"; continue
  fi
  if (cd "$d" && latexmk -interaction=nonstopmode -halt-on-error main.tex >/dev/null 2>&1); then
    echo "OK -> $d/build/main.pdf"
  else
    echo "FAILED: $d (see $d/build/main.log)" >&2; failed=1
  fi
  if [ "$notes" = 1 ] && [ -f "$d/main-notes.tex" ]; then
    # step 1: every slide + notes (records note pages); step 2: keep noted slides only
    if (cd "$d" && latexmk -interaction=nonstopmode -halt-on-error main-notes-full.tex >/dev/null 2>&1 \
                && latexmk -interaction=nonstopmode -halt-on-error main-notes.tex >/dev/null 2>&1); then
      echo "OK -> $d/build/main-notes.pdf"
    else
      echo "FAILED: $d notes (see $d/build/main-notes.log)" >&2; failed=1
    fi
  fi
done
if [ "$found" = 0 ]; then echo "error: no folder matches '$week*' with a main.tex" >&2; exit 1; fi
exit "$failed"
