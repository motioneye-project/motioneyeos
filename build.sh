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
gzip=$(which pigz 2> /dev/null || which gzip 2> /dev/null)

# extra environment from local file
test -f $basedir/.build-env && source $basedir/.build-env

# OS name
if [ -n "$THINGOS_SHORT_NAME" ]; then
    osname=$THINGOS_SHORT_NAME
else
    osname=$(source $basedir/board/common/overlay/etc/version && echo $os_short_name)
fi

# OS version
if [ -n "$THINGOS_VERSION" ]; then
    osversion=$THINGOS_VERSION
else
    osversion=$(source $basedir/board/common/overlay/etc/version && echo $os_version)
fi

# when the special "all" keyword is used for board,
# all boards are processed, in turn
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
    test -f $outputdir/images/$osname-$board.img || $boarddir/mkimage.sh
    cp $outputdir/images/$osname-$board.img $outputdir/images/$osname-$board-$osversion.img
    
    echo "preparing compressed xz image"
    rm -f $outputdir/images/$osname-$board-$osversion.img.xz
    xz -6ek -T 0 $outputdir/images/$osname-$board-$osversion.img
    echo "your xz image is ready at $outputdir/images/$osname-$board-$osversion.img.xz"
    
    echo "preparing compressed gz image"
    rm -f $outputdir/images/$osname-$board-$osversion.img.gz
    $gzip $outputdir/images/$osname-$board-$osversion.img
    echo "your gz image is ready at $outputdir/images/$osname-$board-$osversion.img.gz"
    
    rm -f $outputdir/images/$osname-$board-$osversion.img

elif [ "$target" == "clean-target" ]; then
    if [ -d $outputdir/target ]; then
        echo "removing target directory"
        rm -rf $outputdir/target/*

        echo "removing staging directory"
        rm -rf $outputdir/staging/*

        echo "removing images directory"
        rm -rf $outputdir/images/*
    fi

    if [ -d $outputdir/build ]; then
        echo "removing .stamp_target_installed files"
        find $outputdir/build -name .stamp_target_installed | xargs -r rm

        echo "removing .stamp_staging_installed files"
        find $outputdir/build -name .stamp_staging_installed | xargs -r rm

        echo "removing .stamp_host_installed files"
        find $outputdir/build -name .stamp_host_installed | xargs -r rm

        echo "removing .stamp_images_installed files"
        find $outputdir/build -name .stamp_images_installed | xargs -r rm

        echo "removing linux kernel build dir"
        make O=$outputdir linux-dirclean
    fi

    if [ -f $outputdir/.config ]; then
        echo "removing .config file"
        rm -f $outputdir/.config
    fi

    echo "target is clean"

elif [ "$target" == "all" ]; then
    make O=$outputdir all

elif [ -n "$target" ]; then
    make O=$outputdir $target

else  # if [ -z "$target ]
    $0 $board all
    echo "build successful"
fi

