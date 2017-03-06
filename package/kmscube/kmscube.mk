################################################################################
#
# kmscube
#
################################################################################

KMSCUBE_VERSION = 87e3ff5683ee54228b3e6e75f7d4de83901fadb0
KMSCUBE_SITE = https://cgit.freedesktop.org/mesa/kmscube/snapshot
KMSCUBE_LICENSE = MIT
KMSCUBE_DEPENDENCIES = host-pkgconf mesa3d libdrm
KMSCUBE_AUTORECONF = YES

# Autoreconf requires an existing m4 directory
define KMSCUBE_PATCH_M4
	mkdir -p $(@D)/m4
endef
KMSCUBE_POST_PATCH_HOOKS += KMSCUBE_PATCH_M4

$(eval $(autotools-package))
