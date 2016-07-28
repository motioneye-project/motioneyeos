################################################################################
#
# wavemon
#
################################################################################

WAVEMON_VERSION = v0.8.0
WAVEMON_SITE = $(call github,uoaerg,wavemon,$(WAVEMON_VERSION))
WAVEMON_LICENSE = GPLv3+
WAVEMON_LICENSE_FILES = COPYING
WAVEMON_DEPENDENCIES = host-pkgconf libnl ncurses

# Fix musl build issue
WAVEMON_PATCH = https://github.com/uoaerg/wavemon/commit/01e987a032b81af7bbeba1c439759d750dc1f398.patch

# Handwritten Makefile.in, automake isn't used
WAVEMON_MAKE_OPTS = CC="$(TARGET_CC)"

$(eval $(autotools-package))
