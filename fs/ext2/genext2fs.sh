#!/bin/sh
# genext2fs wrapper calculating needed blocks/inodes values if not specified

export LC_ALL=C

CALC_BLOCKS=1
CALC_INODES=1

while getopts x:d:D:b:i:N:m:g:e:zfqUPhVv f
do
    case $f in
	b) CALC_BLOCKS=0 ;;
	N) CALC_INODES=0 ;;
	d) TARGET_DIR=$OPTARG ;;
    esac
done

# calculate needed blocks
if [ $CALC_BLOCKS -eq 1 ];
then
    BLOCKS=$(du -s -c -k $TARGET_DIR | grep total | sed -e "s/total//")
    if [ $BLOCKS -ge 20000 ];
    then
	BLOCKS=$(expr $BLOCKS + 16384)
    else
	BLOCKS=$(expr $BLOCKS + 2400)
    fi
    set -- $@ -b $BLOCKS
fi

# calculate needed inodes
if [ $CALC_INODES -eq 1 ];
then
    INODES=$(find $TARGET_DIR | wc -l)
    INODES=$(expr $INODES + 400)
    set -- $@ -N $INODES
fi

exec genext2fs $@
