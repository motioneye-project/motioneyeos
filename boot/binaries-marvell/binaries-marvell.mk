################################################################################
#
# binaries-marvell
#
################################################################################

# This is version binaries-marvell-armada-18.06
BINARIES_MARVELL_VERSION = 14481806e699dcc6f7025dbe3e46cf26bb787791
BINARIES_MARVELL_SITE = $(call github,MarvellEmbeddedProcessors,binaries-marvell,$(BINARIES_MARVELL_VERSION))

BINARIES_MARVELL_LICENSE = GPL-2.0 with freertos-exception-2.0
BINARIES_MARVELL_LICENSE_FILES = README.md

BINARIES_MARVELL_IMAGE = $(call qstrip,$(BR2_TARGET_BINARIES_MARVELL_IMAGE))
BINARIES_MARVELL_INSTALL_IMAGES  = YES

define BINARIES_MARVELL_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(@D)/$(BINARIES_MARVELL_IMAGE) $(BINARIES_DIR)/scp-fw.bin
endef

$(eval $(generic-package))
