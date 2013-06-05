################################################################################
#
# mtools
#
################################################################################

MTOOLS_VERSION       = 4.0.18
MTOOLS_SOURCE        = mtools-$(MTOOLS_VERSION).tar.bz2
MTOOLS_SITE          = $(BR2_GNU_MIRROR)/mtools/
MTOOLS_LICENSE       = GPLv3+
MTOOLS_LICENSE_FILES = COPYING

MTOOLS_CONF_OPT = --enable-xdf        \
                  --enable-vold       \
                  --enable-new-vold

$(eval $(host-autotools-package))
