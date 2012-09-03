#############################################################
#
# opkg
#
#############################################################

OPKG_VERSION = 635
OPKG_SOURCE = opkg-$(OPKG_VERSION).tar.gz
OPKG_SITE = http://opkg.googlecode.com/svn/trunk/
OPKG_SITE_METHOD = svn
OPKG_INSTALL_STAGING = YES
OPKG_CONF_OPT = --disable-curl --disable-gpg
OPKG_AUTORECONF = YES

# Ensure directory for lockfile exists
define OPKG_CREATE_LOCKDIR
	mkdir -p $(TARGET_DIR)/usr/lib/opkg
endef

OPKG_POST_INSTALL_TARGET_HOOKS += OPKG_CREATE_LOCKDIR

$(eval $(autotools-package))
