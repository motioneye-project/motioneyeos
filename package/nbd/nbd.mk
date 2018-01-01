################################################################################
#
# nbd
#
################################################################################

NBD_VERSION = 3.15.2
NBD_SOURCE = nbd-$(NBD_VERSION).tar.xz
NBD_SITE = http://downloads.sourceforge.net/project/nbd/nbd/$(NBD_VERSION)
NBD_CONF_OPTS = --enable-lfs
NBD_DEPENDENCIES = libglib2
NBD_LICENSE = GPL-2.0
NBD_LICENSE_FILES = COPYING

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
# We have linux/falloc.h
# but uClibc lacks fallocate(2) which is a glibc-ism
NBD_CONF_ENV = ac_cv_header_linux_falloc_h=no
endif

ifneq ($(BR2_PACKAGE_NBD_CLIENT),y)
NBD_TOREMOVE += /usr/sbin/nbd-client
endif
ifneq ($(BR2_PACKAGE_NBD_SERVER),y)
NBD_TOREMOVE += /usr/bin/nbd-server
endif
ifneq ($(BR2_PACKAGE_NBD_TRDUMP),y)
NBD_TOREMOVE += /usr/bin/nbd-trdump
endif

define NBD_CLEANUP_AFTER_INSTALL
	rm -f $(addprefix $(TARGET_DIR), $(NBD_TOREMOVE))
endef

NBD_POST_INSTALL_TARGET_HOOKS += NBD_CLEANUP_AFTER_INSTALL

$(eval $(autotools-package))
