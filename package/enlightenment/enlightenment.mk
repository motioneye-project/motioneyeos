################################################################################
#
# enlightenment
#
################################################################################

ENLIGHTENMENT_VERSION = 0.23.0
ENLIGHTENMENT_SOURCE = enlightenment-$(ENLIGHTENMENT_VERSION).tar.xz
ENLIGHTENMENT_SITE = http://download.enlightenment.org/rel/apps/enlightenment
ENLIGHTENMENT_LICENSE = BSD-2-Clause
ENLIGHTENMENT_LICENSE_FILES = COPYING

ENLIGHTENMENT_DEPENDENCIES = \
	host-pkgconf \
	host-efl \
	efl \
	xcb-util-keysyms

ENLIGHTENMENT_CONF_OPTS = \
	-Dedje-cc=$(HOST_DIR)/bin/edje_cc \
	-Deet=$(HOST_DIR)/bin/eet \
	-Deldbus-codegen=$(HOST_DIR)/bin/eldbus-codegen \
	-Dpam=false

# enlightenment.pc and /usr/lib/enlightenment/modules/*.so
ENLIGHTENMENT_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
ENLIGHTENMENT_CONF_OPTS += -Dsystemd=true
ENLIGHTENMENT_DEPENDENCIES += systemd
else
ENLIGHTENMENT_CONF_OPTS += -Dsystemd=false
endif

# alsa backend needs mixer support
ifeq ($(BR2_PACKAGE_ALSA_LIB)$(BR2_PACKAGE_ALSA_LIB_MIXER),yy)
ENLIGHTENMENT_CONF_OPTS += -Dmixer=true
ENLIGHTENMENT_DEPENDENCIES += alsa-lib
else
ENLIGHTENMENT_CONF_OPTS += -Dmixer=false
endif

ifeq ($(BR2_PACKAGE_XKEYBOARD_CONFIG),y)
ENLIGHTENMENT_DEPENDENCIES += xkeyboard-config
endif

define ENLIGHTENMENT_REMOVE_DOCUMENTATION
	rm -rf $(TARGET_DIR)/usr/share/enlightenment/doc/
	rm -f $(TARGET_DIR)/usr/share/enlightenment/COPYING
	rm -f $(TARGET_DIR)/usr/share/enlightenment/AUTHORS
endef
ENLIGHTENMENT_POST_INSTALL_TARGET_HOOKS += ENLIGHTENMENT_REMOVE_DOCUMENTATION

$(eval $(meson-package))
