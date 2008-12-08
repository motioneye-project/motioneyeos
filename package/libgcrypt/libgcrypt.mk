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
LIBGCRYPT_DESTDIR:=usr/lib
LIBGCRYPT_TARGET_LIBRARY=$(LIBGCRYPT_DESTDIR)/libgcrypt.so

$(DL_DIR)/$(LIBGCRYPT_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBGCRYPT_SITE)/$(LIBGCRYPT_SOURCE)

$(LIBGCRYPT_DIR)/.source: $(DL_DIR)/$(LIBGCRYPT_SOURCE)
	$(BZCAT) $(DL_DIR)/$(LIBGCRYPT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBGCRYPT_DIR) package/libgcrypt/ libgcrypt\*.patch
	$(CONFIG_UPDATE) $(LIBGCRYPT_DIR)
	# This is incorrectly hardwired to yes for cross-compiles with no
	# sane way to pass pre-existing knowledge so fix it with the chainsaw..
	$(SED) '/GNUPG_SYS_SYMBOL_UNDERSCORE/d' $(LIBGCRYPT_DIR)/configure
	touch $@

$(LIBGCRYPT_DIR)/.configured: $(LIBGCRYPT_DIR)/.source
	(cd $(LIBGCRYPT_DIR); rm -f config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		ac_cv_sys_symbol_underscore=no \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/usr/lib \
		--libexecdir=/$(LIBGCRYPT_DESTDIR) \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/usr/include \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--disable-optimization \
	)
	touch $@

$(LIBGCRYPT_DIR)/$(LIBGCRYPT_LIBRARY): $(LIBGCRYPT_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(LIBGCRYPT_DIR)

$(STAGING_DIR)/$(LIBGCRYPT_TARGET_LIBRARY): $(LIBGCRYPT_DIR)/$(LIBGCRYPT_LIBRARY)
	$(MAKE) $(TARGET_CONFIGURE_OPTS) DESTDIR=$(STAGING_DIR) -C $(LIBGCRYPT_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libgcrypt.la
	touch -c $@

$(TARGET_DIR)/$(LIBGCRYPT_TARGET_LIBRARY): $(STAGING_DIR)/$(LIBGCRYPT_TARGET_LIBRARY)
	cp -dpf $<* $(TARGET_DIR)/$(LIBGCRYPT_DESTDIR)
ifneq ($(BR2_HAVE_INFOPAGES),y)
	rm -rf $(STAGING_DIR)/usr/share/info
endif

libgcrypt: uclibc libgpg-error $(TARGET_DIR)/$(LIBGCRYPT_TARGET_LIBRARY)

libgcrypt-source: $(DL_DIR)/$(LIBGCRYPT_SOURCE)

libgcrypt-clean:
	rm -f $(TARGET_DIR)/$(LIBGCRYPT_TARGET_LIBRARY)*
	-$(MAKE) -C $(LIBGCRYPT_DIR) clean
	rm -rf $(STAGING_DIR)/$(LIBGCRYPT_TARGET_LIBRARY)\*

libgcrypt-dirclean:
	rm -rf $(LIBGCRYPT_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
TARGETS+=libgcrypt
endif
