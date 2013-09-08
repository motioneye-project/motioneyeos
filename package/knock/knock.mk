################################################################################
#
# knock
#
################################################################################

KNOCK_VERSION = 7666f2e86e
KNOCK_SITE = https://github.com/jvinet/knock/tarball/master
KNOCK_LICENSE = GPLv2+
KNOCK_LICENSE_FILES = COPYING
KNOCK_AUTORECONF = YES
KNOCK_DEPENDENCIES = libpcap

$(eval $(autotools-package))
