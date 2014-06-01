################################################################################
#
# distcc
#
################################################################################

DISTCC_VERSION = 2.18.3
DISTCC_SOURCE = distcc-$(DISTCC_VERSION).tar.bz2
DISTCC_SITE = http://distcc.googlecode.com/files/
DISTCC_CONF_OPT = --with-included-popt --without-gtk --without-gnome
DISTCC_LICENSE = GPLv2+
DISTCC_LICENSE_FILES = COPYING

define DISTCC_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/distccd $(TARGET_DIR)/usr/bin/distccd
	$(INSTALL) -D $(@D)/distcc $(TARGET_DIR)/usr/bin/distcc
endef

$(eval $(autotools-package))
