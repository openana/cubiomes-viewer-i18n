#!/usr/bin/env bash

basedir=`pwd`

function upstreamMerge {
    cd "$basedir/$1"
    git fetch && git reset --hard origin/$2
    cd ../
    git add $1
}

upstreamMerge cubiomes master
upstreamMerge cubiomes-viewer trunk
