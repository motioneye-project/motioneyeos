################################################################################
#
# hans
#
################################################################################

HANS_VERSION = 0.4.4
HANS_SITE = http://downloads.sourceforge.net/project/hanstunnel/source
HANS_LICENSE = GPLv3+
HANS_LICENSE_FILES = LICENSE

define HANS_BUILD_CMDS
	$(MAKE) GCC="$(TARGET_CC)" GPP="$(TARGET_CXX)" -C $(@D)
endef

define HANS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/hans $(TARGET_DIR)/usr/sbin/hans
endef

$(eval $(generic-package))
