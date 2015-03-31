################################################################################
#
# haserl
#
################################################################################

HASERL_VERSION = 0.9.35
HASERL_SITE = http://downloads.sourceforge.net/project/haserl/haserl-devel
HASERL_LICENSE = GPLv2
HASERL_LICENSE_FILES = COPYING
HASERL_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_HASERL_WITH_LUA),y)
HASERL_CONF_OPTS += --with-lua
HASERL_DEPENDENCIES += lua

# liblua uses dlopen when dynamically linked
ifneq ($(BR2_STATIC_LIBS),y)
HASERL_CONF_ENV += LIBS="-ldl"
endif

else
HASERL_CONF_OPTS += --without-lua
endif

define HASERL_REMOVE_EXAMPLES
	rm -rf $(TARGET_DIR)/usr/share/haserl
endef

HASERL_POST_INSTALL_TARGET_HOOKS += HASERL_REMOVE_EXAMPLES

$(eval $(autotools-package))
