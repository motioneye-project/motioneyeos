################################################################################
#
# radvd
#
################################################################################

RADVD_VERSION = 2.12
RADVD_SOURCE = radvd-$(RADVD_VERSION).tar.xz
RADVD_SITE = http://www.litech.org/radvd/dist
RADVD_DEPENDENCIES = host-bison flex host-flex host-pkgconf
# We need to ignore <linux/if_arp.h>, because radvd already includes
# <net/if_arp.h>, which conflicts with <linux/if_arp.h>.
RADVD_CONF_ENV = \
	ac_cv_prog_cc_c99='-std=gnu99' \
	ac_cv_header_linux_if_arp_h=no
# For 0002-Don-t-force-fstack-protector-the-toolchain-might-lac.patch
RADVD_AUTORECONF = YES
RADVD_LICENSE = BSD-4-Clause-like
RADVD_LICENSE_FILES = COPYRIGHT

define RADVD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/radvd/S50radvd $(TARGET_DIR)/etc/init.d/S50radvd
endef

$(eval $(autotools-package))
