################################################################################
#
# inconsolata
#
################################################################################

INCONSOLATA_VERSION = 001.010
INCONSOLATA_SITE = http://snapshot.debian.org/archive/debian/20090524T155154Z/pool/main/t/ttf-inconsolata
INCONSOLATA_SOURCE = ttf-inconsolata_$(INCONSOLATA_VERSION).orig.tar.gz
INCONSOLATA_TARGET_DIR = $(TARGET_DIR)/usr/share/fonts/inconsolata
INCONSOLATA_LICENSE = OFLv1.0
INCONSOLATA_LICENSE_FILES = OFL.txt

define INCONSOLATA_INSTALL_TARGET_CMDS
	mkdir -p $(INCONSOLATA_TARGET_DIR)
	$(INSTALL) -m 644 $(@D)/*.otf $(INCONSOLATA_TARGET_DIR)
endef

$(eval $(generic-package))
