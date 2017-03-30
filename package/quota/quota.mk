################################################################################
#
# quota
#
################################################################################

QUOTA_VERSION = 4.01
QUOTA_SITE = http://downloads.sourceforge.net/project/linuxquota/quota-tools/$(QUOTA_VERSION)
QUOTA_DEPENDENCIES = host-gettext
QUOTA_AUTORECONF = YES
QUOTA_LICENSE = GPL-2.0+
QUOTA_CONF_OPTS = --disable-strip-binaries

QUOTA_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
QUOTA_DEPENDENCIES += gettext
QUOTA_LIBS += -lintl
endif

ifeq ($(BR2_PACKAGE_E2FSPROGS),y)
QUOTA_DEPENDENCIES += e2fsprogs
QUOTA_CONF_OPTS += --enable-ext2direct
# quote does not use pkg-config to find e2fsprogs, so it does not know it
# may require -pthreads in case of static build
ifeq ($(BR2_STATIC_LIBS)$(BR2_TOOLCHAIN_HAS_THREADS),yy)
QUOTA_LIBS += -pthread
endif
else
QUOTA_CONF_OPTS += --disable-ext2direct
endif

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
QUOTA_DEPENDENCIES += libtirpc host-pkgconf
QUOTA_CFLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags libtirpc`
QUOTA_LIBS += `$(PKG_CONFIG_HOST_BINARY) --libs libtirpc`
endif

QUOTA_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS) CFLAGS="$(QUOTA_CFLAGS) -D_GNU_SOURCE" LIBS="$(QUOTA_LIBS)"
QUOTA_CONF_ENV = \
	CFLAGS="$(QUOTA_CFLAGS) -D_GNU_SOURCE" LIBS="$(QUOTA_LIBS)"

# Package uses autoconf but not automake.
QUOTA_INSTALL_TARGET_OPTS = \
	ROOTDIR=$(TARGET_DIR) \
	install

$(eval $(autotools-package))
