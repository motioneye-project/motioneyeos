################################################################################
#
# owl-linux
#
################################################################################

OWL_LINUX_VERSION = 1.0.7
OWL_LINUX_SITE = http://linux.hd-wireless.se/pub/Linux/DownloadDrivers
OWL_LINUX_LICENSE = PROPRIETARY
OWL_LINUX_LICENSE_FILES = LICENSE
OWL_LINUX_REDISTRIBUTE = NO

$(eval $(kernel-module))
$(eval $(generic-package))
