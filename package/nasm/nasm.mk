################################################################################
#
# nasm
#
################################################################################

NASM_VERSION = 2.13.03
NASM_SOURCE = nasm-$(NASM_VERSION).tar.xz
NASM_SITE = http://www.nasm.us/pub/nasm/releasebuilds/$(NASM_VERSION)
NASM_LICENSE = BSD-2-Clause
NASM_LICENSE_FILES = LICENSE

$(eval $(host-autotools-package))
