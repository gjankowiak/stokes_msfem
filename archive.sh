#!/bin/bash

d=$(date +%Y%m%d-%H%M%S)
dir="archive-$d"
mkdir "$dir"
cp -r configs/ *.sh *.in *.edp *.txt *.jl *.py "$dir"
zip -r "$dir.zip" "$dir"
