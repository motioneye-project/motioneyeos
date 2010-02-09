#############################################################
#
# nbd
#
#############################################################

NBD_VERSION = 2.9.11
NBD_SOURCE = nbd-$(NBD_VERSION).tar.bz2
NBD_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/nbd/
NBD_CONF_OPT = $(if $(BR2_LARGEFILE),--enable-lfs,--disable-lfs)
NBD_DEPENDENCIES = libglib2

$(eval $(call AUTOTARGETS,package,nbd))

$(NBD_HOOK_POST_INSTALL): $(NBD_TARGET_INSTALL_TARGET)
ifneq ($(BR2_NBD_CLIENT),y)
	rm -f $(TARGET_DIR)/usr/sbin/nbd-client
endif
ifneq ($(BR2_NBD_SERVER),y)
	rm -f $(TARGET_DIR)/usr/bin/nbd-server
endif
	touch $@
