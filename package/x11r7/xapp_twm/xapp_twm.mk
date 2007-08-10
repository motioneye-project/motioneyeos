################################################################################
#
# xapp_twm -- No description available
#
################################################################################

XAPP_TWM_VERSION = 1.0.3
XAPP_TWM_SOURCE = twm-$(XAPP_TWM_VERSION).tar.bz2
XAPP_TWM_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_TWM_AUTORECONF = YES

$(eval $(call AUTOTARGETS,xapp_twm))
