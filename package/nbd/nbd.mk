#############################################################
#
# nbd
#
#############################################################

NBD_VERSION = 2.9.15
NBD_SOURCE = nbd-$(NBD_VERSION).tar.bz2
NBD_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/nbd/
NBD_CONF_OPT = $(if $(BR2_LARGEFILE),--enable-lfs,--disable-lfs)
NBD_DEPENDENCIES = libglib2

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

$(eval $(call AUTOTARGETS,package,nbd))
