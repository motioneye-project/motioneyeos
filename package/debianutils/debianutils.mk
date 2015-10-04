################################################################################
#
# debianutils
#
################################################################################

DEBIANUTILS_VERSION = 4.4
DEBIANUTILS_SOURCE = debianutils_$(DEBIANUTILS_VERSION).tar.gz
DEBIANUTILS_SITE = http://snapshot.debian.org/archive/debian/20130728T034252Z/pool/main/d/debianutils
DEBIANUTILS_CONF_OPTS = --exec-prefix=/
# Make sure we override the busybox tools, such as which
DEBIANUTILS_DEPENDENCIES = $(if $(BR2_PACKAGE_BUSYBOX),busybox)
DEBIANUTILS_LICENSE = GPLv2+, SMAIL (savelog)
DEBIANUTILS_LICENSE_FILES = debian/copyright

$(eval $(autotools-package))
