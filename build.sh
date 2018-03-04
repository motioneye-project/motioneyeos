#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <board|all> [mkimage|mkrelease|clean-target|make-targets...]"
    echo "    mkimage - creates the OS image (.img)"
    echo "    mkrelease - creates the compressed OS image (.img.gz, .img.xz)"
    echo "    clean-target - removes the target dir, preserving the package build dirs"
    echo ""
    echo "    for other make targets, see the BuildRoot manual"
    exit 1
fi

set -e # exit at first error

board=$1
target=${*:2}
cd $(dirname $0)
basedir=$(pwd)
osname=$(source $basedir/board/common/overlay/etc/version && echo $os_short_name)
osversion=$(source $basedir/board/common/overlay/etc/version && echo $os_version)
gzip=$(which pigz || which gzip)

test -f $basedir/.build-env && source $basedir/.build-env

if [ "$board" == "all" ]; then
    boards=$(ls $basedir/configs/*_defconfig | grep -v initramfs | grep -oE '\w+_defconfig$' | cut -d '_' -f 1)
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
    cp $outputdir/images/$osname-$board.img $basedir
    mv $basedir/$osname-$board.img  $basedir/$osname-$board-$osversion.img
    rm -f $basedir/$osname-$board-$osversion.img.xz
    xz -6ek -T 0 $basedir/$osname-$board-$osversion.img
    echo "your xz image is ready at $basedir/$osname-$board-$osversion.img.xz"
    rm -f $basedir/$osname-$board-$osversion.img.gz
    $gzip $basedir/$osname-$board-$osversion.img
    echo "your gz image is ready at $basedir/$osname-$board-$osversion.img.gz"

elif [ "$target" == "clean-target" ]; then
    if [ -d $outputdir/build ]; then
        echo "removing .stamp_target_installed files"
        find $outputdir/build -name .stamp_target_installed | xargs -r rm
    fi

    if [ -d $outputdir/target ]; then
        echo "removing target directory"
        rm -rf $outputdir/target
    fi

    echo "target is clean"

elif [ -n "$target" ]; then
    make O=$outputdir $target

else
    make O=$outputdir all
    echo "build successful"
fi

