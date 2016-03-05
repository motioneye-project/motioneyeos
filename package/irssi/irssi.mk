################################################################################
#
# irssi
#
################################################################################

IRSSI_VERSION = 0.8.17
IRSSI_SOURCE = irssi-$(IRSSI_VERSION).tar.bz2
# Do not use the github helper here. The generated tarball is *NOT* the
# same as the one uploaded by upstream for the release.
IRSSI_SITE = https://github.com/irssi-import/irssi/releases/download/$(IRSSI_VERSION)
IRSSI_LICENSE = GPLv2+
IRSSI_LICENSE_FILES = COPYING
IRSSI_DEPENDENCIES = host-pkgconf libglib2 ncurses
IRSSI_AUTORECONF = YES

IRSSI_CONF_OPTS = \
	--disable-glibtest \
	--with-ncurses=$(STAGING_DIR)/usr \
	--without-perl

ifeq ($(BR2_PACKAGE_OPENSSL),y)
IRSSI_CONF_OPTS += --enable-ssl
IRSSI_DEPENDENCIES += openssl
else
IRSSI_CONF_OPTS += --disable-ssl
endif

ifeq ($(BR2_PACKAGE_IRSSI_PROXY),y)
IRSSI_CONF_OPTS += --with-proxy
# If shared libs are disabled, 'proxy' has to go in the list of built-in
# modules.
ifeq ($(BR2_STATIC_LIBS),y)
IRSSI_CONF_OPTS += --with-modules=proxy
endif
else
IRSSI_CONF_OPTS += --without-proxy
endif # proxy

ifeq ($(BR2_PACKAGE_IRSSI_TRUE_COLOR),y)
IRSSI_CONF_OPTS += --enable-true-color
else
IRSSI_CONF_OPTS += --disable-true-color
endif

# Cross-compiling irssi with the perl interpreter enabled doesn't work
# yet. So, remove scripts as they are useless in that case.
define IRSSI_REMOVE_SCRIPTS
	rm -rf $(TARGET_DIR)/usr/share/irssi/scripts/
endef

IRSSI_POST_INSTALL_TARGET_HOOKS += IRSSI_REMOVE_SCRIPTS

$(eval $(autotools-package))
