################################################################################
#
# cwiid
#
################################################################################

CWIID_VERSION = fadf11e89b579bcc0336a0692ac15c93785f3f82
CWIID_SITE = $(call github,abstrakraft,cwiid,$(CWIID_VERSION))
CWIID_LICENSE = GPL-2.0+
CWIID_LICENSE_FILES = COPYING

CWIID_AUTORECONF = YES
CWIID_INSTALL_STAGING = YES

CWIID_DEPENDENCIES = host-pkgconf host-bison host-flex bluez_utils

# Disable python support. This disables the 2 following things:
#   - wminput Python plugin support
#   - cwiid Python module
CWIID_CONF_OPTS = --without-python --disable-ldconfig

ifeq ($(BR2_PACKAGE_CWIID_WMGUI),y)
CWIID_DEPENDENCIES += libgtk2 libglib2
CWIID_CONF_OPTS += --enable-wmgui
else
CWIID_CONF_OPTS += --disable-wmgui
endif

$(eval $(autotools-package))
