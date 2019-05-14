################################################################################
#
# xapp_xdm
#
################################################################################

XAPP_XDM_VERSION = 1.1.12
XAPP_XDM_SOURCE = xdm-$(XAPP_XDM_VERSION).tar.bz2
XAPP_XDM_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XDM_LICENSE = MIT
XAPP_XDM_LICENSE_FILES = COPYING
XAPP_XDM_CONF_ENV = ac_cv_file__dev_urandom=yes
XAPP_XDM_DEPENDENCIES = \
	xapp_sessreg \
	xapp_xrdb \
	xlib_libX11 \
	xlib_libXaw \
	xlib_libXdmcp \
	xlib_libXinerama \
	xlib_libXt \
	xorgproto
XAPP_XDM_CONF_OPTS = \
	--with-appdefaultdir=/usr/share/X11/app-defaults \
	--with-utmp-file=/var/adm/utmpx \
	--with-wtmp-file=/var/adm/wtmpx

define XAPP_XDM_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/x11r7/xapp_xdm/S99xdm \
		$(TARGET_DIR)/etc/init.d/S99xdm
endef

$(eval $(autotools-package))
