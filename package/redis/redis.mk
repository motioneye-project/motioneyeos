################################################################################
#
# redis
#
################################################################################

REDIS_VERSION = 2.6.17
REDIS_SITE = http://download.redis.io/releases
REDIS_LICENSE = BSD-3c (core); MIT and BSD family licenses (Bundled components)
REDIS_LICENSE_FILES = COPYING

# Redis doesn't support DESTDIR (yet, see
# https://github.com/antirez/redis/pull/609).  We set PREFIX
# instead.
REDIS_BUILDOPTS = $(TARGET_CONFIGURE_OPTS) \
	PREFIX=$(TARGET_DIR)/usr MALLOC=libc \

define REDIS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(REDIS_BUILDOPTS) -C $(@D)
endef

define REDIS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(REDIS_BUILDOPTS) -C $(@D) \
		LDCONFIG=true install
endef

$(eval $(generic-package))
