################################################################################
#
# lzma
#
################################################################################

LZMA_VERSION = 4.32.7
LZMA_SOURCE = lzma-$(LZMA_VERSION).tar.xz
LZMA_SITE = http://tukaani.org/lzma

$(eval $(host-autotools-package))

LZMA = $(HOST_DIR)/usr/bin/lzma
