################################################################################
#
# cppzmq
#
################################################################################

CPPZMQ_VERSION = 68a7b09cfce01c4c279fba2cf91686fcfc566848
CPPZMQ_SITE = $(call github,zeromq,cppzmq,$(CPPZMQ_VERSION))
CPPZMQ_INSTALL_STAGING = YES
CPPZMQ_DEPENDENCIES = zeromq
CPPZMQ_LICENSE = MIT
CPPZMQ_LICENSE_FILES = LICENSE

define CPPZMQ_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0644 -D $(@D)/zmq.hpp $(STAGING_DIR)/usr/include/zmq.hpp
endef

$(eval $(generic-package))
