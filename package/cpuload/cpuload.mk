################################################################################
#
# cpuload
#
################################################################################

CPULOAD_VERSION = 0.3
CPULOAD_SITE = $(call github,kelvincheung,cpuload,v$(CPULOAD_VERSION))
CPULOAD_LICENSE = GPL-2.0
CPULOAD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
