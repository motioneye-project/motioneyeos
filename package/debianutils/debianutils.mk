################################################################################
#
# debianutils
#
################################################################################

DEBIANUTILS_VERSION = 4.8.1
DEBIANUTILS_SOURCE = debianutils_$(DEBIANUTILS_VERSION).tar.xz
DEBIANUTILS_SITE = http://snapshot.debian.org/archive/debian/20161118T033019Z/pool/main/d/debianutils
DEBIANUTILS_CONF_OPTS = --exec-prefix=/
# Make sure we override the busybox tools, such as which
DEBIANUTILS_DEPENDENCIES = $(if $(BR2_PACKAGE_BUSYBOX),busybox)
DEBIANUTILS_LICENSE = GPLv2+, SMAIL (savelog)
DEBIANUTILS_LICENSE_FILES = debian/copyright

$(eval $(autotools-package))
