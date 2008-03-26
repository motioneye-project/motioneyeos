#############################################################
#
# xboard
#
#############################################################
XBOARD_VERSION = 4.2.7
XBOARD_SOURCE = xboard-$(XBOARD_VERSION).tar.gz
XBOARD_SITE = $(BR2_GNU_MIRROR)/xboard
XBOARD_AUTORECONF = NO
XBOARD_INSTALL_STAGING = NO
XBOARD_INSTALL_TARGET = YES
XBOARD_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

XBOARD_CONF_OPT --prefix=/usr

XBOARD_DEPENDENCIES = uclibc gnuchess

$(eval $(call AUTOTARGETS,package,xboard))

