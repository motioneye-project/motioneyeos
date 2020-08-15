################################################################################
#
# luksmeta
#
################################################################################

LUKSMETA_VERSION = 9
LUKSMETA_SOURCE = luksmeta-$(LUKSMETA_VERSION).tar.bz2
LUKSMETA_SITE = https://github.com/latchset/luksmeta/releases/download/v$(LUKSMETA_VERSION)
LUKSMETA_LICENSE = LGPL-2.1+
LUKSMETA_LICENSE_FILES = COPYING
LUKSMETA_DEPENDENCIES = host-pkgconf cryptsetup
LUKSMETA_CONF_ENV = ac_cv_prog_A2X=""
LUKSMETA_INSTALL_STAGING = YES

$(eval $(autotools-package))
