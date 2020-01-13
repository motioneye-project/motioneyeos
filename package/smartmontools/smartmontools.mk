################################################################################
#
# smartmontools
#
################################################################################

SMARTMONTOOLS_VERSION = 6.5
SMARTMONTOOLS_SITE = http://downloads.sourceforge.net/project/smartmontools/smartmontools/$(SMARTMONTOOLS_VERSION)
SMARTMONTOOLS_LICENSE = GPL-2.0+
SMARTMONTOOLS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBCAP_NG),y)
SMARTMONTOOLS_CONF_OPTS += --with-libcap-ng
SMARTMONTOOLS_DEPENDENCIES += libcap-ng
else
SMARTMONTOOLS_CONF_OPTS += --without-libcap-ng
endif

$(eval $(autotools-package))
