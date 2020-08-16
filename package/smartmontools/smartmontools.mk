################################################################################
#
# smartmontools
#
################################################################################

SMARTMONTOOLS_VERSION = 7.1
SMARTMONTOOLS_SITE = http://downloads.sourceforge.net/project/smartmontools/smartmontools/$(SMARTMONTOOLS_VERSION)
SMARTMONTOOLS_LICENSE = GPL-2.0+
SMARTMONTOOLS_LICENSE_FILES = COPYING
# We're patching configure.ac
SMARTMONTOOLS_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LIBCAP_NG),y)
SMARTMONTOOLS_CONF_OPTS += --with-libcap-ng
SMARTMONTOOLS_DEPENDENCIES += libcap-ng
else
SMARTMONTOOLS_CONF_OPTS += --without-libcap-ng
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
SMARTMONTOOLS_CONF_OPTS += --with-selinux
SMARTMONTOOLS_DEPENDENCIES += libselinux
else
SMARTMONTOOLS_CONF_OPTS += --without-selinux
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
SMARTMONTOOLS_CONF_OPTS += --with-libsystemd
SMARTMONTOOLS_DEPENDENCIES += systemd
else
SMARTMONTOOLS_CONF_OPTS += --without-libsystemd
endif

$(eval $(autotools-package))
