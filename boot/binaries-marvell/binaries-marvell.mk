################################################################################
#
# binaries-marvell
#
################################################################################

# This is version binaries-marvell-armada-18.12
BINARIES_MARVELL_VERSION = c5d3ef2b63ba66d8717ecbe679fd2e639cde88ee
BINARIES_MARVELL_SITE = $(call github,MarvellEmbeddedProcessors,binaries-marvell,$(BINARIES_MARVELL_VERSION))

BINARIES_MARVELL_LICENSE = GPL-2.0 with freertos-exception-2.0
BINARIES_MARVELL_LICENSE_FILES = README.md

BINARIES_MARVELL_INSTALL_IMAGES  = YES

define BINARIES_MARVELL_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(@D)/mrvl_scp_bl2.img $(BINARIES_DIR)/scp-fw.bin
endef

$(eval $(generic-package))
