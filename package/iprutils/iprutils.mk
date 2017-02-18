################################################################################
#
# iprutils
#
################################################################################

IPRUTILS_VERSION_MAJOR = 2.4.10
IPRUTILS_VERSION = $(IPRUTILS_VERSION_MAJOR).1
IPRUTILS_SITE = http://downloads.sourceforge.net/project/iprdd/iprutils%20for%202.6%20kernels/$(IPRUTILS_VERSION_MAJOR)
IPRUTILS_DEPENDENCIES = ncurses libsysfs pciutils
IPRUTILS_LICENSE = Common Public License Version 1.0
IPRUTILS_LICENSE_FILES = LICENSE
# Patches touching configure.ac
IPRUTILS_AUTORECONF = YES

$(eval $(autotools-package))
