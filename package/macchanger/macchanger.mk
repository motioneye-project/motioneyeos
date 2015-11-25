################################################################################
#
# macchanger
#
################################################################################

MACCHANGER_VERSION = 1.6.0
MACCHANGER_SITE = $(BR2_GNU_MIRROR)/macchanger
MACCHANGER_LICENSE = GPLv2+
MACCHANGER_LICENSE_FILES = src/main.c

$(eval $(autotools-package))
