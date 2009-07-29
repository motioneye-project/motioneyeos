#############################################################
#
# openssl
#
#############################################################
OPENSSL_VERSION:=0.9.8k
OPENSSL_SITE:=http://www.openssl.org/source

OPENSSL_TARGET_ARCH=generic32

# Some architectures are optimized in OpenSSL
ifeq ($(ARCH),avr32)
OPENSSL_TARGET_ARCH=avr32
endif
ifeq ($(ARCH),ia64)
OPENSSL_TARGET_ARCH=ia64
endif
ifeq ($(ARCH),powerpc)
OPENSSL_TARGET_ARCH=ppc
endif
ifeq ($(ARCH),x86_64)
OPENSSL_TARGET_ARCH=x86_64
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
			--openssldir=/etc/ssl \
			threads \
			shared \
			no-idea \
			no-mdc2 \
			no-rc5 \
			zlib-dynamic \
	)
	$(SED) "s:-march=[-a-z0-9] ::" -e "s:-mcpu=[-a-z0-9] ::g" $(OPENSSL_DIR)/Makefile
	$(SED) "s:-O[0-9]:$(TARGET_CFLAGS):" $(OPENSSL_DIR)/Makefile
	touch $@

$(OPENSSL_TARGET_BUILD):
	$(MAKE1) CC=$(TARGET_CC) -C $(OPENSSL_DIR) all build-shared
	$(MAKE1) CC=$(TARGET_CC) -C $(OPENSSL_DIR) do_linux-shared
	touch $@

$(OPENSSL_HOOK_POST_INSTALL):
	$(if $(BR2_HAVE_DEVFILES),,rm -rf $(TARGET_DIR)/usr/lib/ssl)
ifeq ($(BR2_PACKAGE_OPENSSL_BIN),y)
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/usr/bin/openssl
else
	rm -f $(TARGET_DIR)/usr/bin/openssl
endif
	rm -f $(TARGET_DIR)/usr/bin/c_rehash
	# libraries gets installed read only, so strip fails
	for i in $(addprefix $(TARGET_DIR)/usr/lib/,libcrypto.so.* libssl.so.*); \
	do chmod +w $$i; $(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $$i; done
ifneq ($(BR2_PACKAGE_OPENSSL_ENGINES),y)
	rm -rf $(TARGET_DIR)/usr/lib/engines
else
	chmod +w $(TARGET_DIR)/usr/lib/engines/lib*.so
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/engines/lib*.so
endif
	touch $@

$(OPENSSL_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -rf $(addprefix $(TARGET_DIR)/,etc/ssl usr/bin/openssl usr/include/openssl)
	rm -rf $(addprefix $(TARGET_DIR)/usr/lib/,ssl engines libcrypto* libssl* pkgconfig/libcrypto.pc)
	rm -rf $(addprefix $(STAGING_DIR)/,etc/ssl usr/bin/openssl usr/include/openssl)
	rm -rf $(addprefix $(STAGING_DIR)/usr/lib/,ssl engines libcrypto* libssl* pkgconfig/libcrypto.pc)
	rm -f $(OPENSSL_TARGET_INSTALL_TARGET) $(OPENSSL_HOOK_POST_INSTALL)
