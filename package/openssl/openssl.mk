#############################################################
#
# openssl
#
#############################################################
OPENSSL_VERSION:=0.9.8g
OPENSSL_SITE:=http://www.openssl.org/source

OPENSSL_TARGET_ARCH:=
ifeq ($(BR2_i386),y)
ifneq ($(ARCH),i386)
OPENSSL_TARGET_ARCH:=i386-$(ARCH)
endif
ifeq ($(ARCH),i686)
OPENSSL_TARGET_ARCH:=i386-i686/cmov
endif
endif
ifeq ($(OPENSSL_TARGET_ARCH),)
OPENSSL_TARGET_ARCH:=$(ARCH)
endif

OPENSSL_INSTALL_STAGING = YES
OPENSSL_INSTALL_STAGING_OPT = INSTALL_PREFIX=$(STAGING_DIR) install

OPENSSL_INSTALL_TARGET_OPT = INSTALL_PREFIX=$(TARGET_DIR) install

OPENSSL_DEPENDENCIES = zlib

$(eval $(call AUTOTARGETS,package,openssl))

$(OPENSSL_TARGET_CONFIGURE):
	(cd $(OPENSSL_DIR); \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		./Configure \
			linux-$(OPENSSL_TARGET_ARCH) \
			--prefix=/usr \
			--openssldir=/usr/lib/ssl \
			threads \
			shared \
			no-idea \
			no-mdc2 \
			no-rc5 \
			zlib-dynamic \
	)
	touch $@

$(OPENSSL_TARGET_BUILD):
	$(MAKE1) CC=$(TARGET_CC) -C $(OPENSSL_DIR) all build-shared
	$(MAKE1) CC=$(TARGET_CC) -C $(OPENSSL_DIR) do_linux-shared
	touch $@

$(OPENSSL_HOOK_POST_INSTALL):
	$(if $(BR2_HAVE_DEVFILES),,rm -rf $(TARGET_DIR)/usr/lib/ssl)
ifeq ($(BR2_PACKAGE_OPENSSL_BIN),y)
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/openssl
else
	rm -f $(TARGET_DIR)/usr/bin/c_rehash
	rm -f $(TARGET_DIR)/usr/bin/openssl
endif
ifneq ($(BR2_PACKAGE_OPENSSL_ENGINES),y)
	rm -rf $(TARGET_DIR)/usr/lib/engines
endif
	touch $@
