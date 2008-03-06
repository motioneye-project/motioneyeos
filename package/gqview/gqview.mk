#############################################################
#
# gqview
#
#############################################################
GQVIEW_VERSION = 2.1.5
GQVIEW_SOURCE = gqview-$(GQVIEW_VERSION).tar.gz
GQVIEW_SITE = http://prdownloads.sourceforge.net/gqview
GQVIEW_AUTORECONF = NO
GQVIEW_INSTALL_STAGING = NO
GQVIEW_INSTALL_TARGET = YES

GQVIEW_CONF_OPT = PKG_CONFIG_PATH=$(STAGING_DIR)/usr/lib/pkgconfig

GQVIEW_DEPENDENCIES = uclibc libgtk2

$(eval $(call AUTOTARGETS,package,gqview))

