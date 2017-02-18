################################################################################
#
# simicsfs
#
################################################################################

SIMICSFS_VERSION = 1.18
SIMICSFS_SITE = http://download.simics.net/pub
SIMICSFS_LICENSE = GPLv2+
SIMICSFS_LICENSE_FILES = hostfs.h

$(eval $(kernel-module))
$(eval $(generic-package))
