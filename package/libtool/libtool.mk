################################################################################
#
# libtool
#
################################################################################

LIBTOOL_VERSION = 2.4.2
LIBTOOL_SOURCE = libtool-$(LIBTOOL_VERSION).tar.xz
LIBTOOL_SITE = $(BR2_GNU_MIRROR)/libtool
LIBTOOL_INSTALL_STAGING = YES
LIBTOOL_LICENSE = GPLv2+
LIBTOOL_LICENSE_FILES = COPYING

HOST_LIBTOOL_LIBTOOL_PATCH = NO

# libtool-mips64-n64-linking.post-install-patch is an upstream patch that
# fixes MIPS64 n64 link failures. However, because the patch touches an m4
# file, applying it triggers a run of autoconf, automake, etc. This sometimes
# leads to build failures due to incompatible system autotools. We cannot
# simply set HOST_LIBTOOL_AUTORECONF = YES because that would create a
# circular dependency on host-libtool. Therefore, just apply the patch
# directly on the installed file.
define HOST_LIBTOOL_FIXUP_LIBTOOL_M4
	patch $(HOST_DIR)/usr/share/aclocal/libtool.m4 < \
		package/libtool/libtool-mips64-n64-linking.post-install-patch
endef
HOST_LIBTOOL_POST_INSTALL_HOOKS += HOST_LIBTOOL_FIXUP_LIBTOOL_M4

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# variables used by other packages
LIBTOOL = $(HOST_DIR)/usr/bin/libtool
LIBTOOLIZE = $(HOST_DIR)/usr/bin/libtoolize
