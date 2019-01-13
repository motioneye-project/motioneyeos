################################################################################
#
# haproxy
#
################################################################################

HAPROXY_VERSION_MAJOR = 1.9
HAPROXY_VERSION = $(HAPROXY_VERSION_MAJOR).1
HAPROXY_SITE = http://www.haproxy.org/download/$(HAPROXY_VERSION_MAJOR)/src
HAPROXY_LICENSE = GPL-2.0+ and LGPL-2.1+ with exceptions
HAPROXY_LICENSE_FILES = LICENSE doc/lgpl.txt doc/gpl.txt

HAPROXY_MAKE_OPTS = \
	LD=$(TARGET_CC) \
	PREFIX=/usr \
	TARGET=custom

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
HAPROXY_LIBS += -latomic
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
# threads uses atomics on gcc >= 4.7 and sync otherwise (see
# include/common/hathreads.h)
ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_4_7):$(BR2_TOOLCHAIN_HAS_ATOMIC),y:y)
HAPROXY_MAKE_OPTS += USE_THREAD=1
else ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_4_7):$(BR2_TOOLCHAIN_HAS_SYNC_4),:y)
HAPROXY_MAKE_OPTS += USE_THREAD=1
endif
endif

ifeq ($(BR2_PACKAGE_LUA_5_3),y)
HAPROXY_DEPENDENCIES += lua
HAPROXY_MAKE_OPTS += \
	LUA_LIB_NAME=lua \
	USE_LUA=1
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
HAPROXY_DEPENDENCIES += openssl
HAPROXY_MAKE_OPTS += USE_OPENSSL=1
ifeq ($(BR2_STATIC_LIBS),y)
HAPROXY_LIBS += -lz
endif
endif

# pcre and pcre2 can't be enabled at the same time so prefer pcre2
ifeq ($(BR2_PACKAGE_PCRE2),y)
HAPROXY_DEPENDENCIES += pcre2
HAPROXY_MAKE_OPTS += \
	PCRE2_CONFIG=$(STAGING_DIR)/usr/bin/pcre2-config \
	USE_PCRE2=1
else ifeq ($(BR2_PACKAGE_PCRE),y)
HAPROXY_DEPENDENCIES += pcre
HAPROXY_MAKE_OPTS += \
	PCRE_CONFIG=$(STAGING_DIR)/usr/bin/pcre-config \
	USE_PCRE=1
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
HAPROXY_DEPENDENCIES += systemd
HAPROXY_MAKE_OPTS += USE_SYSTEMD=1
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
HAPROXY_DEPENDENCIES += zlib
HAPROXY_MAKE_OPTS += USE_ZLIB=1
endif

HAPROXY_MAKE_OPTS += ADDLIB="$(HAPROXY_LIBS)"

define HAPROXY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(HAPROXY_MAKE_OPTS) -C $(@D)
endef

define HAPROXY_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(HAPROXY_MAKE_OPTS) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
