#!/usr/bin/env bash

basedir=`pwd`

function upstreamMerge {
    cd "$basedir/$1"
    git fetch && git reset --hard origin/master
    cd ../
    git add $1
}

upstreamMerge cubiomes
upstreamMerge cubiomes-viewer
