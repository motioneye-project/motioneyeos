################################################################################
#
# xproto_damageproto -- X.Org Damage protocol headers
#
################################################################################

XPROTO_DAMAGEPROTO_VERSION = 1.0.3
XPROTO_DAMAGEPROTO_SOURCE = damageproto-$(XPROTO_DAMAGEPROTO_VERSION).tar.bz2
XPROTO_DAMAGEPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_DAMAGEPROTO_AUTORECONF = YES
XPROTO_DAMAGEPROTO_INSTALL_STAGING = YES
XPROTO_DAMAGEPROTO_INSTALL_TARGET = NO

$(eval $(call AUTOTARGETS,package/x11r7,xproto_damageproto))
