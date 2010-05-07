################################################################################
#
# xfont_encodings -- No description available
#
################################################################################

XFONT_ENCODINGS_VERSION = 1.0.3
XFONT_ENCODINGS_SOURCE = encodings-$(XFONT_ENCODINGS_VERSION).tar.bz2
XFONT_ENCODINGS_SITE = http://xorg.freedesktop.org/releases/individual/font
XFONT_ENCODINGS_AUTORECONF = NO
XFONT_ENCODINGS_MAKE_OPT =
XFONT_ENCODINGS_DEPENDENCIES = host-xapp_mkfontscale
HOST_XFONT_ENCODINGS_DEPENDENCIES = host-xapp_mkfontscale

$(eval $(call AUTOTARGETS,package/x11r7,xfont_encodings))
$(eval $(call AUTOTARGETS,package/x11r7,xfont_encodings,host))
