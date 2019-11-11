#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <{board}|all|boards> [mkimage|mkrelease|clean-target|initramfs|make-targets...]"
    echo "    mkimage - creates the OS image (.img)"
    echo "    mkrelease - creates the compressed OS image (.img.gz, .img.xz)"
    echo "    clean-target - removes the target dir, preserving the package build dirs"
    echo "    initramfs - builds the initramfs image; extra arguments will be passed internally to BuildRoot"
    echo ""
    echo "    for other make targets, see the BuildRoot manual"
    exit 1
fi

set -e # exit at first error

board=$1
target=${*:2}
cd "$(dirname "$0")"
basedir=$(pwd)
gzip=$(which pigz 2> /dev/null || which gzip 2> /dev/null)

# extra environment from local file
test -f "$basedir/.build-env" && source "$basedir/.build-env"

# OS name
if [ -n "$THINGOS_SHORT_NAME" ]; then
    osname=$THINGOS_SHORT_NAME
else
    osname=$(source "$basedir/board/common/overlay/etc/version" && echo "$OS_SHORT_NAME")
fi

# OS version
if [ -n "$THINGOS_VERSION" ]; then
    osversion=$THINGOS_VERSION
else
    osversion=$(source "$basedir/board/common/overlay/etc/version" && echo "$OS_VERSION")
fi

# when the special "boards" keyword is used for board, simply list all known boards
if [ "$board" == "boards" ]; then
    boards=$(ls "$basedir"/configs/*_defconfig | grep -v initramfs | grep -oE '\w+_defconfig$' | cut -d '_' -f 1)
    for b in $boards; do
        echo "$b"
    done

    exit 0
fi

# when the special "all" keyword is used for board, all boards are processed, in turn
if [ "$board" == "all" ]; then
    boards=$(ls "$basedir"/configs/*_defconfig | grep -v initramfs | grep -oE '\w+_defconfig$' | cut -d '_' -f 1)
    for b in $boards; do
        if ! $0 "$b" "$target"; then
            exit 1
        fi
    done

    exit 0
fi

outputdir=$basedir/output/$board
boarddir=$basedir/board/$board

if ! [ -f "$basedir/configs/${board}_defconfig" ]; then
    echo "unknown board: $board"
    exit 1
fi

function prepare_target_dir() {
    if [ -L "$outputdir/target/var/lib" ]; then
        rm "$outputdir/target/var/lib"
        mkdir "$outputdir/target/var/lib"
    fi
}

mkdir -p "$outputdir"

if ! [ -f "$outputdir/.config" ]; then
    make O="$outputdir" "${board}_defconfig"
fi

if [ "$target" == "mkimage" ]; then
    "$boarddir/mkimage.sh"

elif [ "$target" == "mkrelease" ]; then
    test -f "$outputdir/images/$osname-$board.img" || "$boarddir/mkimage.sh"
    cp "$outputdir/images/$osname-$board.img" "$outputdir/images/$osname-$board-$osversion.img"
    
    echo "preparing compressed xz image"
    rm -f "$outputdir/images/$osname-$board-$osversion.img.xz"
    xz -6ek -T 0 "$outputdir/images/$osname-$board-$osversion.img"
    echo "your xz image is ready at $outputdir/images/$osname-$board-$osversion.img.xz"
    
    echo "preparing compressed gz image"
    rm -f "$outputdir/images/$osname-$board-$osversion.img.gz"
    $gzip "$outputdir/images/$osname-$board-$osversion.img"
    echo "your gz image is ready at $outputdir/images/$osname-$board-$osversion.img.gz"
    
    rm -f "$outputdir/images/$osname-$board-$osversion.img"

elif [ "$target" == "clean-target" ]; then
    if [ -d "$outputdir/target" ]; then
        echo "removing target directory"
        rm -rf "$outputdir/target/"*

        echo "removing staging directory"
        rm -rf "$outputdir/staging/"*

        echo "removing images directory"
        rm -rf "$outputdir/images/"*
    fi

    if [ -d "$outputdir/build" ]; then
        echo "removing .stamp_target_installed files"
        find "$outputdir/build" -name .stamp_target_installed -print0 | xargs -0 -r rm

        echo "removing .stamp_staging_installed files"
        find "$outputdir/build" -name .stamp_staging_installed -print0 | xargs -0 -r rm

        echo "removing .stamp_host_installed files"
        find "$outputdir/build" -name .stamp_host_installed -print0 | xargs -0 -r rm

        echo "removing .stamp_images_installed files"
        find "$outputdir/build" -name .stamp_images_installed -print0 | xargs -0 -r rm

        echo "removing linux kernel build dir"
        make O="$outputdir" linux-dirclean
    fi

    if [ -f "$outputdir/.config" ]; then
        echo "removing .config file"
        rm -f "$outputdir/.config"
    fi

    echo "target is clean"

elif [[ "$target" == initramfs* ]]; then
    extra_args=${target:10}
    $0 "${board}_initramfs" "$extra_args"
    if [ -z "$extra_args" ] && [ -x "$boarddir/cpinitramfs.sh" ]; then
        IMG_DIR=$basedir/output/${board}_initramfs/images/ BOARD_DIR=$boarddir "$boarddir/cpinitramfs.sh"
    fi

elif [ "$target" == "all" ]; then
    prepare_target_dir
    make O="$outputdir" all

elif [ -n "$target" ]; then
    prepare_target_dir
    make O="$outputdir" "$target"

else  # if [ -z "$target ]
    $0 "$board" all
    echo "build successful"
fi

