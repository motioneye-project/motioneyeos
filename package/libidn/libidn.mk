################################################################################
#
# libidn
#
################################################################################

LIBIDN_VERSION = 1.33
LIBIDN_SITE = $(BR2_GNU_MIRROR)/libidn
LIBIDN_INSTALL_STAGING = YES
LIBIDN_CONF_ENV = EMACS="no"
LIBIDN_CONF_OPTS = --disable-java --enable-csharp=no
LIBIDN_DEPENDENCIES = host-pkgconf $(TARGET_NLS_DEPENDENCIES) $(if $(BR2_PACKAGE_LIBICONV),libiconv)
LIBIDN_LICENSE = GPL-2.0+, GPL-3.0+, LGPL-3.0+
LIBIDN_LICENSE_FILES = COPYINGv2 COPYINGv3 COPYING.LESSERv3

define LIBIDN_REMOVE_BINARY
	rm -f $(TARGET_DIR)/usr/bin/idn
endef

ifneq ($(BR2_PACKAGE_LIBIDN_BINARY),y)
LIBIDN_POST_INSTALL_TARGET_HOOKS += LIBIDN_REMOVE_BINARY
endif

define LIBIDN_REMOVE_EMACS_STUFF
	rm -rf $(TARGET_DIR)/usr/share/emacs
endef

LIBIDN_POST_INSTALL_TARGET_HOOKS += LIBIDN_REMOVE_EMACS_STUFF

$(eval $(autotools-package))
