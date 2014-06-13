################################################################################
#
# haserl
#
################################################################################

HASERL_VERSION = $(call qstrip,$(BR2_PACKAGE_HASERL_VERSION))
ifeq ($(BR2_PACKAGE_HASERL_VERSION_0_8_X),y)
HASERL_SITE = http://downloads.sourceforge.net/project/haserl/haserl/$(HASERL_VERSION)
else
HASERL_SITE = http://downloads.sourceforge.net/project/haserl/haserl-devel
endif
HASERL_LICENSE = GPLv2
HASERL_LICENSE_FILES = COPYING
HASERL_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_HASERL_WITH_LUA),y)
	HASERL_CONF_OPT += --with-lua
	HASERL_DEPENDENCIES += lua host-lua

# liblua uses dlopen when dynamically linked
ifneq ($(BR2_PREFER_STATIC_LIB),y)
	HASERL_CONF_ENV += LIBS="-ldl"
endif

	# lua2c is built for host, so needs to find host libs/headers
	HASERL_MAKE_OPT += lua2c_LDFLAGS='$(HOST_CFLAGS) $(HOST_LDFLAGS)'
else
	HASERL_CONF_OPT += --without-lua
endif

define HASERL_REMOVE_EXAMPLES
	rm -rf $(TARGET_DIR)/usr/share/haserl
endef

HASERL_POST_INSTALL_TARGET_HOOKS += HASERL_REMOVE_EXAMPLES

$(eval $(autotools-package))
