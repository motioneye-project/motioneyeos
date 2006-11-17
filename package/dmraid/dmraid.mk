#############################################################
#
# dmraid
#
#############################################################

DMRAID_VERSION=1.0.0.rc11
DMRAID_SOURCE:=dmraid-$(DMRAID_VERSION).tar.bz2
DMRAID_SITE:=http://people.redhat.com/~heinzm/sw/dmraid/src
DMRAID_DIR:=$(BUILD_DIR)/dmraid/$(DMRAID_VERSION)
DMRAID_CAT:=$(BZCAT)
DMRAID_BINARY:=dmraid
DMRAID_STAGING_BINARY:=$(DMRAID_DIR)/STAGING_DIR)/tools/$(DMRAID_BINARY)
DMRAID_TARGET_BINARY:=$(TARGET_DIR)/sbin/$(DMRAID_BINARY)

$(DL_DIR)/$(DMRAID_SOURCE):
	 $(WGET) -P $(DL_DIR) $(DMRAID_SITE)/$(DMRAID_SOURCE)

$(DMRAID_DIR)/.unpacked: $(DL_DIR)/$(DMRAID_SOURCE)
	$(DMRAID_CAT) $(DL_DIR)/$(DMRAID_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(DMRAID_DIR) package/dmraid \*.patch
	touch $(DMRAID_DIR)/.unpacked

$(DMRAID_DIR)/.configured: $(DMRAID_DIR)/.unpacked
	(cd $(DMRAID_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		--with-user=$(shell id -un) --with-group=$(shell id -gn) \
	);
	touch $(DMRAID_DIR)/.configured

$(DMRAID_DIR)/tools/$(DMRAID_BINARY): $(DMRAID_DIR)/.configured
	$(MAKE1) -C $(DMRAID_DIR)
	-$(STRIP) $(DMRAID_DIR)/tools/$(DMRAID_BINARY)
	-$(UPX) --best $(DMRAID_DIR)/tools/$(DMRAID_BINARY)
	touch -c $(DMRAID_DIR)/tools/$(DMRAID_BINARY)

$(DMRAID_TARGET_BINARY): $(DMRAID_DIR)/tools/$(DMRAID_BINARY)
	$(INSTALL) -m 0755 $? $@
	$(INSTALL) -m 0755 package/dmraid/dmraid.init $(TARGET_DIR)/etc/init.d/dmraid

dmraid: uclibc dm $(DMRAID_TARGET_BINARY)

dmraid-clean:
	rm $(DMRAID_TARGET_BINARY)
	$(MAKE) -C $(DMRAID_DIR) clean

dmraid-dirclean:
	rm -rf $(DMRAID_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DMRAID)),y)
TARGETS+=dmraid
endif
