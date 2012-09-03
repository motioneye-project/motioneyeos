#############################################################
#
# cpuload
#
#############################################################

CPULOAD_VERSION = v0.3
CPULOAD_SITE = git://github.com/kelvincheung/cpuload.git
CPULOAD_LICENSE = GPLv2
CPULOAD_LICENSE_FILES = COPYING


$(eval $(autotools-package))
