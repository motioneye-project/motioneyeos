################################################################################
#
# corkscrew
#
################################################################################

CORKSCREW_VERSION = a94f745b40077172b8fe7d77e2d583b9cf900281
CORKSCREW_SITE = $(call github,bryanpkc,corkscrew,$(CORKSCREW_VERSION))
CORKSCREW_LICENSE = GPL-2.0
CORKSCREW_LICENSE_FILES = COPYING
CORKSCREW_AUTORECONF = YES

$(eval $(autotools-package))
