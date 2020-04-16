################################################################################
#
# sysrepo
#
################################################################################

SYSREPO_VERSION = 1.4.2
SYSREPO_SITE = $(call github,sysrepo,sysrepo,v$(SYSREPO_VERSION))
SYSREPO_INSTALL_STAGING = YES
SYSREPO_LICENSE = Apache-2.0
SYSREPO_LICENSE_FILES = LICENSE
SYSREPO_DEPENDENCIES = libyang pcre host-sysrepo
HOST_SYSREPO_DEPENDENCIES = host-libyang host-pcre

SYSREPO_CONF_OPTS = \
	-DCMAKE_BUILD_TYPE=Release \
	-DBUILD_EXAMPLES=$(if $(BR2_PACKAGE_SYSREPO_EXAMPLES),ON,OFF)

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
SYSREPO_CONF_OPTS += -DCMAKE_EXE_LINKER_FLAGS=-latomic
endif

define SYSREPO_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/sysrepo/S51sysrepo-plugind \
		$(TARGET_DIR)/etc/init.d/S51sysrepo-plugind
endef

HOST_SYSREPO_CONF_OPTS = \
	-DCMAKE_BUILD_TYPE=Release \
	-DBUILD_EXAMPLES=OFF \
	-DREPO_PATH=$(TARGET_DIR)/etc/sysrepo

$(eval $(cmake-package))
$(eval $(host-cmake-package))
