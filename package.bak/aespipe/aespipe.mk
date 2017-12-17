################################################################################
#
# aespipe
#
################################################################################

AESPIPE_VERSION = 2.4d
AESPIPE_SOURCE = aespipe-v$(AESPIPE_VERSION).tar.bz2
AESPIPE_SITE = http://loop-aes.sourceforge.net/aespipe
AESPIPE_LICENSE = GPL

# Recent Debian, Gentoo and Ubuntu enable -fPIE by default, breaking the build:
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=837393
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=835148
# Older gcc versions however don't support the -no-pie flag, so we have to
# check its availability.
HOST_AESPIPE_NO_PIE_FLAG = $(call host-cc-option,-no-pie)
HOST_AESPIPE_CONF_ENV = \
	CFLAGS="$(HOST_CFLAGS) $(HOST_AESPIPE_NO_PIE_FLAG)" \
	LDFLAGS="$(HOST_LDFLAGS) $(HOST_AESPIPE_NO_PIE_FLAG)"

$(eval $(autotools-package))
$(eval $(host-autotools-package))
