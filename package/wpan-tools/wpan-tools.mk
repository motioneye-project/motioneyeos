################################################################################
#
# wpan-tools
#
################################################################################

WPAN_TOOLS_VERSION = 0.7
WPAN_TOOLS_SOURCE = wpan-tools-$(WPAN_TOOLS_VERSION).tar.xz
WPAN_TOOLS_SITE = http://wpan.cakelab.org/releases
WPAN_TOOLS_DEPENDENCIES = host-pkgconf libnl
WPAN_TOOLS_LICENSE = ISC
WPAN_TOOLS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
