################################################################################
#
# exfat-utils
#
################################################################################

EXFAT_UTILS_VERSION = 1.1.0
EXFAT_UTILS_SITE = http://distfiles.gentoo.org/distfiles
EXFAT_UTILS_DEPENDENCIES = host-scons
EXFAT_UTILS_LICENSE = GPLv3+
EXFAT_UTILS_LICENSE_FILES = COPYING

define EXFAT_UTILS_BUILD_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) CCFLAGS="$(TARGET_CFLAGS) -std=c99" $(SCONS))
endef

define EXFAT_UTILS_INSTALL_TARGET_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) CCFLAGS="$(TARGET_CFLAGS) -std=c99" $(SCONS) \
		DESTDIR=$(TARGET_DIR)/usr/bin install)
endef

$(eval $(generic-package))
