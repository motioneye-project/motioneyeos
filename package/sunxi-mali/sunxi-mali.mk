################################################################################
#
# sunxi-mali
#
################################################################################

SUNXI_MALI_VERSION = d343311efc8db166d8371b28494f0f27b6a58724
SUNXI_MALI_SITE = $(call github,linux-sunxi,sunxi-mali,$(SUNXI_MALI_VERSION))

SUNXI_MALI_INSTALL_STAGING = YES
SUNXI_MALI_DEPENDENCIES = libump sunxi-mali-prop
SUNXI_MALI_PROVIDES = libegl libgles

# The options below must be provided in the environment.  Providing these
# through options overrides the value and prevents the makefiles from
# appending to these variables.  This is used throughout the sunxi-mali build
# system.
#
# Furthermore, the -lm -dl -lpthread options are included due to a possible bug
# in the way the linaro 2013.06 toolchain handles shared libraries.
SUNXI_MALI_MAKE_ENV = \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS) -lm -ldl -lpthread" \
	$(TARGET_MAKE_ENV)

ifeq ($(BR2_ARM_EABIHF),y)
SUNXI_MALI_MAKE_OPTS += ABI=armhf
else
SUNXI_MALI_MAKE_OPTS += ABI=armel
endif

SUNXI_MALI_MAKE_OPTS += EGL_TYPE=framebuffer

ifeq ($(BR2_PACKAGE_SUNXI_MALI_R2P4),y)
SUNXI_MALI_MAKE_OPTS += VERSION=r2p4
endif
ifeq ($(BR2_PACKAGE_SUNXI_MALI_R3P0),y)
SUNXI_MALI_MAKE_OPTS += VERSION=r3p0
endif
ifeq ($(BR2_PACKAGE_SUNXI_MALI_R3P1),y)
SUNXI_MALI_MAKE_OPTS += VERSION=r3p1
endif

define SUNXI_MALI_GIT_SUBMODULE_FIXUP
	rm -rf $(@D)/lib/mali
	cp -rf $(SUNXI_MALI_PROP_SRCDIR) $(@D)/lib/mali
endef

SUNXI_MALI_PRE_CONFIGURE_HOOKS += SUNXI_MALI_GIT_SUBMODULE_FIXUP

define SUNXI_MALI_BUILD_CMDS
	$(SUNXI_MALI_MAKE_ENV) $(MAKE) -C $(@D) $(SUNXI_MALI_MAKE_OPTS) all
	$(TARGET_CC) $(TARGET_CFLAGS) -o $(@D)/version/version \
		$(@D)/version/version.c
endef

define SUNXI_MALI_INSTALL_STAGING_CMDS
	$(SUNXI_MALI_MAKE_ENV) $(MAKE) -C $(@D) \
		$(SUNXI_MALI_MAKE_OPTS) DESTDIR=$(STAGING_DIR) install
	# test must be built after install because it depends on headers that are
	# generated during the install above.
	$(SUNXI_MALI_MAKE_ENV) $(MAKE) -C $(@D) $(SUNXI_MALI_MAKE_OPTS) test
	$(INSTALL) -D -m 0644 package/sunxi-mali/egl.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/egl.pc
	$(INSTALL) -D -m 0644 package/sunxi-mali/glesv2.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/glesv2.pc
endef

define SUNXI_MALI_INSTALL_TARGET_CMDS
	$(SUNXI_MALI_MAKE_ENV) $(MAKE) -C $(@D)/lib \
		$(SUNXI_MALI_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
	$(if $(BR2_PACKAGE_SUNXI_MALI_DBG),
		$(INSTALL) -m 755 $(@D)/version/version $(TARGET_DIR)/usr/bin/maliver; \
		$(INSTALL) -m 755 $(@D)/test/test $(TARGET_DIR)/usr/bin/malitest
	)
endef

define SUNXI_MALI_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/sunxi-mali/S80mali \
		$(TARGET_DIR)/etc/init.d/S80mali
endef

$(eval $(generic-package))
