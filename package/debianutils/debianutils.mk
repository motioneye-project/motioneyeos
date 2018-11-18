################################################################################
#
# debianutils
#
################################################################################

DEBIANUTILS_VERSION = 4.8.1
DEBIANUTILS_SOURCE = debianutils_$(DEBIANUTILS_VERSION).tar.xz
DEBIANUTILS_SITE = http://snapshot.debian.org/archive/debian/20161118T033019Z/pool/main/d/debianutils
DEBIANUTILS_CONF_OPTS = --exec-prefix=/
DEBIANUTILS_LICENSE = GPL-2.0+, SMAIL (savelog)
DEBIANUTILS_LICENSE_FILES = debian/copyright

$(eval $(autotools-package))
