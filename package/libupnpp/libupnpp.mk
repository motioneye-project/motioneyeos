################################################################################
#
# libupnpp
#
################################################################################

LIBUPNPP_VERSION = 0.17.2
LIBUPNPP_SITE = http://www.lesbonscomptes.com/upmpdcli/downloads
LIBUPNPP_LICENSE = LGPL-2.1+
LIBUPNPP_LICENSE_FILES = COPYING
LIBUPNPP_INSTALL_STAGING = YES
LIBUPNPP_DEPENDENCIES = host-pkgconf expat libcurl \
	$(if $(BR2_PACKAGE_LIBUPNP),libupnp,libupnp18)

$(eval $(autotools-package))
