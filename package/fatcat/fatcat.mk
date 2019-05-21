################################################################################
#
# fatcat
#
################################################################################

FATCAT_VERSION = 1.0.6
FATCAT_SITE = $(call github,Gregwar,fatcat,$(FATCAT_VERSION))
FATCAT_LICENSE = MIT
FATCAT_LICENSE_FILES = LICENSE

$(eval $(host-cmake-package))
