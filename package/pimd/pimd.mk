################################################################################
#
# pimd
#
################################################################################

PIMD_VERSION = 2.3.2
PIMD_SITE = https://github.com/troglobit/pimd/releases/download/$(PIMD_VERSION)

PIMD_LICENSE = BSD-3-Clause
PIMD_LICENSE_FILES = LICENSE LICENSE.mrouted

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC)$(BR2_TOOLCHAIN_USES_MUSL),y)
PIMD_CONF_OPTS += --embedded-libc
endif

# The configure script is not autoconf based, so we use the
# generic-package infrastructure
define PIMD_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure $(PIMD_CONF_OPTS) \
	)
endef

define PIMD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CROSS=$(TARGET_CROSS) \
		CC=$(TARGET_CC) -C $(@D)
endef

define PIMD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) \
		prefix=/usr -C $(@D) install
endef

$(eval $(generic-package))
