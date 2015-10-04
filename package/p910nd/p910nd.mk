################################################################################
#
# p910nd
#
################################################################################

P910ND_VERSION = 0.97
P910ND_SITE = http://downloads.sourceforge.net/project/p910nd/p910nd/$(P910ND_VERSION)
P910ND_SOURCE = p910nd-$(P910ND_VERSION).tar.bz2
P910ND_LICENSE = GPLv2
P910ND_LICENSE_FILES = COPYING

define P910ND_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define P910ND_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/p910nd $(TARGET_DIR)/usr/sbin/p910nd
endef

$(eval $(generic-package))
