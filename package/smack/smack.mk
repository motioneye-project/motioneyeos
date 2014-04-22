################################################################################
#
# smack
#
################################################################################

SMACK_VERSION = v1.0.4
SMACK_SITE = $(call github,smack-team,smack,$(SMACK_VERSION))
SMACK_LICENSE = LGPLv2.1
SMACK_LICENSE_FILES = COPYING
SMACK_INSTALL_STAGING = YES
SMACK_DEPENDENCIES = host-pkgconf

# Sources from github, no configure script included.
SMACK_AUTORECONF = YES

$(eval $(autotools-package))
