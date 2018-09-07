################################################################################
#
# libminiupnpc
#
################################################################################

LIBMINIUPNPC_VERSION = 2.1
LIBMINIUPNPC_SOURCE = miniupnpc-$(LIBMINIUPNPC_VERSION).tar.gz
LIBMINIUPNPC_SITE = http://miniupnp.free.fr/files
LIBMINIUPNPC_INSTALL_STAGING = YES
LIBMINIUPNPC_LICENSE = BSD-3-Clause
LIBMINIUPNPC_LICENSE_FILES = LICENSE

$(eval $(cmake-package))
