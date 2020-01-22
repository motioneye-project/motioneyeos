################################################################################
#
# libevent
#
################################################################################

LIBEVENT_VERSION = 2.1.11
LIBEVENT_SITE = https://github.com/libevent/libevent/releases/download/release-$(LIBEVENT_VERSION)-stable
LIBEVENT_SOURCE = libevent-$(LIBEVENT_VERSION)-stable.tar.gz
LIBEVENT_INSTALL_STAGING = YES
LIBEVENT_LICENSE = BSD-3-Clause, OpenBSD
LIBEVENT_LICENSE_FILES = LICENSE
LIBEVENT_CONF_OPTS = \
	--disable-libevent-regress \
	--disable-samples
HOST_LIBEVENT_CONF_OPTS = \
	--disable-libevent-regress \
	--disable-samples \
	--disable-openssl

define LIBEVENT_REMOVE_PYSCRIPT
	rm $(TARGET_DIR)/usr/bin/event_rpcgen.py
endef

# libevent installs a python script to target - get rid of it if we
# don't have python support enabled
ifneq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
LIBEVENT_POST_INSTALL_TARGET_HOOKS += LIBEVENT_REMOVE_PYSCRIPT
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBEVENT_DEPENDENCIES += host-pkgconf openssl
LIBEVENT_CONF_OPTS += --enable-openssl
else
LIBEVENT_CONF_OPTS += --disable-openssl
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
