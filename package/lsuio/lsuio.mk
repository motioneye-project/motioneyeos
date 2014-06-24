################################################################################
#
# lsuio
#
################################################################################

LSUIO_VERSION = 0.2.0
LSUIO_SITE = http://www.osadl.org/projects/downloads/UIO/user
LSUIO_LICENSE = GPLv2
LSUIO_LICENSE_FILES = COPYING

$(eval $(autotools-package))
