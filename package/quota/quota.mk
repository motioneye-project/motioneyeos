################################################################################
#
# quota
#
################################################################################

QUOTA_VERSION = 4.00
QUOTA_SITE = http://downloads.sourceforge.net/project/linuxquota/quota-tools/$(QUOTA_VERSION)
QUOTA_DEPENDENCIES = host-gettext
QUOTA_AUTORECONF = YES
QUOTA_LICENSE = GPLv2+

QUOTA_CFLAGS = $(TARGET_CFLAGS)
QUOTA_LDFLAGS = $(TARGET_LDFLAGS)

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
QUOTA_DEPENDENCIES += gettext
QUOTA_LDFLAGS += -lintl
endif

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
QUOTA_DEPENDENCIES += libtirpc
QUOTA_CFLAGS += -I$(STAGING_DIR)/usr/include/tirpc/
QUOTA_LDFLAGS += -ltirpc
endif

QUOTA_MAKE_OPT = $(TARGET_CONFIGURE_OPTS) CFLAGS="$(QUOTA_CFLAGS) -D_GNU_SOURCE" LDFLAGS="$(QUOTA_LDFLAGS)"
QUOTA_CONF_ENV = \
	CFLAGS="$(QUOTA_CFLAGS) -D_GNU_SOURCE" LDFLAGS="$(QUOTA_LDFLAGS)"

# Package uses autoconf but not automake.
QUOTA_INSTALL_TARGET_OPT = \
	ROOTDIR=$(TARGET_DIR) \
	install

$(eval $(autotools-package))
