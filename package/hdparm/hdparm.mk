################################################################################
#
# hdparm
#
################################################################################

HDPARM_VERSION = 9.43
HDPARM_SITE = http://downloads.sourceforge.net/project/hdparm/hdparm
HDPARM_LICENSE = BSD-Style
HDPARM_LICENSE_FILES = LICENSE.TXT

define HDPARM_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		STRIP=/bin/true
endef

define HDPARM_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/hdparm $(TARGET_DIR)/sbin/hdparm
endef

$(eval $(generic-package))
