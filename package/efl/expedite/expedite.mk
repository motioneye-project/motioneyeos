################################################################################
#
# expedite
#
################################################################################

EXPEDITE_VERSION = 1.7.10
EXPEDITE_SITE = http://download.enlightenment.org/releases
EXPEDITE_LICENSE = BSD-2c
EXPEDITE_LICENSE_FILES = COPYING

EXPEDITE_DEPENDENCIES = libevas libeina libeet

ifeq ($(BR2_PACKAGE_LIBEVAS_X11),y)
EXPEDITE_CONF_OPTS += --with-x=$(STAGING_DIR) \
	--x-includes=$(STAGING_DIR)/usr/include \
	--x-libraries=$(STAGING_DIR)/usr/lib
endif

$(eval $(autotools-package))
