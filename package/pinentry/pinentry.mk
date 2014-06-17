################################################################################
#
# pinentry
#
################################################################################

PINENTRY_VERSION = 0.8.3
PINENTRY_SOURCE = pinentry-$(PINENTRY_VERSION).tar.bz2
PINENTRY_SITE = ftp://ftp.gnupg.org/gcrypt/pinentry
PINENTRY_LICENSE = GPLv2+
PINENTRY_LICENSE_FILES = COPYING
PINENTRY_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)
PINENTRY_CONF_OPT =  --disable-pinentry-gtk # gtk1
PINENTRY_CONF_OPT += --disable-pinentry-qt  # qt3
PINENTRY_CONF_OPT += --without-libcap       # requires PAM

# build with X if available
ifeq ($(BR2_PACKAGE_XORG7),y)
PINENTRY_CONF_OPT += --with-x
else
PINENTRY_CONF_OPT += --without-x
endif

# pinentry-ncurses backend
ifeq ($(BR2_PACKAGE_PINENTRY_NCURSES),y)
PINENTRY_CONF_OPT += --enable-ncurses
PINENTRY_DEPENDENCIES += ncurses
else
PINENTRY_CONF_OPT += --disable-ncurses
endif

# pinentry-gtk2 backend
ifeq ($(BR2_PACKAGE_PINENTRY_GTK2),y)
PINENTRY_CONF_OPT += --enable-pinentry-gtk2
PINENTRY_DEPENDENCIES += libgtk2
else
PINENTRY_CONF_OPT += --disable-pinentry-gtk2
endif

# pinentry-qt4 backend
ifeq ($(BR2_PACKAGE_PINENTRY_QT4),y)
# -pthread needs to be passed for certain toolchains
# http://autobuild.buildroot.net/results/6be/6be109ccedec603a67cebdb31b55865dcce0e128/
PINENTRY_CONF_OPT += LIBS=-pthread
PINENTRY_CONF_OPT += --enable-pinentry-qt4
PINENTRY_DEPENDENCIES += qt
else
PINENTRY_CONF_OPT += --disable-pinentry-qt4
endif

$(eval $(autotools-package))
