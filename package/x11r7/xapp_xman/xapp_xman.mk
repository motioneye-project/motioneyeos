#############################################################
#
# xapp_xman - Manual page display program for the X Window System
#
#############################################################
XAPP_XMAN_VERSION:=1.0.3
XAPP_XMAN_SOURCE:=xman-$(XAPP_XMAN_VERSION).tar.bz2
XAPP_XMAN_SITE:=http://xorg.freedesktop.org/releases/individual/app
XAPP_XMAN_AUTORECONF = NO
XAPP_XMAN_INSTALL_TARGET = YES

XAPP_XMAN_CONF_ENV = ac_cv_file__etc_man_conf=no \
		ac_cv_file__etc_man_config=no \
		ac_cv_file__etc_manpath_config=no

XAPP_XMAN_CONF_OPT = --enable-shared \
		--disable-static \
		--disable-IPv6

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xman))
