################################################################################
#
# google-breakpad
#
################################################################################

GOOGLE_BREAKPAD_VERSION = 1373
GOOGLE_BREAKPAD_SITE = http://google-breakpad.googlecode.com/svn/trunk
GOOGLE_BREAKPAD_SITE_METHOD = svn
GOOGLE_BREAKPAD_CONF_OPTS = --disable-processor --disable-tools
# Only a static library is installed
GOOGLE_BREAKPAD_INSTALL_TARGET = NO
GOOGLE_BREAKPAD_INSTALL_STAGING = YES
GOOGLE_BREAKPAD_LICENSE = BSD-3c
GOOGLE_BREAKPAD_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_GOOGLE_BREAKPAD),y)
GOOGLE_BREAKPAD_DEPENDENCIES = host-google-breakpad
define GOOGLE_BREAKPAD_EXTRACT_SYMBOLS
	$(EXTRA_ENV) package/google-breakpad/gen-syms.sh $(STAGING_DIR) \
		$(TARGET_DIR) $(call qstrip,$(BR2_GOOGLE_BREAKPAD_INCLUDE_FILES))
endef
TARGET_FINALIZE_HOOKS += GOOGLE_BREAKPAD_EXTRACT_SYMBOLS
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
