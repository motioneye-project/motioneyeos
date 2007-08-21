#############################################################
#
# alsa-lib
#
#############################################################
ALSA_LIB_VERSION:=1.0.14a
ALSA_LIB_SOURCE:=alsa-lib-$(ALSA_LIB_VERSION).tar.bz2
ALSA_LIB_SITE:=ftp://ftp.alsa-project.org/pub/lib
ALSA_LIB_DIR:=$(BUILD_DIR)/alsa-lib-$(ALSA_LIB_VERSION)
ALSA_LIB_CAT:=$(BZCAT)
ALSA_LIB_BINARY:=libasound.so.2.0.0
ALSA_LIB_TARGET_BINARY:=usr/lib/$(ALSA_LIB_BINARY)

$(DL_DIR)/$(ALSA_LIB_SOURCE):
	$(WGET) -P $(DL_DIR) $(ALSA_LIB_SITE)/$(ALSA_LIB_SOURCE)

$(ALSA_LIB_DIR)/.unpacked: $(DL_DIR)/$(ALSA_LIB_SOURCE)
	$(ALSA_LIB_CAT) $(DL_DIR)/$(ALSA_LIB_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(ALSA_LIB_DIR) package/alsa-lib/ alsa-lib-$(ALSA_LIB_VERSION)\*.patch*
	$(CONFIG_UPDATE) $(ALSA_LIB_DIR)
	touch $@

$(ALSA_LIB_DIR)/.configured: $(ALSA_LIB_DIR)/.unpacked
	(cd $(ALSA_LIB_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--enable-shared \
		--enable-static \
		--disable-docs \
		$(DISABLE_NLS) \
	)
	touch $@

$(ALSA_LIB_DIR)/src/.libs/$(ALSA_LIB_BINARY): $(ALSA_LIB_DIR)/.configured
	$(MAKE) -C $(ALSA_LIB_DIR)
	touch -c $@

$(STAGING_DIR)/$(ALSA_LIB_TARGET_BINARY): $(ALSA_LIB_DIR)/src/.libs/$(ALSA_LIB_BINARY)
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(ALSA_LIB_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libasound.la

$(TARGET_DIR)/$(ALSA_LIB_TARGET_BINARY): $(STAGING_DIR)/$(ALSA_LIB_TARGET_BINARY)
	mkdir -p $(TARGET_DIR)/usr/share/alsa
	mkdir -p $(TARGET_DIR)/usr/lib/alsa-lib
	cp -dpf  $(STAGING_DIR)/lib/libasound.so*  $(TARGET_DIR)/usr/lib/
	cp -rdpf $(STAGING_DIR)/usr/share/alsa/*   $(TARGET_DIR)/usr/share/alsa/
	cp -rdpf $(STAGING_DIR)/usr/lib/alsa-lib/* $(TARGET_DIR)/usr/lib/alsa-lib/
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libasound.so*
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/alsa-lib/*.so
	touch -c $@

alsa-lib: uclibc $(TARGET_DIR)/$(ALSA_LIB_TARGET_BINARY)

alsa-lib-clean:
	rm -f $(TARGET_DIR)/$(ALSA_LIB_TARGET_BINARY)
	-$(MAKE) -C $(ALSA_LIB_DIR) clean

alsa-lib-dirclean:
	rm -rf $(ALSA_LIB_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_ALSA_LIB)),y)
TARGETS+=alsa-lib
endif
