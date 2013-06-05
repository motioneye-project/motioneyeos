################################################################################
#
# patch
#
################################################################################

PATCH_VERSION = 2.7.1
PATCH_SITE = $(BR2_GNU_MIRROR)/patch
PATCH_LICENSE = GPLv3+
PATCH_LICENSE_FILES = COPYING

$(eval $(autotools-package))
