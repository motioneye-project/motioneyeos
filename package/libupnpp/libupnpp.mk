################################################################################
#
# libupnpp
#
################################################################################

LIBUPNPP_VERSION = 0.8.6
LIBUPNPP_SITE = http://www.lesbonscomptes.com/upmpdcli/downloads
LIBUPNPP_LICENSE = GPLv2+
LIBUPNPP_LICENSE_FILES = COPYING
LIBUPNPP_INSTALL_STAGING = YES
LIBUPNPP_DEPENDENCIES = expat libcurl libupnp

# configure script fails to link against the dependencies of libupnp
# causing upnp detection to fail when statically linking
ifeq ($(BR2_STATIC_LIBS),y)
LIBUPNPP_CONF_ENV += LIBS='-lthreadutil -lixml -pthread'
endif

$(eval $(autotools-package))
