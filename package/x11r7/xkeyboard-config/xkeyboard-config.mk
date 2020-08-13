################################################################################
#
# xkeyboard-config
#
################################################################################

XKEYBOARD_CONFIG_VERSION = 2.29
XKEYBOARD_CONFIG_SOURCE = xkeyboard-config-$(XKEYBOARD_CONFIG_VERSION).tar.bz2
XKEYBOARD_CONFIG_SITE = https://www.x.org/releases/individual/data/xkeyboard-config
XKEYBOARD_CONFIG_LICENSE = MIT
XKEYBOARD_CONFIG_LICENSE_FILES = COPYING

XKEYBOARD_CONFIG_DEPENDENCIES = \
	$(BR2_PYTHON3_HOST_DEPENDENCY) \
	host-gettext \
	host-xapp_xkbcomp

# xkeyboard-config.pc
XKEYBOARD_CONFIG_INSTALL_STAGING = YES

XKEYBOARD_CONFIG_CONF_OPTS = --disable-runtime-deps

$(eval $(autotools-package))
