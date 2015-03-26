################################################################################
#
# sysdig
#
################################################################################

SYSDIG_VERSION = 0.1.99
SYSDIG_SITE = $(call github,draios,sysdig,$(SYSDIG_VERSION))
SYSDIG_LICENSE = GPLv2
SYSDIG_LICENSE_FILES = COPYING
SYSDIG_CONF_OPTS = -DUSE_BUNDLED_LUAJIT=OFF -DUSE_BUNDLED_ZLIB=OFF \
	-DUSE_BUNDLED_JSONCPP=OFF
SYSDIG_DEPENDENCIES = zlib luajit jsoncpp linux
SYSDIG_SUPPORTS_IN_SOURCE_BUILD = NO

define SYSDIG_INSTALL_DRIVER
	$(MAKE) -C $(SYSDIG_BUILDDIR) $(LINUX_MAKE_FLAGS) KERNELDIR="$(LINUX_DIR)" install_driver
endef

SYSDIG_POST_INSTALL_TARGET_HOOKS += SYSDIG_INSTALL_DRIVER

$(eval $(cmake-package))
