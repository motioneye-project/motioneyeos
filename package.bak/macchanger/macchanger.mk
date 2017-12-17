################################################################################
#
# macchanger
#
################################################################################

MACCHANGER_VERSION = 1.7.0
MACCHANGER_SITE = https://github.com/alobbs/macchanger/releases/download/$(MACCHANGER_VERSION)
MACCHANGER_LICENSE = GPLv2+
MACCHANGER_LICENSE_FILES = COPYING

$(eval $(autotools-package))
