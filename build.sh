#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <board|all> [mkimage|mkrelease|make_targets...]"
    exit 1
fi

set -e # exit at first error

board=$1
target=${*:2}
cd $(dirname $0)
basedir=$(pwd)
gzip=$(which pigz || which gzip)

if [ "$board" == "all" ]; then
    boards=$(ls $basedir/configs/*_defconfig | grep -oE '\w+_defconfig$' | cut -d '_' -f 1)
    for b in $boards; do
        if ! $0 $b $target; then
            exit 1
        fi
    done

    exit 0
fi

outputdir=$basedir/output/$board
boarddir=$basedir/board/$board

if ! [ -f $basedir/configs/${board}_defconfig ]; then
    echo "unknown board: $board"
    exit 1
fi

mkdir -p $outputdir

if ! [ -f $outputdir/.config ]; then
    make O=$outputdir ${board}_defconfig
fi

if [ "$target" == "mkimage" ]; then
    $boarddir/mkimage.sh
elif [ "$target" == "mkrelease" ]; then
    $boarddir/mkimage.sh
    cp $outputdir/images/motioneyeos-$board.img $basedir
    date=$(date +%Y%m%d)
    mv $basedir/motioneyeos-$board.img  $basedir/motioneyeos-$board-$date.img
    rm -f $basedir/motioneyeos-$board-$date.img.gz
    $gzip $basedir/motioneyeos-$board-$date.img
elif [ -n "$target" ]; then
    make O=$outputdir $target
else
    make O=$outputdir
    test -x $boarddir/mkimage.sh && $boarddir/mkimage.sh
fi

