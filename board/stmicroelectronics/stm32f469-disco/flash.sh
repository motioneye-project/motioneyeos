#!/bin/bash

OUTPUT_DIR=$1

if ! test -d "${OUTPUT_DIR}" ; then
    echo "ERROR: no output directory specified."
    echo "Usage: $0 OUTPUT_DIR"
    exit 1
fi

${OUTPUT_DIR}/host/usr/bin/openocd -f board/stm32f469discovery.cfg \
  -c "init" \
  -c "reset init" \
  -c "flash probe 0" \
  -c "flash info 0" \
  -c "flash write_image erase ${OUTPUT_DIR}/images/stm32f469i-disco.bin 0x08000000" \
  -c "flash write_image erase ${OUTPUT_DIR}/images/stm32f469-disco.dtb 0x08004000" \
  -c "flash write_image erase ${OUTPUT_DIR}/images/xipImage 0x08008000" \
  -c "reset run" \
  -c "shutdown"
