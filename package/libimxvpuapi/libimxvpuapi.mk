################################################################################
#
# libimxvpuapi
#
################################################################################

LIBIMXVPUAPI_VERSION = 0.10.1
LIBIMXVPUAPI_SITE = $(call github,Freescale,libimxvpuapi,$(LIBIMXVPUAPI_VERSION))
LIBIMXVPUAPI_LICENSE = LGPLv2.1+
LIBIMXVPUAPI_LICENSE_FILES = LICENSE
LIBIMXVPUAPI_DEPENDENCIES = host-pkgconf host-python imx-vpu
LIBIMXVPUAPI_INSTALL_STAGING = YES

define LIBIMXVPUAPI_CONFIGURE_CMDS
	cd $(@D); \
	$(TARGET_CONFIGURE_OPTS) $(HOST_DIR)/usr/bin/python2 ./waf configure \
		--prefix=/usr --libdir=/usr/lib
endef

define LIBIMXVPUAPI_BUILD_CMDS
	cd $(@D); \
	$(HOST_DIR)/usr/bin/python2 ./waf build -j $(PARALLEL_JOBS)
endef

define LIBIMXVPUAPI_INSTALL_STAGING_CMDS
	cd $(@D); \
	$(HOST_DIR)/usr/bin/python2 ./waf --destdir=$(STAGING_DIR) install
endef

define LIBIMXVPUAPI_INSTALL_TARGET_CMDS
	cd $(@D); \
	$(HOST_DIR)/usr/bin/python2 ./waf --destdir=$(TARGET_DIR) install
endef

$(eval $(generic-package))
