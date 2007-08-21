#############################################################
#
# nbd (client only)
#
#############################################################

NBD_VERSION=2.8.6
NBD_SOURCE=nbd-$(NBD_VERSION).tar.bz2
NBD_CAT:=$(BZCAT)
NBD_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/nbd/
NBD_DIR=$(BUILD_DIR)/nbd-$(NBD_VERSION)

$(DL_DIR)/$(NBD_SOURCE):
	$(WGET) -P $(DL_DIR) $(NBD_SITE)/$(NBD_SOURCE)

$(NBD_DIR)/.unpacked: $(DL_DIR)/$(NBD_SOURCE)
	$(NBD_CAT) $(DL_DIR)/$(NBD_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(NBD_DIR)/.unpacked

$(NBD_DIR)/.configured: $(NBD_DIR)/.unpacked
	(cd $(NBD_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CC=$(TARGET_CC) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
	)
	touch $(NBD_DIR)/.configured

$(NBD_DIR)/nbd-client: $(NBD_DIR)/.configured
	$(MAKE) -C $(NBD_DIR) nbd-client

$(TARGET_DIR)/sbin/nbd-client: $(NBD_DIR)/nbd-client
	cp $< $@
	$(STRIP) $@

nbd: uclibc $(TARGET_DIR)/sbin/nbd-client

nbd-source: $(DL_DIR)/$(NBD_SOURCE)

nbd-clean:
	@if [ -d $(NBD_DIR)/Makefile ] ; then \
		$(MAKE) -C $(NBD_DIR) clean ; \
	fi

nbd-dirclean:
	rm -rf $(NBD_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_NBD)),y)
TARGETS+=nbd
endif
