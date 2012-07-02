#############################################################
#
# libglade
#
#############################################################
LIBGLADE_VERSION = 2.6.4
LIBGLADE_SOURCE = libglade-$(LIBGLADE_VERSION).tar.bz2
LIBGLADE_SITE = http://ftp.gnome.org/pub/GNOME/sources/libglade/2.6/
LIBGLADE_INSTALL_STAGING = YES
LIBGLADE_DEPENDENCIES = host-pkg-config libglib2 libgtk2 atk libxml2

define LIBGLADE_INSTALL_FIX
	rm -rf $(TARGET_DIR)/usr/share/xml/libglade \
	       $(TARGET_DIR)/usr/bin/libglade-convert
endef

LIBGLADE_POST_INSTALL_TARGET_HOOKS += LIBGLADE_INSTALL_FIX

$(eval $(autotools-package))
