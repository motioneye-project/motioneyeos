################################################################################
#
# uvw
#
################################################################################

UVW_VERSION = 2.3.1_libuv-v1.34
UVW_SITE = $(call github,skypjack,uvw,v$(UVW_VERSION))
UVW_INSTALL_STAGING = YES
UVW_INSTALL_TARGET = NO
UVW_SUPPORTS_IN_SOURCE_BUILD = NO
UVW_DEPENDENCIES = libuv
UVW_LICENSE = MIT
UVW_LICENSE_FILES = LICENSE

# The following CMake variable disables a TRY_RUN call in the -pthread
# test which is not allowed when cross-compiling (for cmake < 3.10)
UVW_CONF_OPTS = -DTHREADS_PTHREAD_ARG=OFF

$(eval $(cmake-package))
