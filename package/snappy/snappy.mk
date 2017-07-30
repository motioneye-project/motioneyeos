################################################################################
#
# snappy
#
################################################################################

SNAPPY_VERSION = 32d6d7d8a2ef328a2ee1dd40f072e21f4983ebda
SNAPPY_SITE = $(call github,google,snappy,$(SNAPPY_VERSION))
SNAPPY_LICENSE = BSD-3-Clause
SNAPPY_LICENSE_FILES = COPYING
# from git
SNAPPY_AUTORECONF = YES
SNAPPY_DEPENDENCIES = host-pkgconf
SNAPPY_INSTALL_STAGING = YES

# Disable tests
SNAPPY_CONF_OPTS = --disable-gtest

# libsnappy links with libstdc++. Some libstdc++/arch variants use
# pthread symbols for internal locking if built with thread
# support. libstdc++ does not have a .pc file, and its .la file does
# not mention -pthread.  So, static linkig to libstdc++ will fail if
# -pthread is not explicity linked to. Only do that for static builds.
ifeq ($(BR2_STATIC_LIBS)$(BR2_TOOLCHAIN_HAS_THREADS),yy)
SNAPPY_CONF_OPTS += LIBS=-pthread
endif

$(eval $(autotools-package))
