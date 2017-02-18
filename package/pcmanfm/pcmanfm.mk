################################################################################
#
# pcmanfm
#
################################################################################

PCMANFM_VERSION = 1.2.3
PCMANFM_SOURCE = pcmanfm-$(PCMANFM_VERSION).tar.xz
PCMANFM_SITE = http://sourceforge.net/projects/pcmanfm/files
PCMANFM_DEPENDENCIES = libgtk2 libglib2 menu-cache libfm
PCMANFM_LICENSE = GPLv2+
PCMANFM_LICENSE_FILES = COPYING

$(eval $(autotools-package))
