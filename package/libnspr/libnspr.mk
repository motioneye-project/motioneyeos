################################################################################
#
# libnspr
#
################################################################################

LIBNSPR_VERSION = 4.10.7
LIBNSPR_SOURCE = nspr-$(LIBNSPR_VERSION).tar.gz
LIBNSPR_SITE = https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v$(LIBNSPR_VERSION)/src
LIBNSPR_SUBDIR = nspr
LIBNSPR_INSTALL_STAGING = YES
LIBNSPR_CONFIG_SCRIPTS = nspr-config
LIBNSPR_LICENSE = MPLv2.0
LIBNSPR_LICENSE_FILES = nspr/LICENSE

# Set the host CFLAGS and LDFLAGS so NSPR does not guess wrongly
LIBNSPR_CONF_ENV = HOST_CFLAGS="-g -O2" \
		   HOST_LDFLAGS="-lc"
# NSPR mixes up --build and --host
LIBNSPR_CONF_OPTS = --host=$(GNU_HOST_NAME)
LIBNSPR_CONF_OPTS += --$(if $(BR2_ARCH_IS_64),en,dis)able-64bit
LIBNSPR_CONF_OPTS += --$(if $(BR2_INET_IPV6),en,dis)able-ipv6

ifeq ($(BR2_PREFER_STATIC_LIB),y)
LIBNSPR_MAKE_OPTS = SHARED_LIBRARY=
LIBNSPR_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) SHARED_LIBRARY= install
LIBNSPR_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) SHARED_LIBRARY= install
endif

ifeq ($(BR2_arm),y)
ifeq ($(BR2_ARM_CPU_HAS_THUMB2),y)
LIBNSPR_CONF_OPTS += --enable-thumb2
else
LIBNSPR_CONF_OPTS += --disable-thumb2
endif
endif

$(eval $(autotools-package))
