################################################################################
#
# cppzmq
#
################################################################################

CPPZMQ_VERSION = b232978
CPPZMQ_SITE = git://github.com/zeromq/cppzmq.git
CPPZMQ_INSTALL_STAGING = YES
CPPZMQ_DEPENDENCIES = zeromq
CPPZMQ_LICENSE = MIT
# No license file, the license is in the installed header
CPPZMQ_LICENSE_FILES = zmq.hpp

define CPPZMQ_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0644 -D $(@D)/zmq.hpp $(STAGING_DIR)/usr/include/zmq.hpp
endef

define CPPZMQ_UNINSTALL_STAGING_CMDS
	$(RM) $(STAGING_DIR)/usr/include/zmq.hpp
endef

$(eval $(generic-package))
