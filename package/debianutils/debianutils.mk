################################################################################
#
# debianutils
#
################################################################################

DEBIANUTILS_VERSION = 4.8.6.3
DEBIANUTILS_SOURCE = debianutils_$(DEBIANUTILS_VERSION).tar.xz
DEBIANUTILS_SITE = http://snapshot.debian.org/archive/debian/20190828T161440Z/pool/main/d/debianutils
DEBIANUTILS_CONF_OPTS = --exec-prefix=/
DEBIANUTILS_LICENSE = GPL-2.0+, SMAIL (savelog)
DEBIANUTILS_LICENSE_FILES = debian/copyright

$(eval $(autotools-package))
