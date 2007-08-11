#############################################################
#
# libgcrypt
#
#############################################################
LIBGCRYPT_VERSION:=1.2.4
LIBGCRYPT_SOURCE:=libgcrypt-$(LIBGCRYPT_VERSION).tar.bz2
LIBGCRYPT_SITE:=ftp://gd.tuwien.ac.at/privacy/gnupg/libgcrypt/
LIBGCRYPT_DIR:=$(BUILD_DIR)/libgcrypt-$(LIBGCRYPT_VERSION)
LIBGCRYPT_LIBRARY:=src/libgcrypt.la
LIBGCRYPT_DESTDIR:=lib
LIBGCRYPT_TARGET_LIBRARY=$(LIBGCRYPT_DESTDIR)/libgcrypt.so

$(DL_DIR)/$(LIBGCRYPT_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBGCRYPT_SITE)/$(LIBGCRYPT_SOURCE)

$(LIBGCRYPT_DIR)/.source: $(DL_DIR)/$(LIBGCRYPT_SOURCE)
	$(BZCAT) $(DL_DIR)/$(LIBGCRYPT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBGCRYPT_DIR) package/libgcrypt/ libgcrypt\*.patch
	$(CONFIG_UPDATE) $(LIBGCRYPT_DIR)
	touch $@

$(LIBGCRYPT_DIR)/.configured: $(LIBGCRYPT_DIR)/.source
	(cd $(LIBGCRYPT_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
			--target=$(GNU_TARGET_NAME) \
			--host=$(GNU_TARGET_NAME) \
			--build=$(GNU_HOST_NAME) \
			--prefix=/usr \
			--exec-prefix=/usr \
			--bindir=/usr/bin \
			--sbindir=/usr/sbin \
			--libdir=/lib \
			--libexecdir=/$(LIBGCRYPT_DESTDIR) \
			--sysconfdir=/etc \
			--datadir=/usr/share \
			--localstatedir=/var \
			--includedir=/include \
			--includedir=/usr/include \
			--mandir=/usr/man \
			--infodir=/usr/info \
	);
	touch $@

$(LIBGCRYPT_DIR)/$(LIBGCRYPT_LIBRARY): $(LIBGCRYPT_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(LIBGCRYPT_DIR)

$(STAGING_DIR)/$(LIBGCRYPT_TARGET_LIBRARY): $(LIBGCRYPT_DIR)/$(LIBGCRYPT_LIBRARY)
	$(MAKE) $(TARGET_CONFIGURE_OPTS) DESTDIR=$(STAGING_DIR) -C $(LIBGCRYPT_DIR) install
	touch -c $@

$(TARGET_DIR)/$(LIBGCRYPT_TARGET_LIBRARY): $(STAGING_DIR)/$(LIBGCRYPT_TARGET_LIBRARY)
	cp -dpf $<* $(TARGET_DIR)/$(LIBGCRYPT_DESTDIR)

libgcrypt: uclibc libgpg-error $(TARGET_DIR)/$(LIBGCRYPT_TARGET_LIBRARY)

libgcrypt-source: $(DL_DIR)/$(LIBGCRYPT_SOURCE)

libgcrypt-clean:
	rm -f $(TARGET_DIR)/$(LIBGCRYPT_TARGET_LIBRARY)*
	-$(MAKE) -C $(LIBGCRYPT_DIR) clean

libgcrypt-dirclean:
	rm -rf $(LIBGCRYPT_DIR)

.PHONY:	libgcrypt
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBGCRYPT)),y)
TARGETS+=libgcrypt
endif
