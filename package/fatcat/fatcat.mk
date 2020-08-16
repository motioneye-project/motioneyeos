################################################################################
#
# fatcat
#
################################################################################

FATCAT_VERSION = 1.1.0
FATCAT_SITE = $(call github,Gregwar,fatcat,v$(FATCAT_VERSION))
FATCAT_LICENSE = MIT
FATCAT_LICENSE_FILES = LICENSE

$(eval $(host-cmake-package))
