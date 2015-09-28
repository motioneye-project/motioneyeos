################################################################################
#
# ibrdtn
#
################################################################################

IBRDTN_VERSION = 1.0.1
IBRDTN_SOURCE = ibrdtn-$(IBRDTN_VERSION).tar.gz
IBRDTN_SITE = https://www.ibr.cs.tu-bs.de/projects/ibr-dtn/releases
IBRDTN_INSTALL_STAGING = YES
IBRDTN_LICENSE = Apache-2.0
IBRDTN_LICENSE_FILES = COPYING
IBRDTN_DEPENDENCIES = ibrcommon host-pkgconf

ifeq ($(BR2_PACKAGE_ZLIB),y)
IBRDTN_CONF_OPTS += --with-compression
IBRDTN_DEPENDENCIES += zlib
else
IBRDTN_CONF_OPTS += --without-compression
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
IBRDTN_CONF_OPTS += --with-glib
IBRDTN_DEPENDENCIES += libglib2
else
IBRDTN_CONF_OPTS += --without-glib
endif

$(eval $(autotools-package))
