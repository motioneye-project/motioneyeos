################################################################################
#
# ibrdtn-tools
#
################################################################################

IBRDTN_TOOLS_VERSION = 1.0.1
IBRDTN_TOOLS_SITE = https://www.ibr.cs.tu-bs.de/projects/ibr-dtn/releases
IBRDTN_TOOLS_LICENSE = Apache-2.0
IBRDTN_TOOLS_LICENSE_FILES = COPYING
IBRDTN_TOOLS_DEPENDENCIES = ibrcommon ibrdtn host-pkgconf

ifeq ($(BR2_STATIC_LIBS),y)
IBRDTN_TOOLS_CONF_ENV += LDFLAGS="$(TARGET_LDFLAGS) -pthread"
endif

ifeq ($(BR2_PACKAGE_LIBDAEMON),y)
IBRDTN_TOOLS_CONF_OPTS += --with-libdaemon
IBRDTN_TOOLS_DEPENDENCIES += libdaemon
else
IBRDTN_TOOLS_CONF_OPTS += --without-libdaemon
endif

ifeq ($(BR2_PACKAGE_LIBARCHIVE),y)
IBRDTN_TOOLS_CONF_OPTS += --with-libarchive
IBRDTN_TOOLS_DEPENDENCIES += libarchive
else
IBRDTN_TOOLS_CONF_OPTS += --without-libarchive
endif

$(eval $(autotools-package))
