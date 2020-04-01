################################################################################
#
# kmscube
#
################################################################################

KMSCUBE_VERSION = 6cbd03ab94066dddbba7bedfde87c7c4319c18d5
KMSCUBE_SITE = https://gitlab.freedesktop.org/mesa/kmscube/-/archive/$(KMSCUBE_VERSION)
KMSCUBE_LICENSE = MIT
KMSCUBE_DEPENDENCIES = host-pkgconf mesa3d libdrm
KMSCUBE_AUTORECONF = YES

$(eval $(autotools-package))
