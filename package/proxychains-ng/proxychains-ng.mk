#############################################################
#
# proxychains-ng
#
#############################################################
PROXYCHAINS_NG_VERSION = 4.4
PROXYCHAINS_NG_SOURCE = proxychains-$(PROXYCHAINS_NG_VERSION).tar.bz2
PROXYCHAINS_NG_SITE = http://downloads.sourceforge.net/project/proxychains-ng

define PROXYCHAINS_NG_POST_INSTALL_TARGET
	$(INSTALL) -m 644 -D $(@D)/src/proxychains.conf \
		$(TARGET_DIR)/etc/proxychains.conf
endef

PROXYCHAINS_NG_POST_INSTALL_TARGET_HOOKS += PROXYCHAINS_NG_POST_INSTALL_TARGET

$(eval $(autotools-package))
