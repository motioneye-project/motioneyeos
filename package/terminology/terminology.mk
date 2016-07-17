################################################################################
#
# terminology
#
################################################################################

TERMINOLOGY_VERSION = 0.9.1
TERMINOLOGY_SOURCE = terminology-$(TERMINOLOGY_VERSION).tar.xz
TERMINOLOGY_SITE = https://download.enlightenment.org/rel/apps/terminology
TERMINOLOGY_LICENSE = BSD-2c
TERMINOLOGY_LICENSE_FILES = COPYING

TERMINOLOGY_DEPENDENCIES = efl elementary host-pkgconf
TERMINOLOGY_CONF_OPTS = --with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc

$(eval $(autotools-package))
