################################################################################
#
# exfat-utils
#
################################################################################

EXFAT_UTILS_VERSION = 1.0.1
EXFAT_UTILS_SITE = http://exfat.googlecode.com/files
EXFAT_UTILS_DEPENDENCIES = host-scons
EXFAT_UTILS_LICENSE = GPLv3+
EXFAT_UTILS_LICENSE_FILES = COPYING

define EXFAT_UTILS_BUILD_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) $(SCONS))
endef

define EXFAT_UTILS_INSTALL_TARGET_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) $(SCONS) \
		DESTDIR=$(TARGET_DIR)/usr/bin install)
endef

$(eval $(generic-package))
