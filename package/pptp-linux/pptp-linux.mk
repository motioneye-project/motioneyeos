################################################################################
#
# pptp-linux
#
################################################################################

PPTP_LINUX_VERSION = 1.10.0
PPTP_LINUX_SITE = http://downloads.sourceforge.net/project/pptpclient/pptp/pptp-$(PPTP_LINUX_VERSION)
PPTP_LINUX_SOURCE = pptp-$(PPTP_LINUX_VERSION).tar.gz
PPTP_LINUX_MAKE = $(MAKE1)
PPTP_LINUX_LICENSE = GPL-2.0+
PPTP_LINUX_LICENSE_FILES = COPYING

define PPTP_LINUX_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) OPTIMIZE= DEBUG= \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		IP=/sbin/ip
endef

define PPTP_LINUX_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/pptp $(TARGET_DIR)/usr/sbin/pptp
endef

$(eval $(generic-package))
