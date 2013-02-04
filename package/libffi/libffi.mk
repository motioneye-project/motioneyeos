#############################################################
#
# libffi
#
#############################################################

LIBFFI_VERSION = bcc0c28001b6d427d5cd8037d2e3c892babc6b4c
LIBFFI_SITE    = http://github.com/atgreen/libffi/tarball/$(LIBFFI_VERSION)
LIBFFI_LICENSE = MIT
LIBFFI_LICENSE_FILES = LICENSE
LIBFFI_INSTALL_STAGING = YES

# We're using a version from Git which strangely bundles a generated
# configure script, but it's broken (doesn't generate the libffi.pc
# file).
LIBFFI_AUTORECONF = YES

# Newer CS MIPS toolchains use a different (compact) eh_frame format
# libffi don't like them, just switch to the older format
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_MIPS201209)$(BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_MIPS201203),y)
LIBFFI_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -mno-compact-eh"
endif

# Move the headers to the usual location, and adjust the .pc file
# accordingly. For some reason, the libffi build system forgets to
# install the .pc file, so we do it manually.
define LIBFFI_MOVE_STAGING_HEADERS
	mv $(STAGING_DIR)/usr/lib/libffi-*/include/*.h $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 0644 $(@D)/libffi.pc $(STAGING_DIR)/usr/lib/pkgconfig/libffi.pc
	$(SED) '/^includedir.*/d' $(STAGING_DIR)/usr/lib/pkgconfig/libffi.pc
	$(SED) '/^Cflags:.*/d' $(STAGING_DIR)/usr/lib/pkgconfig/libffi.pc
	rm -rf $(TARGET_DIR)/usr/lib/libffi-*
endef

LIBFFI_POST_INSTALL_STAGING_HOOKS += LIBFFI_MOVE_STAGING_HEADERS

# Similar for target headers
define LIBFFI_MOVE_TARGET_HEADERS
	install -d $(TARGET_DIR)/usr/include/
	mv $(TARGET_DIR)/usr/lib/libffi-*/include/*.h $(TARGET_DIR)/usr/include/
	rm -rf $(TARGET_DIR)/usr/lib/libffi-*
endef

LIBFFI_POST_INSTALL_TARGET_HOOKS += LIBFFI_MOVE_TARGET_HEADERS

# We're using a version from Git which strangely bundles a generated
# configure script, but it's broken (doesn't generate the libffi.pc
# file).
HOST_LIBFFI_AUTORECONF = YES

# For some reason, the libffi build system forgets to install the .pc
# file, so we do it manually.
define HOST_LIBFFI_INSTALL_PC_FILE
	$(INSTALL) -D $(@D)/libffi.pc $(HOST_DIR)/usr/lib/pkgconfig/libffi.pc
endef

HOST_LIBFFI_POST_INSTALL_HOOKS += HOST_LIBFFI_INSTALL_PC_FILE

$(eval $(autotools-package))
$(eval $(host-autotools-package))
