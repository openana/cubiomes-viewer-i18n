#!/usr/bin/env bash

basedir=`pwd`
echo "Rebuilding patch files from current fork state..."

function cleanupPatches {
    cd "$1"
    for patch in *.patch; do
        echo "$patch"
        gitver=$(tail -n 2 "$patch" | grep -ve "^$" | tail -n 1)
        diffs=$(git diff --staged "$patch" | grep -E "^(\+|\-)" | grep -Ev "(From [a-z0-9]{32,}|\-\-\- a|\+\+\+ b|.index)")

        testver=$(echo "$diffs" | tail -n 2 | grep -ve "^$" | tail -n 1 | grep "$gitver")
        if [ "x$testver" != "x" ]; then
            diffs=$(echo "$diffs" | sed 'N;$!P;$!D;$d')
        fi

        if [ "x$diffs" == "x" ] ; then
            git reset HEAD "$patch" >/dev/null
            git checkout -- "$patch" >/dev/null
        fi
    done
}

function rebuildPatches {
    what=$1
    target=$2
    echo "Formatting patches for $what..."

    cd "$basedir/${what}-patches/"
    if [ -d "$basedir/$target/.git/rebase-apply" ]; then
        # in middle of a rebase, be smarter
        echo "REBASE DETECTED - PARTIAL SAVE"
        last=$(cat "$basedir/$target/.git/rebase-apply/last")
        next=$(cat "$basedir/$target/.git/rebase-apply/next")
        for i in $(seq -f "%04g" 1 1 $last)
        do
            if [ $i -lt $next ]; then
                rm ${i}-*.patch
            fi
        done
    else
        rm -rf *.patch
    fi

    cd "$basedir/$target"

    git format-patch --no-stat -N -o "$basedir/${what}-patches/" upstream/upstream >/dev/null
    cd "$basedir"
    git add -A "$basedir/${what}-patches"
    cleanupPatches "$basedir/${what}-patches"
    echo "  Patches saved for $what to $what-patches/"
}

rebuildPatches cubiomes cubiomes-i18n
rebuildPatches cubiomes-viewer cubiomes-viewer-i18n
