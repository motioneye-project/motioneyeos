################################################################################
#
# cpuload
#
################################################################################

CPULOAD_VERSION = v0.3
CPULOAD_SITE = $(call github,kelvincheung,cpuload,$(CPULOAD_VERSION))
CPULOAD_LICENSE = GPLv2
CPULOAD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
