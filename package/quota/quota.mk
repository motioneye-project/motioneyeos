################################################################################
#
# quota
#
################################################################################

QUOTA_VERSION = 4.01
QUOTA_SITE = http://downloads.sourceforge.net/project/linuxquota/quota-tools/$(QUOTA_VERSION)
QUOTA_DEPENDENCIES = host-gettext
QUOTA_AUTORECONF = YES
QUOTA_LICENSE = GPLv2+
QUOTA_CONF_OPTS = --disable-strip-binaries

QUOTA_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
QUOTA_DEPENDENCIES += gettext
QUOTA_LIBS += -lintl
endif

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
QUOTA_DEPENDENCIES += libtirpc
QUOTA_CFLAGS += -I$(STAGING_DIR)/usr/include/tirpc/
QUOTA_LIBS += -ltirpc
endif

QUOTA_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS) CFLAGS="$(QUOTA_CFLAGS) -D_GNU_SOURCE" LIBS="$(QUOTA_LIBS)"
QUOTA_CONF_ENV = \
	CFLAGS="$(QUOTA_CFLAGS) -D_GNU_SOURCE" LIBS="$(QUOTA_LIBS)"

# Package uses autoconf but not automake.
QUOTA_INSTALL_TARGET_OPTS = \
	ROOTDIR=$(TARGET_DIR) \
	install

$(eval $(autotools-package))
