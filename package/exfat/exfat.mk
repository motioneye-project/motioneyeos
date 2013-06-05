################################################################################
#
# exfat
#
################################################################################

EXFAT_VERSION = 1.0.1
EXFAT_SITE = http://exfat.googlecode.com/files
EXFAT_SOURCE = fuse-exfat-$(EXFAT_VERSION).tar.gz
EXFAT_DEPENDENCIES = host-scons libfuse
EXFAT_LICENSE = GPLv3+
EXFAT_LICENSE_FILES = COPYING

define EXFAT_BUILD_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) $(SCONS))
endef

define EXFAT_INSTALL_TARGET_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) $(SCONS) \
		DESTDIR=$(TARGET_DIR)/usr/sbin install)
endef

$(eval $(generic-package))
