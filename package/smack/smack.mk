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

$(eval $(autotools-package))
