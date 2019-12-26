################################################################################
#
# gmrender-resurrect
#
################################################################################

GMRENDER_RESURRECT_VERSION = 0.0.8
GMRENDER_RESURRECT_SITE = $(call github,hzeller,gmrender-resurrect,v$(GMRENDER_RESURRECT_VERSION))
# Original distribution does not have default configure,
# so we need to autoreconf:
GMRENDER_RESURRECT_AUTORECONF = YES
GMRENDER_RESURRECT_LICENSE = GPL-2.0+
GMRENDER_RESURRECT_LICENSE_FILES = COPYING
GMRENDER_RESURRECT_DEPENDENCIES = \
	gstreamer1 \
	$(if $(BR2_PACKAGE_LIBUPNP),libupnp,libupnp18)

$(eval $(autotools-package))
