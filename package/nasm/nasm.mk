################################################################################
#
# nasm
#
################################################################################

NASM_VERSION = 2.11.02
NASM_SOURCE = nasm-$(NASM_VERSION).tar.xz
NASM_SITE = http://www.nasm.us/pub/nasm/releasebuilds/$(NASM_VERSION)
NASM_LICENSE = BSD-2c
NASM_LICENSE_FILES = LICENSE

$(eval $(host-autotools-package))
