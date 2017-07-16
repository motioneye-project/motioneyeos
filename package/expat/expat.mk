################################################################################
#
# expat
#
################################################################################

EXPAT_VERSION = 2.2.2
EXPAT_SITE = http://downloads.sourceforge.net/project/expat/expat/$(EXPAT_VERSION)
EXPAT_SOURCE = expat-$(EXPAT_VERSION).tar.bz2
EXPAT_INSTALL_STAGING = YES
EXPAT_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) installlib
EXPAT_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) installlib
EXPAT_DEPENDENCIES = host-pkgconf
HOST_EXPAT_DEPENDENCIES = host-pkgconf
EXPAT_LICENSE = MIT
EXPAT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
$(eval $(host-autotools-package))
