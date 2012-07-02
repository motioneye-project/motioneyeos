################################################################################
#
# libefreet
#
################################################################################

LIBEFREET_VERSION = 1.1.0
LIBEFREET_SOURCE = efreet-$(LIBEFREET_VERSION).tar.bz2
LIBEFREET_SITE = http://download.enlightenment.org/releases/
LIBEFREET_INSTALL_STAGING = YES

LIBEFREET_DEPENDENCIES = libeina libeet libecore

$(eval $(autotools-package))
