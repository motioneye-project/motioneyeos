#!/usr/bin/env bash

BUILDIR=$1
TTY=$2
BOARD=$3

family_at91sam9g45m10ek="at91sam9m10g45ek"
mach_at91sam9g45m10ek="at91sam9m10-g45-ek"
dtb_at91sam9g45m10ek="at91sam9m10g45ek.dtb"

family_at91sam9rlek="at91sam9rlek"
mach_at91sam9rlek="at91sam9rl64-ek"
dtb_at91sam9rlek="at91sam9rlek.dtb"

family_at91sam9g15ek="at91sam9x5ek"
mach_at91sam9g15ek="at91sam9g15-ek"
dtb_at91sam9g15ek="at91sam9g15ek.dtb"

family_at91sam9g25ek="at91sam9x5ek"
mach_at91sam9g25ek="at91sam9g25-ek"
dtb_at91sam9g25ek="at91sam9g25ek.dtb"

family_at91sam9g35ek="at91sam9x5ek"
mach_at91sam9g35ek="at91sam9g35-ek"
dtb_at91sam9g35ek="at91sam9g35ek.dtb"

family_at91sam9x25ek="at91sam9x5ek"
mach_at91sam9x25ek="at91sam9x25-ek"
dtb_at91sam9x25ek="at91sam9x25ek.dtb"

family_at91sam9x35ek="at91sam9x5ek"
mach_at91sam9x35ek="at91sam9x35-ek"
dtb_at91sam9x35ek="at91sam9x35ek.dtb"

family_sama5d31ek="sama5d3xek"
mach_sama5d31ek="at91sama5d3x-ek"
dtb_sama5d31ek="sama5d31ek.dtb"

family_sama5d31ek_revc="sama5d3xek"
mach_sama5d31ek_revc="at91sama5d3x-ek"
dtb_sama5d31ek_revc="sama5d31ek_revc.dtb"

family_sama5d33ek="sama5d3xek"
mach_sama5d33ek="at91sama5d3x-ek"
dtb_sama5d33ek="sama5d33ek.dtb"

family_sama5d33ek_revc="sama5d3xek"
mach_sama5d33ek_revc="at91sama5d3x-ek"
dtb_sama5d33ek_revc="sama5d33ek_revc.dtb"

family_sama5d34ek="sama5d3xek"
mach_sama5d34ek="at91sama5d3x-ek"
dtb_sama5d34ek="sama5d34ek.dtb"

family_sama5d34ek_revc="sama5d3xek"
mach_sama5d34ek_revc="at91sama5d3x-ek"
dtb_sama5d34ek_revc="sama5d34ek_revc.dtb"

family_sama5d35ek="sama5d3xek"
mach_sama5d35ek="at91sama5d3x-ek"
dtb_sama5d35ek="sama5d35ek.dtb"

family_sama5d35ek_revc="sama5d3xek"
mach_sama5d35ek_revc="at91sama5d3x-ek"
dtb_sama5d35ek_revc="sama5d35ek_revc.dtb"

family_sama5d36ek="sama5d3xek"
mach_sama5d36ek="at91sama5d3x-ek"
dtb_sama5d36ek="sama5d36ek.dtb"

family_sama5d36ek_revc="sama5d3xek"
mach_sama5d36ek_revc="at91sama5d3x-ek"
dtb_sama5d36ek_revc="sama5d36ek_revc.dtb"

family_sama5d3_xplained="sama5d3_xplained"
mach_sama5d3_xplained="at91sama5d3x-xplained"
dtb_sama5d3_xplained="at91-sama5d3_xplained.dtb"

family_sama5d4ek="sama5d4ek"
mach_sama5d4ek="at91sama5d4x-ek"
dtb_sama5d4ek="at91-sama5d4ek.dtb"

family_sama5d4_xplained="sama5d4_xplained"
mach_sama5d4_xplained="at91sama5d4x-ek"
dtb_sama5d4_xplained="at91-sama5d4_xplained.dtb"

usage() {
	cat << EOF
Usage:
  $0 <builddir_path> <interface> <board>

Available boards:
  at91sam9g45m10ek
  at91sam9rlek
  at91sam9g15ek
  at91sam9g25ek
  at91sam9x25ek
  at91sam9g35ek
  at91sam9x35ek
  sama5d31ek
  sama5d33ek
  sama5d34ek
  sama5d35ek
  sama5d36ek
  sama5d31ek_revc (Until rev. C)
  sama5d33ek_revc (Until rev. C)
  sama5d34ek_revc (Until rev. C)
  sama5d35ek_revc (Until rev. C)
  sama5d36ek_revc (Until rev. C)
  sama5d3_xplained
  sama5d4ek
  sama5d4_xplained

Example:
  $0 ./output /dev/ttyACM0 at91sam9g45m10ek
EOF
}

F="family_$BOARD"
M="mach_$BOARD"
D="dtb_$BOARD"

if [[ $# != 3 || -z ${!F} ]]; then
	usage
	exit 1
fi

video_mode="video=LVDS-1:800x480-16"
if [[ $BOARD == "*pda4" ]]; then
	video_mode="video=LVDS-1:480x272-16"
fi

echo "Executing: ${!F} O=$1/images $1/host/bin/sam-ba $TTY ${!M} $(dirname $0)/nandflash.tcl -- ${!F} ${!D} $video_mode"
export O=$1/images
$1/host/bin/sam-ba $TTY ${!M} $(dirname $0)/nandflash.tcl -- ${!F} ${!D} $video_mode
