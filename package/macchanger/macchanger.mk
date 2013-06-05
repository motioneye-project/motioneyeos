################################################################################
#
# macchanger
#
################################################################################

MACCHANGER_VERSION = 1.5.0
MACCHANGER_SITE = $(BR2_GNU_MIRROR)/macchanger
MACCHANGER_LICENSE = GPLv2
MACCHANGER_LICENSE_FILES = COPYING

$(eval $(autotools-package))
