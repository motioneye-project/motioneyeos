################################################################################
#
# ibrcommon
#
################################################################################

IBRCOMMON_VERSION = 1.0.1
IBRCOMMON_SOURCE = ibrcommon-$(IBRCOMMON_VERSION).tar.gz
IBRCOMMON_SITE = https://www.ibr.cs.tu-bs.de/projects/ibr-dtn/releases
IBRCOMMON_INSTALL_STAGING = YES
IBRCOMMON_LICENSE = Apache-2.0
IBRCOMMON_LICENSE_FILES = COPYING README
IBRCOMMON_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_OPENSSL),y)
IBRCOMMON_DEPENDENCIES += openssl
IBRCOMMON_CONF_OPTS += --with-openssl
else
IBRCOMMON_CONF_OPTS += --without-openssl
endif

ifeq ($(BR2_PACKAGE_LIBNL),y)
IBRCOMMON_DEPENDENCIES += libnl
IBRCOMMON_CONF_OPTS += --with-lowpan
else
IBRCOMMON_CONF_OPTS += --without-lowpan
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
IBRCOMMON_DEPENDENCIES += libxml2
IBRCOMMON_CONF_OPTS += --with-xml
else
IBRCOMMON_CONF_OPTS += --without-xml
endif

$(eval $(autotools-package))
