################################################################################
#
# openntpd
#
################################################################################

OPENNTPD_VERSION = 3.9p1
OPENNTPD_SITE = ftp://ftp.openbsd.org/pub/OpenBSD/OpenNTPD
OPENNTPD_CONF_OPT = --with-builtin-arc4random --disable-strip
OPENNTPD_LICENSE = MIT-like, BSD-2c, BSD-3c
OPENNTPD_LICENSE_FILES = LICENCE

$(eval $(autotools-package))
