#############################################################
#
# libevent
#
#############################################################
LIBEVENT_VERSION = 1.4.12
LIBEVENT_SOURCE = libevent-$(LIBEVENT_VERSION)-stable.tar.gz
LIBEVENT_SITE = http://monkey.org/~provos/

LIBEVENT_AUTORECONF = NO
LIBEVENT_INSTALL_STAGING = YES
LIBEVENT_INSTALL_TARGET = YES

define LIBEVENT_REMOVE_PYSCRIPT
	rm $(TARGET_DIR)/usr/bin/event_rpcgen.py
endef

# libevent installs a python script to target - get rid of it if we
# don't have python support enabled
ifneq ($(BR2_PACKAGE_PYTHON),y)
LIBEVENT_POST_INSTALL_TARGET_HOOKS += LIBEVENT_REMOVE_PYSCRIPT
endif

$(eval $(call AUTOTARGETS,package,libevent))
