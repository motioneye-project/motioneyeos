################################################################################
#
# argus
#
################################################################################

ARGUS_VERSION = 3.0.6.1
ARGUS_SITE = http://qosient.com/argus/src
ARGUS_DEPENDENCIES = libpcap
ARGUS_CONF_ENV = arg_cv_sys_errlist=yes
# Code is really v2+ though COPYING is v3 so ship README to avoid confusion
ARGUS_LICENSE = GPLv2+
ARGUS_LICENSE_FILES = README

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
ARGUS_DEPENDENCIES += libtirpc
ARGUS_CONF_ENV += \
	CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include/tirpc/" \
	LDFLAGS="$(TARGET_LDFLAGS) -ltirpc"
endif

$(eval $(autotools-package))
