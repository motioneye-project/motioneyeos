#############################################################
#
# libbeecrypt
#
#############################################################
LIBBEECRYPT_VERSION:=4.1.2
LIBBEECRYPT_SOURCE:=beecrypt-$(LIBBEECRYPT_VERSION).tar.gz
LIBBEECRYPT_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/beecrypt
LIBBEECRYPT_DIR:=$(BUILD_DIR)/beecrypt-$(LIBBEECRYPT_VERSION)
LIBBEECRYPT_CAT:=$(ZCAT)

$(DL_DIR)/$(LIBBEECRYPT_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBBEECRYPT_SITE)/$(LIBBEECRYPT_SOURCE)

libbeecrypt-source: $(DL_DIR)/$(LIBBEECRYPT_SOURCE)

$(LIBBEECRYPT_DIR)/.unpacked: $(DL_DIR)/$(LIBBEECRYPT_SOURCE)
	$(LIBBEECRYPT_CAT) $(DL_DIR)/$(LIBBEECRYPT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBBEECRYPT_DIR) package/libbeecrypt/ beecrypt\*.patch
	touch $@

$(LIBBEECRYPT_DIR)/.configured: $(LIBBEECRYPT_DIR)/.unpacked
	(cd $(LIBBEECRYPT_DIR); rm -rf config.cache; \
		autoreconf; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=$(STAGING_DIR)/usr \
		--exec_prefix=$(STAGING_DIR) \
		--libdir=$(STAGING_DIR)/usr/lib \
		--includedir=$(STAGING_DIR)/usr/include \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--without-cplusplus \
		--without-java \
		--without-python \
		$(DISABLE_NLS) \
	)
	touch $@

$(LIBBEECRYPT_DIR)/.libs/libbeecrypt.so: $(LIBBEECRYPT_DIR)/.configured
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(LIBBEECRYPT_DIR)

$(STAGING_DIR)/usr/lib/libbeecrypt.so: $(LIBBEECRYPT_DIR)/.libs/libbeecrypt.so
	$(MAKE) -C $(LIBBEECRYPT_DIR) install

$(TARGET_DIR)/usr/lib/libbeecrypt.so: $(STAGING_DIR)/usr/lib/libbeecrypt.so
	cp -dpf $(STAGING_DIR)/usr/lib/libbeecrypt.so* $(TARGET_DIR)/usr/lib/

libbeecrypt: uclibc $(TARGET_DIR)/usr/lib/libbeecrypt.so

libbeecrypt-clean:
	rm -f $(TARGET_DIR)/usr/lib/libbeecrypt.so*
	-$(MAKE) -C $(LIBBEECRYPT_DIR) clean

libbeecrypt-dirclean:
	rm -rf $(LIBBEECRYPT_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBBEECRYPT)),y)
TARGETS+=libbeecrypt
endif
