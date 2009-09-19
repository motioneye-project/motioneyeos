#############################################################
#
# libevent
#
#############################################################
LIBEVENT_VERSION = 1.4.12
LIBEVENT_SOURCE = libevent-$(LIBEVENT_VERSION)-stable.tar.gz
LIBEVENT_SITE = http://monkey.org/~provos/

LIBEVENT_AUTORECONF = NO
LIBEVENT_LIBTOOL_PATCH = NO
LIBEVENT_INSTALL_STAGING = YES
LIBEVENT_INSTALL_TARGET = YES

$(eval $(call AUTOTARGETS,package,libevent))

ifneq ($(BR2_PACKAGE_PYTHON),y)
# libevent installs a python script to target - get rid of it if
# we don't have python support enabled
$(LIBEVENT_HOOK_POST_INSTALL):
	rm $(TARGET_DIR)/usr/bin/event_rpcgen.py
	touch $@
endif
