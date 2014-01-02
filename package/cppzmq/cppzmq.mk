################################################################################
#
# cppzmq
#
################################################################################

CPPZMQ_VERSION = 235803740753312576495301ebf5b8ed76407173
CPPZMQ_SITE = git://github.com/zeromq/cppzmq.git
CPPZMQ_INSTALL_STAGING = YES
CPPZMQ_DEPENDENCIES = zeromq
CPPZMQ_LICENSE = MIT
CPPZMQ_LICENSE_FILES = LICENSE

define CPPZMQ_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0644 -D $(@D)/zmq.hpp $(STAGING_DIR)/usr/include/zmq.hpp
endef

$(eval $(generic-package))
