################################################################################
#
# zeromq
#
################################################################################

ZEROMQ_VERSION = 4.1.3
ZEROMQ_SITE = http://download.zeromq.org
ZEROMQ_INSTALL_STAGING = YES
ZEROMQ_DEPENDENCIES = util-linux
ZEROMQ_LICENSE = LGPLv3+ with exceptions
ZEROMQ_LICENSE_FILES = COPYING COPYING.LESSER
# For 0001-acinclude.m4-make-kernel-specific-flags-cacheable.patch
ZEROMQ_AUTORECONF = YES

# Assume these flags are always available. It is true, at least for
# SOCK_CLOEXEC, since linux v2.6.27.
# Note: the flag TCP_KEEPALIVE is NOT available so we do not include it.
ZEROMQ_CONF_ENV = libzmq_cv_sock_cloexec=yes \
	libzmq_cv_so_keepalive=yes \
	libzmq_cv_tcp_keepcnt=yes \
	libzmq_cv_tcp_keepidle=yes \
	libzmq_cv_tcp_keepintvl=yes

# Only tools/curve_keygen.c needs this, but it doesn't hurt to pass it
# for the rest of the build as well (which automatically includes stdc++).
ifeq ($(BR2_STATIC_LIBS),y)
ZEROMQ_CONF_OPTS += LIBS=-lstdc++
endif

ifeq ($(BR2_PACKAGE_ZEROMQ_PGM),y)
ZEROMQ_DEPENDENCIES += host-pkgconf openpgm
ZEROMQ_CONF_OPTS += --with-system-pgm
endif

# ZeroMQ uses libsodium if it's available.
ifeq ($(BR2_PACKAGE_LIBSODIUM),y)
ZEROMQ_DEPENDENCIES += libsodium
ZEROMQ_CONF_OPTS += --with-libsodium="$(STAGING_DIR)/usr"
else
ZEROMQ_CONF_OPTS += --without-libsodium
endif

$(eval $(autotools-package))
