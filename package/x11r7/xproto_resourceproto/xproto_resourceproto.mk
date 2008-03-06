################################################################################
#
# xproto_resourceproto -- X.Org Resource protocol headers
#
################################################################################

XPROTO_RESOURCEPROTO_VERSION = 1.0.2
XPROTO_RESOURCEPROTO_SOURCE = resourceproto-$(XPROTO_RESOURCEPROTO_VERSION).tar.bz2
XPROTO_RESOURCEPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_RESOURCEPROTO_AUTORECONF = NO
XPROTO_RESOURCEPROTO_INSTALL_STAGING = YES
XPROTO_RESOURCEPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,package/x11r7,xproto_resourceproto))
