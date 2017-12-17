################################################################################
#
# google-breakpad
#
################################################################################

GOOGLE_BREAKPAD_VERSION = 7515ab13768c7edc09f0f2ec2354dc6c928239a6
GOOGLE_BREAKPAD_SITE = https://chromium.googlesource.com/breakpad/breakpad
GOOGLE_BREAKPAD_SITE_METHOD = git
GOOGLE_BREAKPAD_CONF_OPTS = --disable-processor --disable-tools
# Only a static library is installed
GOOGLE_BREAKPAD_INSTALL_TARGET = NO
GOOGLE_BREAKPAD_INSTALL_STAGING = YES
GOOGLE_BREAKPAD_LICENSE = BSD-3c
GOOGLE_BREAKPAD_LICENSE_FILES = LICENSE
GOOGLE_BREAKPAD_DEPENDENCIES = host-google-breakpad linux-syscall-support

HOST_GOOGLE_BREAKPAD_DEPENDENCIES = host-linux-syscall-support 

# Avoid using depot-tools to download this file.
define HOST_GOOGLE_BREAKPAD_LSS
	$(INSTALL) -D -m 0644 \
		$(HOST_DIR)/usr/include/linux_syscall_support.h \
		$(@D)/src/third_party/lss/linux_syscall_support.h
endef
HOST_GOOGLE_BREAKPAD_POST_EXTRACT_HOOKS += HOST_GOOGLE_BREAKPAD_LSS

define GOOGLE_BREAKPAD_LSS
	$(INSTALL) -D -m 0644 \
		$(STAGING_DIR)/usr/include/linux_syscall_support.h \
		$(@D)/src/third_party/lss/linux_syscall_support.h
endef
GOOGLE_BREAKPAD_POST_EXTRACT_HOOKS += GOOGLE_BREAKPAD_LSS

define GOOGLE_BREAKPAD_EXTRACT_SYMBOLS
	$(EXTRA_ENV) package/google-breakpad/gen-syms.sh $(STAGING_DIR) \
		$(TARGET_DIR) $(call qstrip,$(BR2_GOOGLE_BREAKPAD_INCLUDE_FILES))
endef
GOOGLE_BREAKPAD_TARGET_FINALIZE_HOOKS += GOOGLE_BREAKPAD_EXTRACT_SYMBOLS

$(eval $(autotools-package))
$(eval $(host-autotools-package))
