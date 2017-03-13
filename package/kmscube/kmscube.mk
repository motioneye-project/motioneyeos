################################################################################
#
# kmscube
#
################################################################################

KMSCUBE_VERSION = db8c6fc0f625e3a3d36731363276c459661d4149
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
