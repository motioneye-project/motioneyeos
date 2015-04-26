################################################################################
#
# tor
#
################################################################################

TOR_VERSION = 0.2.5.12
TOR_SITE = https://dist.torproject.org
TOR_LICENSE = BSD-3c
TOR_LICENSE_FILES = LICENSE
TOR_DEPENDENCIES = libevent openssl zlib
TOR_AUTORECONF = YES

TOR_CONF_OPTS = \
	--disable-gcc-hardening \
	--with-libevent-dir=$(STAGING_DIR)/usr \
	--with-openssl-dir=$(STAGING_DIR)/usr \
	--with-zlib-dir=$(STAGING_DIR)/usr

ifeq ($(BR2_STATIC_LIBS),y)
TOR_CONF_OPTS += \
	--enable-static-libevent \
	--enable-static-openssl \
	--enable-static-tor \
	--enable-static-zlib
endif

ifeq ($(BR2_arm)$(BR2_armeb)$(BR2_i386)$(BR2_x86_64)$(BR2_PACKAGE_LIBSECCOMP),yy)
TOR_CONF_OPTS += --enable-seccomp
TOR_DEPENDENCIES += libseccomp
else
TOR_CONF_OPTS += --disable-seccomp
endif

$(eval $(autotools-package))
