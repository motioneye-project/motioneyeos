################################################################################
#
# libevent
#
################################################################################

LIBEVENT_VERSION = release-2.0.21-stable
LIBEVENT_SITE = $(call github,libevent,libevent,$(LIBEVENT_VERSION))
LIBEVENT_INSTALL_STAGING = YES
LIBEVENT_LICENSE = BSD-3c, OpenBSD
LIBEVENT_LICENSE_FILES = LICENSE
# Straight from the repository, need to generate autotools files
LIBEVENT_AUTORECONF = YES

define LIBEVENT_REMOVE_PYSCRIPT
	rm $(TARGET_DIR)/usr/bin/event_rpcgen.py
endef

# libevent installs a python script to target - get rid of it if we
# don't have python support enabled
ifneq ($(BR2_PACKAGE_PYTHON),y)
LIBEVENT_POST_INSTALL_TARGET_HOOKS += LIBEVENT_REMOVE_PYSCRIPT
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
