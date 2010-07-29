#############################################################
#
# libiconv
#
#############################################################
LIBICONV_VERSION = 1.12
LIBICONV_SOURCE = libiconv-$(LIBICONV_VERSION).tar.gz
LIBICONV_SITE = $(BR2_GNU_MIRROR)/libiconv
LIBICONV_AUTORECONF = NO
LIBICONV_INSTALL_STAGING = YES
LIBICONV_INSTALL_TARGET = YES

LIBICONV_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package,libiconv))

$(LIBICONV_HOOK_POST_INSTALL):
	# Remove not used preloadable libiconv.so
	rm -f $(STAGING_DIR)/usr/lib/preloadable_libiconv.so
	rm -f $(TARGET_DIR)/usr/lib/preloadable_libiconv.so
ifneq ($(BR2_ENABLE_DEBUG),y)
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libiconv.so.*
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libcharset.so.*
endif
	touch $@

# Configurations where the toolchain supports locales and the libiconv
# package is enabled are incorrect, because the toolchain already
# provides libiconv functionality, and having both confuses packages.
ifeq ($(BR2_PACKAGE_LIBICONV)$(BR2_ENABLE_LOCALE),yy)
$(error Libiconv should never be enabled when the toolchain supports locales. Report this failure to Buildroot developers)
endif
