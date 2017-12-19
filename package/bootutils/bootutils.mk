################################################################################
#
# bootutils
#
################################################################################

BOOTUTILS_VERSION = 1.0.0
BOOTUTILS_SITE = http://downloads.sourceforge.net/project/bootutils/Stable/v$(BOOTUTILS_VERSION)
BOOTUTILS_CONF_OPTS = --prefix=/ --exec-prefix=/
BOOTUTILS_LICENSE = GPL-2.0+
BOOTUTILS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
