#!/usr/bin/env bash

git submodule update --init && ./applyPatches.sh || exit 1

mkdir -p build && cd ./build && qmake ../cubiomes-viewer-i18n && make
