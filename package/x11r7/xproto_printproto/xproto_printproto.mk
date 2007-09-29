################################################################################
#
# xproto_printproto -- X.Org Print protocol headers
#
################################################################################

XPROTO_PRINTPROTO_VERSION = 1.0.3
XPROTO_PRINTPROTO_SOURCE = printproto-$(XPROTO_PRINTPROTO_VERSION).tar.bz2
XPROTO_PRINTPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_PRINTPROTO_AUTORECONF = YES
XPROTO_PRINTPROTO_INSTALL_STAGING = YES
XPROTO_PRINTPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,package/x11r7,xproto_printproto))
