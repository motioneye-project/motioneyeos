################################################################################
#
# bootutils
#
################################################################################

BOOTUTILS_VERSION = 1.0.0
BOOTUTILS_SITE = http://downloads.sourceforge.net/project/bootutils/Stable/v$(BOOTUTILS_VERSION)

BOOTUTILS_CONF_OPT = --prefix=/ --exec-prefix=/

$(eval $(autotools-package))
