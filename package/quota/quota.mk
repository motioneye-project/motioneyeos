################################################################################
#
# quota
#
################################################################################

QUOTA_VERSION = 4.05
QUOTA_SITE = http://downloads.sourceforge.net/project/linuxquota/quota-tools/$(QUOTA_VERSION)
QUOTA_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES) host-nfs-utils
QUOTA_LICENSE = GPL-2.0+
QUOTA_LICENSE_FILES = COPYING
QUOTA_LIBS = $(TARGET_NLS_LIBS)

ifeq ($(BR2_PACKAGE_E2FSPROGS),y)
QUOTA_DEPENDENCIES += host-pkgconf e2fsprogs
QUOTA_CONF_OPTS += --enable-ext2direct
else
QUOTA_CONF_OPTS += --disable-ext2direct
endif

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
QUOTA_DEPENDENCIES += libtirpc host-pkgconf
endif

QUOTA_CONF_ENV = LIBS="$(QUOTA_LIBS)"

$(eval $(autotools-package))
