################################################################################
#
# cppzmq
#
################################################################################

CPPZMQ_VERSION = 1f05e0d111197c64be32ad5aecd59f4d1b05a819
CPPZMQ_SITE = $(call github,zeromq,cppzmq,$(CPPZMQ_VERSION))
CPPZMQ_INSTALL_STAGING = YES
CPPZMQ_DEPENDENCIES = zeromq
CPPZMQ_LICENSE = MIT
CPPZMQ_LICENSE_FILES = LICENSE

define CPPZMQ_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0644 -D $(@D)/zmq.hpp $(STAGING_DIR)/usr/include/zmq.hpp
endef

$(eval $(generic-package))
