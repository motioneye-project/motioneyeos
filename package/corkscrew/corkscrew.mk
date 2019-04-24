################################################################################
#
# corkscrew
#
################################################################################

CORKSCREW_VERSION = v2.0
CORKSCREW_SITE = $(call github,bryanpkc,corkscrew,$(CORKSCREW_VERSION))
CORKSCREW_LICENSE = GPL-2.0
CORKSCREW_LICENSE_FILES = COPYING
CORKSCREW_AUTORECONF = YES

$(eval $(autotools-package))
