################################################################################
#
# xapp_xdm -- X.Org xdm application
#
################################################################################

XAPP_XDM_VERSION = 1.1.11
XAPP_XDM_SOURCE = xdm-$(XAPP_XDM_VERSION).tar.bz2
XAPP_XDM_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XDM_CONF_ENV = ac_cv_file__dev_urandom=yes
XAPP_XDM_DEPENDENCIES = xapp_xinit xapp_sessreg xapp_xrdb xlib_libX11 xlib_libXaw xlib_libXdmcp xlib_libXinerama xlib_libXt xproto_xineramaproto xproto_xproto
XAPP_XDM_CONF_OPT = --with-utmp-file=/var/adm/utmpx \
		    --with-wtmp-file=/var/adm/wtmpx

define XAPP_XDM_INSTALL_STARTUP_SCRIPT
	$(INSTALL) -m 0755 -D package/x11r7/xapp_xdm/S99xdm \
		$(TARGET_DIR)/etc/init.d/S99xdm
endef

XAPP_XDM_POST_INSTALL_TARGET_HOOKS += XAPP_XDM_INSTALL_STARTUP_SCRIPT

$(eval $(autotools-package))
