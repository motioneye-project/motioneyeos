################################################################################
#
# ucl
#
################################################################################

UCL_VERSION = 1.03
UCL_SITE = http://www.oberhumer.com/opensource/ucl/download
UCL_LICENSE = GPLv2+
UCL_LICENSE_FILES = COPYING

# Fix ACC conformance test failure for host gcc 6.x
HOST_UCL_CONF_ENV += CPPFLAGS="$(HOST_CPPFLAGS) -std=iso9899:1990"

$(eval $(host-autotools-package))
