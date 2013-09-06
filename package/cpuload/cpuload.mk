################################################################################
#
# cpuload
#
################################################################################

CPULOAD_VERSION = v0.3
CPULOAD_SOURCE = cpuload-$(CPULOAD_VERSION).tar.xz
CPULOAD_SITE = http://github.com/kelvincheung/cpuload/tarball/$(CPULOAD_VERSION)
CPULOAD_LICENSE = GPLv2
CPULOAD_LICENSE_FILES = COPYING


$(eval $(autotools-package))
