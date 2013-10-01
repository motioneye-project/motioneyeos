################################################################################
#
# psplash
#
################################################################################

PSPLASH_VERSION = 0.1
PSPLASH_SITE = http://downloads.yoctoproject.org/releases/psplash
PSPLASH_LICENSE = GPLv2+
PSPLASH_LICENSE_FILES = COPYING

$(eval $(autotools-package))
