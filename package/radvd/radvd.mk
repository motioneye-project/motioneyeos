################################################################################
#
# radvd
#
################################################################################

RADVD_VERSION = 1.13
RADVD_SOURCE = radvd-$(RADVD_VERSION).tar.xz
RADVD_SITE = http://www.litech.org/radvd/dist
RADVD_DEPENDENCIES = host-bison flex libdaemon host-flex host-pkgconf
# clock_gettime() requires -lrt when linking against glibc older than 2.17
RADVD_CONF_ENV = LIBS=-lrt

define RADVD_INSTALL_INITSCRIPT
	$(INSTALL) -m 0755 package/radvd/S50radvd $(TARGET_DIR)/etc/init.d
endef

RADVD_POST_INSTALL_TARGET_HOOKS += RADVD_INSTALL_INITSCRIPT

$(eval $(autotools-package))
