################################################################################
#
# libefreet
#
################################################################################

LIBEFREET_VERSION = $(EFL_VERSION)
LIBEFREET_SOURCE = efreet-$(LIBEFREET_VERSION).tar.bz2
LIBEFREET_SITE = http://download.enlightenment.org/releases
LIBEFREET_LICENSE = BSD-2c
LIBEFREET_LICENSE_FILES = COPYING

LIBEFREET_INSTALL_STAGING = YES

LIBEFREET_DEPENDENCIES = libeina libeet libecore

$(eval $(autotools-package))
