#############################################################
#
# ICU International Components for Unicode
#
#############################################################

ICU_VERSION:=4c-3_8_1
ICU_SOURCE:=icu$(ICU_VERSION)-src.tgz
ICU_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/icu
ICU_CAT:=$(ZCAT)
ICU_DIR:=$(BUILD_DIR)/icu/source
ICU_HOST_DIR:=$(BUILD_DIR)/icu-host/source

$(DL_DIR)/$(ICU_SOURCE):
	 $(WGET) -P $(DL_DIR) $(ICU_SITE)/$(ICU_SOURCE)

icu-source: $(DL_DIR)/$(ICU_SOURCE)

$(ICU_DIR)/.unpacked: $(DL_DIR)/$(ICU_SOURCE)
	$(ICU_CAT) $(DL_DIR)/$(ICU_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(ICU_DIR)
	cp -a $(BUILD_DIR)/icu $(BUILD_DIR)/icu-host
	toolchain/patch-kernel.sh $(ICU_DIR) package/icu/ \*.patch
	touch $(ICU_DIR)/.unpacked

$(ICU_HOST_DIR)/.configured: $(ICU_DIR)/.unpacked
	(cd $(ICU_HOST_DIR); ./configure \
		--prefix=/usr;);
	touch $(ICU_HOST_DIR)/.configured

$(ICU_DIR)/.configured: $(ICU_HOST_DIR)/.configured
	(cd $(ICU_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CXX=$(TARGET_CXX) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--enable-samples \
	);
	touch $(ICU_DIR)/.configured

$(ICU_HOST_DIR)/.done: $(ICU_DIR)/.configured
	$(MAKE) -C $(ICU_HOST_DIR)
	ln -s -f $(ICU_HOST_DIR)/bin $(ICU_DIR)/bin-host
	ln -s -f $(ICU_HOST_DIR)/lib $(ICU_DIR)/lib-host
	touch $(ICU_HOST_DIR)/.done

$(ICU_DIR)/.done: $(ICU_HOST_DIR)/.done
	$(MAKE) -C $(ICU_DIR) 
	$(MAKE) -C $(ICU_DIR) install DESTDIR=$(STAGING_DIR)
	$(MAKE) -C $(ICU_DIR) install DESTDIR=$(TARGET_DIR)
	$(SED) "s,^default_prefix=.*,default_prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/icu-config
	touch $(ICU_DIR)/.done

icu: uclibc $(ICU_DIR)/.done

icu-clean:
	rm -f $(TARGET_DIR)/bin/icu
	-$(MAKE) -C $(ICU_DIR) clean

icu-dirclean:
	rm -rf $(ICU_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_ICU)),y)
TARGETS+=icu
endif
