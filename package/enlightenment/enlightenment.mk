################################################################################
#
# enlightenment
#
################################################################################

ENLIGHTENMENT_VERSION = 0.22.1
ENLIGHTENMENT_SOURCE = enlightenment-$(ENLIGHTENMENT_VERSION).tar.xz
ENLIGHTENMENT_SITE = http://download.enlightenment.org/rel/apps/enlightenment
ENLIGHTENMENT_LICENSE = BSD-2-Clause
ENLIGHTENMENT_LICENSE_FILES = COPYING

ENLIGHTENMENT_DEPENDENCIES = \
	host-pkgconf \
	host-efl \
	host-meson \
	efl \
	xcb-util-keysyms

ENLIGHTENMENT_MESON_OPTS += \
	--prefix=/usr \
	--buildtype=$(if $(BR2_ENABLE_DEBUG),debug,release) \
	--cross-file=$(HOST_DIR)/etc/meson/cross-compilation.conf \
	-Dedje-cc=$(HOST_DIR)/bin/edje_cc \
	-Deet-eet=$(HOST_DIR)/bin/eet \
	-Deldbus_codegen=$(HOST_DIR)/bin/eldbus-codegen \
	-Dpam=false \
	-Drpath=false

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
ENLIGHTENMENT_MESON_OPTS += -Dsystemd=true
ENLIGHTENMENT_DEPENDENCIES += systemd
else
ENLIGHTENMENT_MESON_OPTS += -Dsystemd=false
endif

# alsa backend needs mixer support
ifeq ($(BR2_PACKAGE_ALSA_LIB)$(BR2_PACKAGE_ALSA_LIB_MIXER),yy)
ENLIGHTENMENT_MESON_OPTS += -Dmixer=true
ENLIGHTENMENT_DEPENDENCIES += alsa-lib
else
ENLIGHTENMENT_MESON_OPTS += -Dmixer=false
endif

define ENLIGHTENMENT_CONFIGURE_CMDS
	rm -rf $(@D)/build
	mkdir -p $(@D)/build
	$(TARGET_MAKE_ENV) meson $(ENLIGHTENMENT_MESON_OPTS) $(@D) $(@D)/build
endef

define ENLIGHTENMENT_BUILD_CMDS
	$(TARGET_MAKE_ENV) ninja -C $(@D)/build
endef

define ENLIGHTENMENT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) DESTDIR=$(TARGET_DIR) ninja -C $(@D)/build install
endef

define ENLIGHTENMENT_REMOVE_DOCUMENTATION
	rm -rf $(TARGET_DIR)/usr/share/enlightenment/doc/
	rm -f $(TARGET_DIR)/usr/share/enlightenment/COPYING
	rm -f $(TARGET_DIR)/usr/share/enlightenment/AUTHORS
endef
ENLIGHTENMENT_POST_INSTALL_TARGET_HOOKS += ENLIGHTENMENT_REMOVE_DOCUMENTATION

$(eval $(generic-package))
