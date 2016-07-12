#!/bin/bash

dir=$1

basedir="$PWD"

cd "$dir" || exit 1
ls
FF_VERBOSITY=0 FreeFem++ "${basedir}/plot.edp"
