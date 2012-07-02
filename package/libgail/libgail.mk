#############################################################
#
# libgail
#
#############################################################
LIBGAIL_VERSION_MAJOR = 1.22
LIBGAIL_VERSION_MINOR = 3
LIBGAIL_VERSION = $(LIBGAIL_VERSION_MAJOR).$(LIBGAIL_VERSION_MINOR)
LIBGAIL_SOURCE = gail-$(LIBGAIL_VERSION).tar.bz2
LIBGAIL_SITE = http://ftp.gnome.org/pub/gnome/sources/gail/$(LIBGAIL_VERSION_MAJOR)
LIBGAIL_AUTORECONF = YES
LIBGAIL_INSTALL_STAGING = YES

ifneq ($(BR2_PACKAGE_XLIB_LIBX11),y)
LIBGAIL_CONF_OPT += --disable-x
endif

LIBGAIL_DEPENDENCIES = host-pkg-config libgtk2 pango

$(eval $(autotools-package))
