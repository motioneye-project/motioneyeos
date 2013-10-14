################################################################################
#
# noip
#
################################################################################

NOIP_VERSION = 2.1.9
NOIP_SITE = http://www.no-ip.com/client/linux
NOIP_SOURCE = noip-duc-linux.tar.gz
NOIP_LICENSE = GPLv2+
NOIP_LICENSE_FILES = COPYING

define NOIP_BUILD_CMDS
	sed -i -e "s:\(#define CONFIG_FILENAME\).*:\1 \"/etc/no-ip2.conf\":" \
		$(@D)/noip2.c
	$(MAKE) -C $(@D) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" \
		PREFIX=/usr CONFDIR=/etc
endef

define NOIP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/noip2 $(TARGET_DIR)/usr/sbin/noip2
endef

define NOIP_UNINSTALL_TARGET_CMDS
	rm -f "$(TARGET_DIR)/usr/sbin/noip2"
endef

define NOIP_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
