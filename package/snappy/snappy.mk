################################################################################
#
# snappy
#
################################################################################

SNAPPY_VERSION = be6dc3db83c4701e3e79694dcbfd1c3da03b91dd
SNAPPY_SITE = $(call github,google,snappy,$(SNAPPY_VERSION))
SNAPPY_LICENSE = BSD-3-Clause
SNAPPY_LICENSE_FILES = COPYING
SNAPPY_INSTALL_STAGING = YES
SNAPPY_CONF_OPTS = -DSNAPPY_BUILD_TESTS=OFF

# libsnappy links with libstdc++. Some libstdc++/arch variants use
# pthread symbols for internal locking if built with thread
# support. libstdc++ does not have a .pc file, and its .la file does
# not mention -pthread.  So, static linkig to libstdc++ will fail if
# -pthread is not explicity linked to. Only do that for static builds.
ifeq ($(BR2_STATIC_LIBS)$(BR2_TOOLCHAIN_HAS_THREADS),yy)
SNAPPY_CONF_OPTS += LIBS=-pthread
endif

$(eval $(cmake-package))
