################################################################################
#
# libupnpp
#
################################################################################

LIBUPNPP_VERSION = 0.15.3
LIBUPNPP_SITE = http://www.lesbonscomptes.com/upmpdcli/downloads
LIBUPNPP_LICENSE = GPL-2.0+
LIBUPNPP_LICENSE_FILES = COPYING
LIBUPNPP_INSTALL_STAGING = YES
LIBUPNPP_DEPENDENCIES = expat libcurl libupnp

# configure script fails to link against the dependencies of libupnp
# and libcurl causing detection to fail when statically linking
ifeq ($(BR2_STATIC_LIBS),y)
LIBUPNPP_DEPENDENCIES += host-pkgconf
LIBUPNPP_CONF_ENV += \
	LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs libupnp libcurl`"
endif

$(eval $(autotools-package))
