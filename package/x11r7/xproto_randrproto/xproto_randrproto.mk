################################################################################
#
# xproto_randrproto -- X.Org Randr protocol headers
#
################################################################################

XPROTO_RANDRPROTO_VERSION = 1.1.2
XPROTO_RANDRPROTO_SOURCE = randrproto-$(XPROTO_RANDRPROTO_VERSION).tar.bz2
XPROTO_RANDRPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_RANDRPROTO_AUTORECONF = YES
XPROTO_RANDRPROTO_INSTALL_STAGING = YES
XPROTO_RANDRPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,xproto_randrproto))
