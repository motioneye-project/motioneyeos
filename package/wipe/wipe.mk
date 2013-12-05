################################################################################
#
# wipe
#
################################################################################

WIPE_VERSION = 2.3.1
WIPE_SITE = http://downloads.sourceforge.net/project/wipe/wipe/$(WIPE_VERSION)
WIPE_SOURCE = wipe-$(WIPE_VERSION).tar.bz2
WIPE_AUTORECONF = YES
WIPE_LICENSE = GPLv2+
WIPE_LICENSE_FILES = LICENSE

define WIPE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/wipe $(TARGET_DIR)/usr/bin/wipe
	$(INSTALL) -D $(@D)/wipe.1 $(TARGET_DIR)/usr/share/man/man1/wipe.1
endef

$(eval $(autotools-package))
