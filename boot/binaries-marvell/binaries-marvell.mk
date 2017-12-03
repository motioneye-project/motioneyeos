################################################################################
#
# binaries-marvell
#
################################################################################

BINARIES_MARVELL_VERSION = 0dabe23b956420b0928d337d635f0cd5646c33d0
BINARIES_MARVELL_SITE = $(call github,MarvellEmbeddedProcessors,binaries-marvell,$(BINARIES_MARVELL_VERSION))

# The license text is only available in the master branch, which is
# not used in this package. See
# https://raw.githubusercontent.com/MarvellEmbeddedProcessors/binaries-marvell/master/README.md.
BINARIES_MARVELL_LICENSE = GPL-2.0 with freertos-exception-2.0

BINARIES_MARVELL_IMAGE = $(call qstrip,$(BR2_TARGET_BINARIES_MARVELL_IMAGE))
BINARIES_MARVELL_INSTALL_IMAGES  = YES

define BINARIES_MARVELL_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(@D)/$(BINARIES_MARVELL_IMAGE) $(BINARIES_DIR)/scp-fw.bin
endef

$(eval $(generic-package))
