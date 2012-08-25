#############################################################
#
# nbd
#
#############################################################

NBD_VERSION = 3.1
NBD_SOURCE = nbd-$(NBD_VERSION).tar.bz2
NBD_SITE = http://downloads.sourceforge.net/project/nbd/nbd/$(NBD_VERSION)
NBD_CONF_OPT = $(if $(BR2_LARGEFILE),--enable-lfs,--disable-lfs)
NBD_DEPENDENCIES = libglib2

ifeq ($(BR2_TOOLCHAIN_BUILDROOT)$(BR2_TOOLCHAIN_EXTERNAL_UCLIBC)$(BR2_TOOLCHAIN_CTNG_uClibc),y)
# We have linux/falloc.h
# but uClibc lacks fallocate(2) which is a glibc-ism
NBD_CONF_ENV = ac_cv_header_linux_falloc_h=no
endif

ifneq ($(BR2_NBD_CLIENT),y)
	NBD_TOREMOVE += nbd-client
endif
ifneq ($(BR2_NBD_SERVER),y)
	NBD_TOREMOVE += nbd-server
endif

define NBD_CLEANUP_AFTER_INSTALL
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/, $(NBD_TOREMOVE))
endef

NBD_POST_INSTALL_TARGET_HOOKS += NBD_CLEANUP_AFTER_INSTALL

$(eval $(autotools-package))
