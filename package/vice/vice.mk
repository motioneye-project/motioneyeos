#############################################################
#
# vice
#
#############################################################
VICE_VERSION = 1.22
VICE_SOURCE = vice-$(VICE_VERSION).tar.gz
VICE_SITE = http://www.viceteam.org/online
VICE_AUTORECONF = NO
VICE_INSTALL_STAGING = NO
VICE_INSTALL_TARGET = YES

VICE_CONF_OPT = --without-resid --with-alsa CFLAGS="-O0"

VICE_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,vice))

