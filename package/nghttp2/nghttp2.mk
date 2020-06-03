################################################################################
#
# nghttp2
#
################################################################################

NGHTTP2_VERSION = 1.41.0
NGHTTP2_SITE = https://github.com/nghttp2/nghttp2/releases/download/v$(NGHTTP2_VERSION)
NGHTTP2_LICENSE = MIT
NGHTTP2_LICENSE_FILES = COPYING
NGHTTP2_INSTALL_STAGING = YES
NGHTTP2_DEPENDENCIES = host-pkgconf
NGHTTP2_CONF_OPTS = --enable-lib-only

define NGHTTP2_INSTALL_CLEAN_HOOK
	# Remove fetch-ocsp-response script unused by library
	$(Q)$(RM) -rf $(TARGET_DIR)/usr/share/nghttp2
endef

NGHTTP2_POST_INSTALL_TARGET_HOOKS += NGHTTP2_INSTALL_CLEAN_HOOK

$(eval $(autotools-package))
