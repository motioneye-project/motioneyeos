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

$(eval $(host-autotools-package))
