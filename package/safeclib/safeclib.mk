################################################################################
#
# safeclib
#
################################################################################

SAFECLIB_VERSION = v09102017
SAFECLIB_SITE = $(call github,rurban,safeclib,$(SAFECLIB_VERSION))
SAFECLIB_LICENSE = MIT
SAFECLIB_LICENSE_FILES = COPYING
SAFECLIB_INSTALL_STAGING = YES
# From git
SAFECLIB_AUTORECONF = YES

$(eval $(autotools-package))
