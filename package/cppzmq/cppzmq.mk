################################################################################
#
# cppzmq
#
################################################################################

CPPZMQ_VERSION = v4.3.0
CPPZMQ_SITE = $(call github,zeromq,cppzmq,$(CPPZMQ_VERSION))
CPPZMQ_INSTALL_STAGING = YES
CPPZMQ_DEPENDENCIES = host-pkgconf zeromq
CPPZMQ_LICENSE = MIT
CPPZMQ_LICENSE_FILES = LICENSE
CPPZMQ_CONF_OPTS = -DCPPZMQ_BUILD_TESTS=OFF

$(eval $(cmake-package))
