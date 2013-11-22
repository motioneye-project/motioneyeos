################################################################################
#
# openssl
#
################################################################################

OPENSSL_VERSION = 1.0.1e
OPENSSL_SITE = http://www.openssl.org/source
OPENSSL_LICENSE = OpenSSL or SSLeay
OPENSSL_LICENSE_FILES = LICENSE
OPENSSL_INSTALL_STAGING = YES
OPENSSL_DEPENDENCIES = zlib
HOST_OPENSSL_DEPENDENCIES = host-zlib
OPENSSL_TARGET_ARCH = generic32
OPENSSL_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_PACKAGE_OPENSSL_BIN),)
define OPENSSL_DISABLE_APPS
	$(SED) '/^build_apps/! s/build_apps//' $(@D)/Makefile.org
	$(SED) '/^DIRS=/ s/apps//' $(@D)/Makefile.org
endef
endif

OPENSSL_PRE_CONFIGURE_HOOKS += OPENSSL_DISABLE_APPS

ifeq ($(BR2_PACKAGE_CRYPTODEV_LINUX),y)
	OPENSSL_CFLAGS += -DHAVE_CRYPTODEV -DUSE_CRYPTODEV_DIGESTS
	OPENSSL_DEPENDENCIES += cryptodev-linux
endif

ifeq ($(BR2_PACKAGE_OCF_LINUX),y)
	OPENSSL_CFLAGS += -DHAVE_CRYPTODEV -DUSE_CRYPTODEV_DIGESTS
	OPENSSL_DEPENDENCIES += ocf-linux
endif

# Some architectures are optimized in OpenSSL
ifeq ($(ARCH),arm)
	OPENSSL_TARGET_ARCH = armv4
endif
ifeq ($(ARCH),powerpc)
# 4xx cores seem to have trouble with openssl's ASM optimizations
ifeq ($(BR2_powerpc_401)$(BR2_powerpc_403)$(BR2_powerpc_405)$(BR2_powerpc_405fp)$(BR2_powerpc_440)$(BR2_powerpc_440fp),)
	OPENSSL_TARGET_ARCH = ppc
endif
endif
ifeq ($(ARCH),x86_64)
	OPENSSL_TARGET_ARCH = x86_64
endif

# Workaround for bug #3445
ifeq ($(BR2_x86_i386),y)
	OPENSSL_TARGET_ARCH = generic32 386
endif

define HOST_OPENSSL_CONFIGURE_CMDS
	(cd $(@D); \
		$(HOST_CONFIGURE_OPTS) \
		./config \
		--prefix=/usr \
		--openssldir=/etc/ssl \
		--libdir=/lib \
		shared \
		no-zlib \
	)
endef

define OPENSSL_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		./Configure \
			linux-$(OPENSSL_TARGET_ARCH) \
			--prefix=/usr \
			--openssldir=/etc/ssl \
			--libdir=/lib \
			$(if $(BR2_TOOLCHAIN_HAS_THREADS),threads,no-threads) \
			$(if $(BR2_PREFER_STATIC_LIB),no-shared,shared) \
			no-idea \
			no-rc5 \
			enable-camellia \
			enable-mdc2 \
			enable-tlsext \
			$(if $(BR2_PREFER_STATIC_LIB),zlib,zlib-dynamic) \
			$(if $(BR2_PREFER_STATIC_LIB),no-dso) \
	)
	$(SED) "s:-march=[-a-z0-9] ::" -e "s:-mcpu=[-a-z0-9] ::g" $(@D)/Makefile
	$(SED) "s:-O[0-9]:$(OPENSSL_CFLAGS):" $(@D)/Makefile
	$(SED) "s: build_tests::" $(@D)/Makefile
endef

define HOST_OPENSSL_BUILD_CMDS
	$(MAKE1) -C $(@D)
endef

define OPENSSL_BUILD_CMDS
	$(MAKE1) -C $(@D)
endef

define OPENSSL_INSTALL_STAGING_CMDS
	$(MAKE1) -C $(@D) INSTALL_PREFIX=$(STAGING_DIR) install
endef

define HOST_OPENSSL_INSTALL_CMDS
	$(MAKE1) -C $(@D) INSTALL_PREFIX=$(HOST_DIR) install
endef

define OPENSSL_INSTALL_TARGET_CMDS
	$(MAKE1) -C $(@D) INSTALL_PREFIX=$(TARGET_DIR) install
	rm -rf $(TARGET_DIR)/usr/lib/ssl
	rm -f $(TARGET_DIR)/usr/bin/c_rehash
endef

ifneq ($(BR2_PREFER_STATIC_LIB),y)

# libraries gets installed read only, so strip fails
define OPENSSL_INSTALL_FIXUPS_SHARED
	chmod +w $(TARGET_DIR)/usr/lib/engines/lib*.so
	for i in $(addprefix $(TARGET_DIR)/usr/lib/,libcrypto.so.* libssl.so.*); \
	do chmod +w $$i; done
endef

OPENSSL_POST_INSTALL_TARGET_HOOKS += OPENSSL_INSTALL_FIXUPS_SHARED

endif

define OPENSSL_REMOVE_OPENSSL_ENGINES
	rm -rf $(TARGET_DIR)/usr/lib/engines
endef

ifneq ($(BR2_PACKAGE_OPENSSL_ENGINES),y)
OPENSSL_POST_INSTALL_TARGET_HOOKS += OPENSSL_REMOVE_OPENSSL_ENGINES
endif

define OPENSSL_UNINSTALL_CMDS
	rm -rf $(addprefix $(TARGET_DIR)/,etc/ssl usr/bin/openssl usr/include/openssl)
	rm -rf $(addprefix $(TARGET_DIR)/usr/lib/,ssl engines libcrypto* libssl* pkgconfig/libcrypto.pc)
	rm -rf $(addprefix $(STAGING_DIR)/,etc/ssl usr/bin/openssl usr/include/openssl)
	rm -rf $(addprefix $(STAGING_DIR)/usr/lib/,ssl engines libcrypto* libssl* pkgconfig/libcrypto.pc)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
