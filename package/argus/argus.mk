################################################################################
#
# argus
#
################################################################################

ARGUS_VERSION = 3.0.8
ARGUS_SITE = http://qosient.com/argus/src
ARGUS_DEPENDENCIES = libpcap
ARGUS_CONF_ENV = arg_cv_sys_errlist=yes
# Code is really v2+ though COPYING is v3 so ship README to avoid confusion
ARGUS_LICENSE = GPL-2.0+
ARGUS_LICENSE_FILES = README

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
ARGUS_DEPENDENCIES += libtirpc host-pkgconf
ARGUS_CONF_ENV += \
	CFLAGS="$(TARGET_CFLAGS) `$(PKG_CONFIG_HOST_BINARY) --cflags libtirpc`" \
	LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs libtirpc`"
endif

$(eval $(autotools-package))
