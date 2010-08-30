#############################################################
#
# xstroke
#
#############################################################
XSTROKE_VERSION = 0.6
XSTROKE_SOURCE = xstroke-$(XSTROKE_VERSION).tar.gz
XSTROKE_SITE = http://avr32linux.org/twiki/pub/Main/XStroke
XSTROKE_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

XSTROKE_DEPENDENCIES = xlib_libXft xlib_libXtst xlib_libXpm

$(eval $(call AUTOTARGETS,package,xstroke))

