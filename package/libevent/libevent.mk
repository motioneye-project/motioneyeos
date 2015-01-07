################################################################################
#
# libevent
#
################################################################################

LIBEVENT_VERSION_MAJOR = 2.0
LIBEVENT_VERSION = $(LIBEVENT_VERSION_MAJOR).22-stable
LIBEVENT_SITE = http://downloads.sourceforge.net/project/levent/libevent/libevent-$(LIBEVENT_VERSION_MAJOR)
LIBEVENT_INSTALL_STAGING = YES
LIBEVENT_LICENSE = BSD-3c, OpenBSD
LIBEVENT_LICENSE_FILES = LICENSE
# For 0001-Disable-building-test-programs.patch
LIBEVENT_AUTORECONF = YES

define LIBEVENT_REMOVE_PYSCRIPT
	rm $(TARGET_DIR)/usr/bin/event_rpcgen.py
endef

# libevent installs a python script to target - get rid of it if we
# don't have python support enabled
ifneq ($(BR2_PACKAGE_PYTHON),y)
LIBEVENT_POST_INSTALL_TARGET_HOOKS += LIBEVENT_REMOVE_PYSCRIPT
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBEVENT_DEPENDENCIES += openssl
LIBEVENT_CONF_OPTS += --enable-openssl
else
LIBEVENT_CONF_OPTS += --disable-openssl
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
