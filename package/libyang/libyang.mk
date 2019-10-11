################################################################################
#
# libyang
#
################################################################################

LIBYANG_VERSION = v1.0-r3
LIBYANG_SITE = $(call github,CESNET,libyang,$(LIBYANG_VERSION))
LIBYANG_LICENSE = BSD-3-Clause
LIBYANG_LICENSE_FILES = LICENSE
LIBYANG_INSTALL_STAGING = YES
LIBYANG_SUPPORTS_IN_SOURCE_BUILD = NO
LIBYANG_DEPENDENCIES = pcre
HOST_LIBYANG_DEPENDENCIES = host-pcre

LIBYANG_CONF_OPTS = \
	-DENABLE_VALGRIND_TESTS=OFF \
	-DGEN_PYTHON_BINDINGS=OFF

HOST_LIBYANG_CONF_OPTS = \
	-DENABLE_VALGRIND_TESTS=OFF \
	-DGEN_PYTHON_BINDINGS=OFF

$(eval $(cmake-package))
$(eval $(host-cmake-package))
