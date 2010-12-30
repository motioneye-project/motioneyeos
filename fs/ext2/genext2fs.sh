#!/bin/sh
# genext2fs wrapper calculating needed blocks/inodes values if not specified

export LC_ALL=C

CALC_BLOCKS=1
CALC_INODES=1

while getopts x:d:D:b:i:N:m:g:e:zfqUPhVv f
do
    case $f in
	b) CALC_BLOCKS=0 ;;
	N) CALC_INODES=0; INODES=$OPTARG ;;
	d) TARGET_DIR=$OPTARG ;;
    esac
done

# calculate needed inodes
if [ $CALC_INODES -eq 1 ];
then
    INODES=$(find $TARGET_DIR | wc -l)
    INODES=$(expr $INODES + 400)
    set -- $@ -N $INODES
fi

# calculate needed blocks
if [ $CALC_BLOCKS -eq 1 ];
then
    # size ~= superblock, block+inode bitmaps, inodes (8 per block), blocks
    # we scale inodes / blocks with 10% to compensate for bitmaps size + slack
    BLOCKS=$(du -s -c -k $TARGET_DIR | grep total | sed -e "s/total//")
    BLOCKS=$(expr 500 + \( $BLOCKS + $INODES / 8 \) \* 11 / 10)
    set -- $@ -b $BLOCKS
fi

exec genext2fs $@
