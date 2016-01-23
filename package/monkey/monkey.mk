################################################################################
#
# monkey
#
################################################################################

MONKEY_VERSION_MAJOR = 1.5
MONKEY_VERSION = $(MONKEY_VERSION_MAJOR).6
MONKEY_SITE = http://monkey-project.com/releases/$(MONKEY_VERSION_MAJOR)
MONKEY_LICENSE = Apache-2.0
MONKEY_LICENSE_FILES = LICENSE

# This package has a configure script, but it's not using
# autoconf/automake, so we're using the generic-package
# infrastructure.

MONKEY_CONF_OPTS = \
	--prefix=/usr \
	--sysconfdir=/etc/monkey \
	--datadir=/var/www \
	--mandir=/usr/share/man \
	--logdir=/var/log \
	--pidfile=/var/run \
	--plugdir=/usr/lib/monkey \
	--malloc-libc

# --uclib-mode is not a typo
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
MONKEY_CONF_OPTS += --uclib-mode --no-backtrace
endif

ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
MONKEY_CONF_OPTS += --musl-mode --no-backtrace
endif

ifeq ($(BR2_PACKAGE_MONKEY_SHARED),y)
MONKEY_CONF_OPTS += --enable-shared
MONKEY_INSTALL_STAGING = YES
else
# Even without --enable-shared, the monkey build system leaves a
# broken libmonkey.so symbolic link.
define MONKEY_REMOVE_DANGLING_SYMLINK
	$(RM) -f $(TARGET_DIR)/usr/lib/libmonkey.so
endef
MONKEY_POST_INSTALL_TARGET_HOOKS += MONKEY_REMOVE_DANGLING_SYMLINK
endif

ifeq ($(BR2_ENABLE_DEBUG),y)
MONKEY_CONF_OPTS += --debug
endif

define MONKEY_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(MONKEY_CONF_OPTS))
endef

define MONKEY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define MONKEY_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

define MONKEY_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
