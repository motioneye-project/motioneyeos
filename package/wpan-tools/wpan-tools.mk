################################################################################
#
# wpan-tools
#
################################################################################

WPAN_TOOLS_VERSION = 0.9
WPAN_TOOLS_SITE = $(call github,linux-wpan,wpan-tools,wpan-tools-$(WPAN_TOOLS_VERSION))
WPAN_TOOLS_DEPENDENCIES = host-pkgconf libnl
WPAN_TOOLS_LICENSE = ISC
WPAN_TOOLS_LICENSE_FILES = COPYING
# From git
WPAN_TOOLS_AUTORECONF = YES

$(eval $(autotools-package))
