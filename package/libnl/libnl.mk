################################################################################
#
# libnl
#
################################################################################

LIBNL_VERSION = 3.2.24
LIBNL_SITE = http://www.infradead.org/~tgr/libnl/files
LIBNL_LICENSE = LGPLv2.1+
LIBNL_LICENSE_FILES = COPYING
LIBNL_INSTALL_STAGING = YES
LIBNL_DEPENDENCIES = host-bison host-flex

ifeq ($(BR2_PACKAGE_LIBNL_TOOLS),y)
LIBNL_CONF_OPT += --enable-cli
else
LIBNL_CONF_OPT += --disable-cli
endif

$(eval $(autotools-package))
