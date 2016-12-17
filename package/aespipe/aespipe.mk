################################################################################
#
# aespipe
#
################################################################################

AESPIPE_VERSION = 2.4d
AESPIPE_SOURCE = aespipe-v$(AESPIPE_VERSION).tar.bz2
AESPIPE_SITE = http://loop-aes.sourceforge.net/aespipe
AESPIPE_LICENSE = GPL

# Debian enables -fPIE by default, breaking the build:
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=837393
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=835148
HOST_AESPIPE_CONF_ENV = \
	CFLAGS="$(HOST_CFLAGS) -no-pie" \
	LDFLAGS="$(HOST_LDFLAGS) -no-pie"

$(eval $(autotools-package))
$(eval $(host-autotools-package))
