################################################################################
#
# redis
#
################################################################################

REDIS_VERSION = 3.0.5
REDIS_SITE = http://download.redis.io/releases
REDIS_LICENSE = BSD-3c (core); MIT and BSD family licenses (Bundled components)
REDIS_LICENSE_FILES = COPYING

define REDIS_USERS
	redis -1 redis -1 * /var/lib/redis /bin/false - Redis Server
endef

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
	$(INSTALL) -D -m 0644 $(@D)/redis.conf \
		$(TARGET_DIR)/etc/redis.conf
endef

define REDIS_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/redis/S50redis \
		$(TARGET_DIR)/etc/init.d/S50redis
endef

define REDIS_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/redis/redis.service \
		$(TARGET_DIR)/usr/lib/systemd/system/redis.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/redis.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/redis.service
endef

$(eval $(generic-package))
