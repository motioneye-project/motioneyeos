################################################################################
#
# libunwind
#
################################################################################

LIBUNWIND_VERSION = 1.1
LIBUNWIND_SITE = http://download.savannah.gnu.org/releases/libunwind
LIBUNWIND_INSTALL_STAGING = YES
LIBUNWIND_LICENSE_FILES = COPYING
LIBUNWIND_LICENSE = MIT

$(eval $(autotools-package))
