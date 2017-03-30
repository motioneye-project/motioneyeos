################################################################################
#
# gmrender-resurrect
#
################################################################################

GMRENDER_RESURRECT_VERSION = 48caaa4f6c386fd1586126c801cd326f96d5fa5c
GMRENDER_RESURRECT_SITE = $(call github,hzeller,gmrender-resurrect,$(GMRENDER_RESURRECT_VERSION))
# Original distribution does not have default configure,
# so we need to autoreconf:
GMRENDER_RESURRECT_AUTORECONF = YES
GMRENDER_RESURRECT_LICENSE = GPL-2.0+
GMRENDER_RESURRECT_LICENSE_FILES = COPYING
GMRENDER_RESURRECT_DEPENDENCIES = gstreamer1 libupnp

$(eval $(autotools-package))
