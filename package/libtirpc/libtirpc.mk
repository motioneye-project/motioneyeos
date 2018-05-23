################################################################################
#
# libtirpc
#
################################################################################

LIBTIRPC_VERSION = 1.0.2
LIBTIRPC_SOURCE = libtirpc-$(LIBTIRPC_VERSION).tar.bz2
LIBTIRPC_SITE = http://downloads.sourceforge.net/project/libtirpc/libtirpc/$(LIBTIRPC_VERSION)
LIBTIRPC_LICENSE = BSD-3-Clause
LIBTIRPC_LICENSE_FILES = COPYING

LIBTIRPC_DEPENDENCIES = host-nfs-utils
LIBTIRPC_INSTALL_STAGING = YES
LIBTIRPC_AUTORECONF = YES

# getrpcby{number,name} are only provided if 'GQ' is defined
LIBTIRPC_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -DGQ"

LIBTIRPC_CONF_OPTS = --disable-gssapi

define HOST_LIBTIRPC_INSTALL_CMDS
	$(INSTALL) -D -m 0644 $(@D)/tirpc/rpc/types.h $(HOST_DIR)/include/rpc/types.h
	$(INSTALL) -D -m 0644 $(@D)/tirpc/netconfig.h $(HOST_DIR)/include/netconfig.h
endef

$(eval $(autotools-package))
# We are only copying headers; no need for the autotools infrastructure
$(eval $(host-generic-package))
