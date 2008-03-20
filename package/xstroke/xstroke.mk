#############################################################
#
# xstroke
#
#############################################################
XSTROKE_VERSION = 0.6
XSTROKE_SOURCE = xstroke-$(XSTROKE_VERSION).tar.gz
XSTROKE_SITE = http://avr32linux.org/twiki/pub/Main/XStroke
XSTROKE_AUTORECONF = NO
XSTROKE_INSTALL_STAGING = NO
XSTROKE_INSTALL_TARGET = YES
XSTROKE_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

XSTROKE_DEPENDENCIES = uclibc docker

$(eval $(call AUTOTARGETS,package,xstroke))

