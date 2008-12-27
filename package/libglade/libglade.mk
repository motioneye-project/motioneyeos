#############################################################
#
# libglade
#
#############################################################
LIBGLADE_VERSION = 2.6.3
LIBGLADE_SOURCE = libglade-$(LIBGLADE_VERSION).tar.bz2
LIBGLADE_SITE = http://ftp.gnome.org/pub/GNOME/sources/libglade/2.6/
LIBGLADE_INSTALL_STAGING = YES
LIBGLADE_DEPENDENCIES = pkgconfig libglib2 libgtk2 atk libxml2

$(eval $(call AUTOTARGETS,package,libglade))

$(LIBGLADE_HOOK_POST_INSTALL):
	rm -rf $(TARGET_DIR)/usr/share/gtk-doc \
	       $(TARGET_DIR)/usr/share/xml/libglade \
	       $(TARGET_DIR)/usr/bin/libglade-convert
