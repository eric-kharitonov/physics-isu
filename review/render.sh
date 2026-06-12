#!/usr/bin/env bash
# Render every slide of physics-slideshow.html to review/shots/slide-NN.png
# Re-run this after edits, then re-run the reviewer (see review/RUBRIC.md).
set -u
B="/c/Users/erick/.claude/skills/gstack/browse/dist/browse"
ROOT="C:/work/School/U11Physics/ISU"
cd "$ROOT" || exit 1
mkdir -p review/shots
rm -f review/shots/slide-*.png
"$B" viewport 1600x900 >/dev/null 2>&1 || true
"$B" goto "file://./physics-slideshow.html" >/dev/null 2>&1
sleep 1.2
"$B" press Home >/dev/null 2>&1
sleep 0.7
for n in $(seq 1 18); do
  "$B" screenshot "review/shots/slide-$(printf '%02d' "$n").png" >/dev/null 2>&1
  "$B" press ArrowRight >/dev/null 2>&1
  sleep 0.55
done
echo "rendered slides to review/shots/:"
ls review/shots/
