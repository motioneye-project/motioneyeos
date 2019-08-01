################################################################################
#
# gmrender-resurrect
#
################################################################################

GMRENDER_RESURRECT_VERSION = a7b0b1b9ca482d2d34ac62c2f2dc0cf0dfbb702b
GMRENDER_RESURRECT_SITE = $(call github,hzeller,gmrender-resurrect,$(GMRENDER_RESURRECT_VERSION))
# Original distribution does not have default configure,
# so we need to autoreconf:
GMRENDER_RESURRECT_AUTORECONF = YES
GMRENDER_RESURRECT_LICENSE = GPL-2.0+
GMRENDER_RESURRECT_LICENSE_FILES = COPYING
GMRENDER_RESURRECT_DEPENDENCIES = gstreamer1 libupnp

$(eval $(autotools-package))
