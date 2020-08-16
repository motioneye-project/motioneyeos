################################################################################
#
# smack
#
################################################################################

SMACK_VERSION = 1.3.1
SMACK_SITE = $(call github,smack-team,smack,v$(SMACK_VERSION))
SMACK_LICENSE = LGPL-2.1
SMACK_LICENSE_FILES = COPYING
SMACK_INSTALL_STAGING = YES
SMACK_DEPENDENCIES = host-pkgconf

# Sources from GitHub, no configure script included.
SMACK_AUTORECONF = YES

define SMAKE_LINUX_CONFIG_FIXUPS
	$(call KCONFIG_ENABLE_OPT,CONFIG_SECURITY)
	$(call KCONFIG_ENABLE_OPT,CONFIG_SECURITY_SMACK)
	$(call KCONFIG_ENABLE_OPT,CONFIG_SECURITY_NETWORK)
endef

$(eval $(autotools-package))
