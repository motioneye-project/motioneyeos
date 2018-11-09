################################################################################
#
# libffi
#
################################################################################

LIBFFI_VERSION = v3.3-rc0
LIBFFI_SITE = $(call github,libffi,libffi,$(LIBFFI_VERSION))
LIBFFI_LICENSE = MIT
LIBFFI_LICENSE_FILES = LICENSE
LIBFFI_INSTALL_STAGING = YES
LIBFFI_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
