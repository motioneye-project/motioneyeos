################################################################################
#
# texinfo
#
################################################################################

TEXINFO_VERSION = 6.1
TEXINFO_SITE = $(BR2_GNU_MIRROR)/texinfo
TEXINFO_SOURCE = texinfo-$(TEXINFO_VERSION).tar.xz
TEXINFO_LICENSE = GPLv3+
TEXINFO_LICENSE_FILES = COPYING

$(eval $(host-autotools-package))
