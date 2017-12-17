################################################################################
#
# noip
#
################################################################################

NOIP_VERSION = 2.1.9
NOIP_SITE = http://www.no-ip.com/client/linux
NOIP_SOURCE = noip-duc-linux.tar.gz
NOIP_LICENSE = GPL-2.0+
NOIP_LICENSE_FILES = COPYING

define NOIP_BUILD_CMDS
	$(SED) "/^#define CONFIG_FILENAME/ s/PREFIX//" $(@D)/noip2.c
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" PREFIX=/usr CONFDIR=/etc
endef

define NOIP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/noip2 $(TARGET_DIR)/usr/sbin/noip2
endef

$(eval $(generic-package))
