#!/bin/bash

# parameter #1	BOARD_PATH
# parameter #2  LINUX26_DIR

TOPDIR=`pwd`
BOARD_PATH=$1
LINUX26_DIR=$2

cd ${TOPDIR}/${BOARD_PATH}
for i in `ls *linux*.config` ; do
	echo Copying $i ...
	cp $i ${LINUX26_DIR}/.config
done
