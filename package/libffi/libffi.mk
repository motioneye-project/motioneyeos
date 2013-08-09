################################################################################
#
# libffi
#
################################################################################

LIBFFI_VERSION = 3.0.13
LIBFFI_SITE    = ftp://sourceware.org/pub/libffi/
LIBFFI_LICENSE = MIT
LIBFFI_LICENSE_FILES = LICENSE
LIBFFI_INSTALL_STAGING = YES
LIBFFI_AUTORECONF = YES

# Move the headers to the usual location, and adjust the .pc file
# accordingly.
define LIBFFI_MOVE_STAGING_HEADERS
	mv $(STAGING_DIR)/usr/lib/libffi-*/include/*.h $(STAGING_DIR)/usr/include/
	$(SED) '/^includedir.*/d' -e '/^Cflags:.*/d' \
		$(STAGING_DIR)/usr/lib/pkgconfig/libffi.pc
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

HOST_LIBFFI_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
