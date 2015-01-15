################################################################################
#
# bison
#
################################################################################

BISON_VERSION = 3.0.2
BISON_SOURCE = bison-$(BISON_VERSION).tar.xz
BISON_SITE = $(BR2_GNU_MIRROR)/bison
BISON_LICENSE = GPLv3+
BISON_LICENSE_FILES = COPYING
BISON_AUTORECONF = YES

$(eval $(host-autotools-package))
