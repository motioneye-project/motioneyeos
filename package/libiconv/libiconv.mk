################################################################################
#
# libiconv
#
################################################################################

LIBICONV_VERSION = 1.14
LIBICONV_SOURCE = libiconv-$(LIBICONV_VERSION).tar.gz
LIBICONV_SITE = $(BR2_GNU_MIRROR)/libiconv
LIBICONV_INSTALL_STAGING = YES

# Remove not used preloadable libiconv.so
define LIBICONV_TARGET_REMOVE_PRELOADABLE_LIBS
	rm -f $(TARGET_DIR)/usr/lib/preloadable_libiconv.so
endef

define LIBICONV_STAGING_REMOVE_PRELOADABLE_LIBS
	rm -f $(STAGING_DIR)/usr/lib/preloadable_libiconv.so
endef

LIBICONV_POST_INSTALL_TARGET_HOOKS += LIBICONV_TARGET_REMOVE_PRELOADABLE_LIBS
LIBICONV_POST_INSTALL_STAGING_HOOKS += LIBICONV_STAGING_REMOVE_PRELOADABLE_LIBS

$(eval $(autotools-package))

# Configurations where the toolchain supports locales and the libiconv
# package is enabled are incorrect, because the toolchain already
# provides libiconv functionality, and having both confuses packages.
ifeq ($(BR2_PACKAGE_LIBICONV)$(BR2_ENABLE_LOCALE),yy)
$(error Libiconv should never be enabled when the toolchain supports locales. Report this failure to Buildroot developers)
endif
