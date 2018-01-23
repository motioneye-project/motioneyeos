################################################################################
#
# libbsd
#
################################################################################

LIBBSD_VERSION = 0.8.7
LIBBSD_SOURCE = libbsd-$(LIBBSD_VERSION).tar.xz
LIBBSD_SITE = https://archive.hadrons.org/software/libbsd
LIBBSD_LICENSE = BSD-3-Clause, MIT
LIBBSD_LICENSE_FILES = COPYING
LIBBSD_INSTALL_STAGING = YES

$(eval $(autotools-package))
