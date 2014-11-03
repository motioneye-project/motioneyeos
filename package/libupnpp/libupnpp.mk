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

$(eval $(autotools-package))
