################################################################################
#
# kmscube
#
################################################################################

KMSCUBE_VERSION = 8c6a20901f95e1b465bbca127f9d47fcfb8762e6
KMSCUBE_SITE = $(call github,robclark,kmscube,$(KMSCUBE_VERSION))
KMSCUBE_LICENSE = MIT
KMSCUBE_DEPENDENCIES = host-pkgconf mesa3d libdrm
KMSCUBE_AUTORECONF = YES

# Autoreconf requires an existing m4 directory
define KMSCUBE_PATCH_M4
	mkdir -p $(@D)/m4
endef
KMSCUBE_POST_PATCH_HOOKS += KMSCUBE_PATCH_M4

$(eval $(autotools-package))
