################################################################################
#
# libffi
#
################################################################################

LIBFFI_VERSION = 3.1
LIBFFI_SITE    = ftp://sourceware.org/pub/libffi/
LIBFFI_LICENSE = MIT
LIBFFI_LICENSE_FILES = LICENSE
LIBFFI_INSTALL_STAGING = YES
LIBFFI_AUTORECONF = YES

# Move the headers to the usual location, and adjust the .pc file
# accordingly.
define LIBFFI_MOVE_STAGING_HEADERS
	mv $(STAGING_DIR)/usr/lib/libffi-$(LIBFFI_VERSION)/include/*.h $(STAGING_DIR)/usr/include/
	$(SED) '/^includedir.*/d' -e '/^Cflags:.*/d' \
		$(STAGING_DIR)/usr/lib/pkgconfig/libffi.pc
	rm -rf $(TARGET_DIR)/usr/lib/libffi-*
endef

LIBFFI_POST_INSTALL_STAGING_HOOKS += LIBFFI_MOVE_STAGING_HEADERS

# Remove headers that are not at the usual location from the target
define LIBFFI_REMOVE_TARGET_HEADERS
	$(RM) -rf $(TARGET_DIR)/usr/lib/libffi-$(LIBFFI_VERSION)
endef

LIBFFI_POST_INSTALL_TARGET_HOOKS += LIBFFI_REMOVE_TARGET_HEADERS

$(eval $(autotools-package))
$(eval $(host-autotools-package))
