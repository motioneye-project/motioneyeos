################################################################################
#
# wget
#
################################################################################

WGET_VERSION = 1.15
WGET_SOURCE = wget-$(WGET_VERSION).tar.xz
WGET_SITE = $(BR2_GNU_MIRROR)/wget
WGET_LICENSE = GPLv3+
WGET_LICENSE_FILES = COPYING

# patching gnulib .m4 file
WGET_AUTORECONF = YES
WGET_GETTEXTIZE = YES

# Prefer full-blown wget over busybox
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
	WGET_DEPENDENCIES += busybox
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
	WGET_CONF_OPT += --with-ssl=gnutls \
		--with-libgnutls-prefix=$(STAGING_DIR)
	WGET_DEPENDENCIES += gnutls
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
	WGET_CONF_OPT += --with-ssl=openssl --with-libssl-prefix=$(STAGING_DIR)
	WGET_DEPENDENCIES += openssl
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBUUID),y)
	WGET_DEPENDENCIES += util-linux
endif

# --with-ssl is default
ifneq ($(BR2_PACKAGE_GNUTLS),y)
ifneq ($(BR2_PACKAGE_OPENSSL),y)
	WGET_CONF_OPT += --without-ssl
endif
endif

$(eval $(autotools-package))
