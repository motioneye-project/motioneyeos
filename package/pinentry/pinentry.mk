################################################################################
#
# pinentry
#
################################################################################

PINENTRY_VERSION = 0.9.4
PINENTRY_SOURCE = pinentry-$(PINENTRY_VERSION).tar.bz2
PINENTRY_SITE = ftp://ftp.gnupg.org/gcrypt/pinentry
PINENTRY_LICENSE = GPL-2.0+
PINENTRY_LICENSE_FILES = COPYING
PINENTRY_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv) \
	host-pkgconf
PINENTRY_CONF_OPTS += --without-libcap       # requires PAM

# pinentry uses some std::string functionality that needs C++11
# support when gcc >= 5.x. This should be removed when bumping
# pinentry, since newer versions no longer use std::string.
ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_5),y)
PINENTRY_CONF_ENV = CXXFLAGS="$(TARGET_CXXFLAGS) -std=gnu++11"
endif

# build with X if available
ifeq ($(BR2_PACKAGE_XORG7),y)
PINENTRY_CONF_OPTS += --with-x
else
PINENTRY_CONF_OPTS += --without-x
endif

ifeq ($(BR2_PACKAGE_LIBSECRET),y)
PINENTRY_CONF_OPTS += --enable-libsecret
PINENTRY_DEPENDENCIES += libsecret
else
PINENTRY_CONF_OPTS += --disable-libsecret
endif

# pinentry-ncurses backend
ifeq ($(BR2_PACKAGE_PINENTRY_NCURSES),y)
PINENTRY_CONF_OPTS += --enable-ncurses --with-ncurses-include-dir=none
PINENTRY_DEPENDENCIES += ncurses
else
PINENTRY_CONF_OPTS += --disable-ncurses
endif

# pinentry-gtk2 backend
ifeq ($(BR2_PACKAGE_PINENTRY_GTK2),y)
PINENTRY_CONF_OPTS += --enable-pinentry-gtk2
PINENTRY_DEPENDENCIES += libgtk2
else
PINENTRY_CONF_OPTS += --disable-pinentry-gtk2
endif

# pinentry-qt4 backend
ifeq ($(BR2_PACKAGE_PINENTRY_QT4),y)
# -pthread needs to be passed for certain toolchains
# http://autobuild.buildroot.net/results/6be/6be109ccedec603a67cebdb31b55865dcce0e128/
PINENTRY_CONF_OPTS += LIBS=-pthread MOC=$(HOST_DIR)/bin/moc
PINENTRY_CONF_OPTS += --enable-pinentry-qt4
PINENTRY_DEPENDENCIES += qt
else
PINENTRY_CONF_OPTS += --disable-pinentry-qt4
endif

$(eval $(autotools-package))
