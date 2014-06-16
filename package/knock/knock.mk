################################################################################
#
# knock
#
################################################################################

KNOCK_VERSION = 0.7
KNOCK_SITE = http://www.zeroflux.org/proj/knock/files
KNOCK_LICENSE = GPLv2+
KNOCK_LICENSE_FILES = COPYING
KNOCK_DEPENDENCIES = libpcap

$(eval $(autotools-package))
