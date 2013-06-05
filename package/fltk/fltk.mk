################################################################################
#
# fltk
#
################################################################################

FLTK_VERSION = 1.1.7
FLTK_SOURCE = fltk-$(FLTK_VERSION)-source.tar.bz2
FLTK_SITE = http://ftp.easysw.com/pub/fltk/1.1.7/
FLTK_INSTALL_STAGING = YES
FLTK_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) STRIP=$(TARGET_STRIP) install
FLTK_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) STRIP=$(TARGET_STRIP) install
FLTK_CONF_OPT = --enable-threads --with-x
FLTK_DEPENDENCIES = xlib_libX11 xlib_libXext xlib_libXt
FLTK_CONFIG_SCRIPTS = fltk-config

$(eval $(autotools-package))
