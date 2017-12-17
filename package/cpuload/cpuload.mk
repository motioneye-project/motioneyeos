################################################################################
#
# cpuload
#
################################################################################

CPULOAD_VERSION = v0.3
CPULOAD_SITE = $(call github,kelvincheung,cpuload,$(CPULOAD_VERSION))
CPULOAD_LICENSE = GPL-2.0
CPULOAD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
