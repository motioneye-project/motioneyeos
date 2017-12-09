#!/bin/sh

BOARD_DIR="$(dirname $0)"

install -m 0644 -D ${BOARD_DIR}/uEnv-example.txt ${TARGET_DIR}/boot/uEnv-example.txt
