################################################################################
#
# libffi
#
################################################################################

LIBFFI_VERSION = 3.2.1
LIBFFI_SITE = ftp://sourceware.org/pub/libffi
LIBFFI_LICENSE = MIT
LIBFFI_LICENSE_FILES = LICENSE
LIBFFI_INSTALL_STAGING = YES
LIBFFI_AUTORECONF = YES

# Move the headers to the usual location, and adjust the .pc file
# accordingly.
define LIBFFI_MOVE_HEADERS
	mv $(1)/usr/lib/libffi-$(LIBFFI_VERSION)/include/*.h $(1)/usr/include/
	$(SED) '/^includedir.*/d' -e '/^Cflags:.*/d' \
		$(1)/usr/lib/pkgconfig/libffi.pc
	rm -rf $(1)/usr/lib/libffi-*
endef

LIBFFI_MOVE_STAGING_HEADERS = $(call LIBFFI_MOVE_HEADERS,$(STAGING_DIR))
LIBFFI_POST_INSTALL_STAGING_HOOKS += LIBFFI_MOVE_STAGING_HEADERS

HOST_LIBFFI_MOVE_HOST_HEADERS = $(call LIBFFI_MOVE_HEADERS,$(HOST_DIR))
HOST_LIBFFI_POST_INSTALL_HOOKS += HOST_LIBFFI_MOVE_HOST_HEADERS

# Remove headers that are not at the usual location from the target
define LIBFFI_REMOVE_TARGET_HEADERS
	$(RM) -rf $(TARGET_DIR)/usr/lib/libffi-$(LIBFFI_VERSION)
endef

LIBFFI_POST_INSTALL_TARGET_HOOKS += LIBFFI_REMOVE_TARGET_HEADERS

$(eval $(autotools-package))
$(eval $(host-autotools-package))
