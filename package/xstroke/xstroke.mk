#############################################################
#
# xstroke
#
#############################################################
XSTROKE_VERSION = 0.6
XSTROKE_SOURCE = xstroke-$(XSTROKE_VERSION).tar.gz
XSTROKE_SITE = http://avr32linux.org/twiki/pub/Main/XStroke

XSTROKE_DEPENDENCIES = xlib_libXft xlib_libXtst xlib_libXpm

$(eval $(autotools-package))

