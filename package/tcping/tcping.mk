################################################################################
#
# tcping
#
################################################################################

TCPING_VERSION = 1.3.5
TCPING_SITE = http://linuxco.de/tcping
TCPING_LICENSE = GPL-3.0+
TCPING_LICENSE_FILES = LICENSE

define TCPING_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CCFLAGS="$(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D) tcping.linux
endef

define TCPING_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/tcping $(TARGET_DIR)/usr/bin/tcping
endef

$(eval $(generic-package))
