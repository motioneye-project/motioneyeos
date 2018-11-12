################################################################################
#
# terminology
#
################################################################################

TERMINOLOGY_VERSION = 1.2.1
TERMINOLOGY_SOURCE = terminology-$(TERMINOLOGY_VERSION).tar.xz
TERMINOLOGY_SITE = https://download.enlightenment.org/rel/apps/terminology
TERMINOLOGY_LICENSE = BSD-2-Clause
TERMINOLOGY_LICENSE_FILES = COPYING

TERMINOLOGY_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES) efl host-meson host-pkgconf
TERMINOLOGY_MESON_OPTS = \
	--prefix=/usr \
	--buildtype=$(if $(BR2_ENABLE_DEBUG),debug,release) \
	--cross-file=$(HOST_DIR)/etc/meson/cross-compilation.conf \
	-Dedje-cc=$(HOST_DIR)/bin/edje_cc

ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
TERMINOLOGY_MESON_OPTS += -Dnls=true
else
TERMINOLOGY_MESON_OPTS += -Dnls=false
endif

define TERMINOLOGY_CONFIGURE_CMDS
	rm -rf $(@D)/build
	mkdir -p $(@D)/build
	$(TARGET_MAKE_ENV) meson $(TERMINOLOGY_MESON_OPTS) $(@D) $(@D)/build
endef

define TERMINOLOGY_BUILD_CMDS
	$(TARGET_MAKE_ENV) ninja -C $(@D)/build
endef

define TERMINOLOGY_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) DESTDIR=$(TARGET_DIR) ninja -C $(@D)/build install
endef

$(eval $(generic-package))
