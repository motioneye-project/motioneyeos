################################################################################
#
# xlib_libX11 -- X.Org X11 library
#
################################################################################

XLIB_LIBX11_VERSION = 1.1.5
XLIB_LIBX11_SOURCE = libX11-$(XLIB_LIBX11_VERSION).tar.bz2
XLIB_LIBX11_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBX11_AUTORECONF = YES
XLIB_LIBX11_INSTALL_STAGING = YES
XLIB_LIBX11_DEPENDENCIES = libxcb xutil_util-macros xlib_xtrans xlib_libXau xlib_libXdmcp xproto_kbproto xproto_xproto xproto_xextproto xproto_inputproto xproto_xf86bigfontproto xproto_bigreqsproto xproto_xcmiscproto
XLIB_LIBX11_CONF_ENV = ac_cv_func_mmap_fixed_mapped=yes
XLIB_LIBX11_CONF_OPT = --disable-malloc0returnsnull --with-xcb --enable-shared --disable-static --with-keysymdef=$(STAGING_DIR)/usr/include/X11/keysymdef.h

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libX11))

# src/util/makekeys is executed at build time to generate ks_tables.h, so
# it should get compiled for the host. The libX11 makefile unfortunately
# doesn't know about cross compilation so this doesn't work.
# Long term, we should probably teach it about HOSTCC / HOST_CFLAGS, but for
# now simply disable the src/util Makefile and build makekeys by hand in
# advance
$(XLIB_LIBX11_HOOK_POST_EXTRACT):
	echo '' > $(@D)/src/util/Makefile.am
	touch $@

$(XLIB_LIBX11_HOOK_POST_CONFIGURE):
	cd $(@D)/src/util && $(HOSTCC) $(HOSTCFLAGS) \
		-I$(STAGING_DIR)/usr/include -o makekeys makekeys.c
	touch $@
