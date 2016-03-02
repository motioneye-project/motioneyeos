################################################################################
#
# libnspr
#
################################################################################

LIBNSPR_VERSION = 4.12
LIBNSPR_SOURCE = nspr-$(LIBNSPR_VERSION).tar.gz
LIBNSPR_SITE = https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v$(LIBNSPR_VERSION)/src
LIBNSPR_SUBDIR = nspr
LIBNSPR_INSTALL_STAGING = YES
LIBNSPR_CONFIG_SCRIPTS = nspr-config
LIBNSPR_LICENSE = MPLv2.0
LIBNSPR_LICENSE_FILES = nspr/LICENSE

# Set the host CFLAGS and LDFLAGS so NSPR does not guess wrongly
LIBNSPR_CONF_ENV = \
	HOST_CFLAGS="-g -O2" \
	HOST_LDFLAGS="-lc"
# NSPR mixes up --build and --host
LIBNSPR_CONF_OPTS = --host=$(GNU_HOST_NAME)
LIBNSPR_CONF_OPTS += --$(if $(BR2_ARCH_IS_64),en,dis)able-64bit

# ./nspr/pr/include/md/_linux.h tests only __GLIBC__ version to detect
# c-library features, list musl features here for now (taken from
# Alpine Linux).
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
LIBNSPR_CFLAGS += \
	-D_PR_POLL_AVAILABLE \
	-D_PR_HAVE_OFF64_T \
	-D_PR_INET6 \
	-D_PR_HAVE_INET_NTOP \
	-D_PR_HAVE_GETHOSTBYNAME2 \
	-D_PR_HAVE_GETADDRINFO \
	-D_PR_INET6_PROBE
endif

LIBNSPR_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) $(LIBNSPR_CFLAGS)"

ifeq ($(BR2_STATIC_LIBS),y)
LIBNSPR_MAKE_OPTS = SHARED_LIBRARY=
LIBNSPR_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) SHARED_LIBRARY= install
LIBNSPR_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) SHARED_LIBRARY= install
endif

ifeq ($(BR2_SHARED_LIBS),y)
LIBNSPR_MAKE_OPTS = LIBRARY=
LIBNSPR_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) LIBRARY= install
LIBNSPR_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) LIBRARY= install
endif

$(eval $(autotools-package))
