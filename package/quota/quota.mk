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
# We're patching configure.ac
QUOTA_AUTORECONF = YES
QUOTA_GETTEXTIZE = YES
QUOTA_CONF_ENV = LIBS="$(TARGET_NLS_LIBS)"
QUOTA_CONF_OPTS = --disable-pie

ifeq ($(BR2_PACKAGE_DBUS)$(BR2_PACKAGE_LIBNL),yy)
QUOTA_DEPENDENCIES += host-pkgconf dbus libnl
QUOTA_CONF_OPTS += --enable-netlink
else
QUOTA_CONF_OPTS += --disable-netlink
endif

ifeq ($(BR2_PACKAGE_E2FSPROGS),y)
QUOTA_DEPENDENCIES += host-pkgconf e2fsprogs
QUOTA_CONF_OPTS += --enable-ext2direct
else
QUOTA_CONF_OPTS += --disable-ext2direct
endif

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
QUOTA_DEPENDENCIES += libtirpc host-pkgconf
endif

ifeq ($(BR2_PACKAGE_OPENLDAP):$(BR2_STATIC_LIBS),y:)
QUOTA_DEPENDENCIES += openldap
QUOTA_CONF_OPTS += --enable-ldapmail
else
QUOTA_CONF_OPTS += --disable-ldapmail
endif

$(eval $(autotools-package))
