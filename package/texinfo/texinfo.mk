################################################################################
#
# texinfo
#
################################################################################

# We are intentionally not using the latest version 5.x, because it
# causes issues with the documentation building process when creating
# a toolchain with the Crosstool-NG backend.

TEXINFO_VERSION = 4.13a
TEXINFO_SITE = $(BR2_GNU_MIRROR)/texinfo
TEXINFO_LICENSE = GPLv3+
TEXINFO_LICENSE_FILES = COPYING
TEXINFO_DEPENDENCIES = ncurses

$(eval $(host-autotools-package))
