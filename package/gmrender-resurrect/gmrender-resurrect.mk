################################################################################
#
# gmrender-resurrect
#
################################################################################

GMRENDER_RESURRECT_VERSION = 33600ab663f181c4f4f5c48aba25bf961760a300
GMRENDER_RESURRECT_SITE = $(call github,hzeller,gmrender-resurrect,$(GMRENDER_RESURRECT_VERSION))
# Original distribution does not have default configure,
# so we need to autoreconf:
GMRENDER_RESURRECT_AUTORECONF = YES
GMRENDER_RESURRECT_LICENSE = GPL-2.0+
GMRENDER_RESURRECT_LICENSE_FILES = COPYING
GMRENDER_RESURRECT_DEPENDENCIES = gstreamer1 libupnp

$(eval $(autotools-package))
