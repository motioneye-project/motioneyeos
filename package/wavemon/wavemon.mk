################################################################################
#
# wavemon
#
################################################################################

WAVEMON_VERSION = 0.9.1
WAVEMON_SITE = $(call github,uoaerg,wavemon,v$(WAVEMON_VERSION))
WAVEMON_LICENSE = GPL-3.0+
WAVEMON_LICENSE_FILES = COPYING
WAVEMON_DEPENDENCIES = host-pkgconf libnl ncurses

# Handwritten Makefile.in, automake isn't used
WAVEMON_MAKE_OPTS = CC="$(TARGET_CC)"

$(eval $(autotools-package))
