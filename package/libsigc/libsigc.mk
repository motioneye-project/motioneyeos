#############################################################
#
# libsigc++
#
#############################################################
LIBSIGC_VERSION = 2.2.10
LIBSIGC_SOURCE = libsigc++-$(LIBSIGC_VERSION).tar.bz2
LIBSIGC_SITE = http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.2
LIBSIGC_INSTALL_STAGING = YES

define LIBSIGC_INSTALL_TARGET_FIXUP
	rm -rf $(TARGET_DIR)/usr/share/devhelp/books/libsigc++*
endef

LIBSIGC_POST_INSTALL_TARGET_HOOKS += LIBSIGC_INSTALL_TARGET_FIXUP

$(eval $(autotools-package))
