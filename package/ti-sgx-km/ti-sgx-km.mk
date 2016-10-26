################################################################################
#
# ti-sgx-km
#
################################################################################

# This correpsonds to SDK 02.00.00.00
TI_SGX_KM_VERSION = 2b7523d07a13ab704a24a7664749551f4a13ed32
TI_SGX_KM_SITE = git://git.ti.com/graphics/omap5-sgx-ddk-linux.git
TI_SGX_KM_LICENSE = GPLv2
TI_SGX_KM_LICENSE_FILES = GPL-COPYING

TI_SGX_KM_DEPENDENCIES = linux

TI_SGX_KM_MAKE_OPTS = \
	$(LINUX_MAKE_FLAGS) \
	KERNELDIR=$(LINUX_DIR) \
	PVR_NULLDRM=1

ifeq ($(BR2_PACKAGE_TI_SGX_AM335X),y)
TI_SGX_KM_PLATFORM_NAME = omap335x
else ifeq ($(BR2_PACKAGE_TI_SGX_AM437X),y)
TI_SGX_KM_PLATFORM_NAME = omap437x
else ifeq ($(BR2_PACKAGE_TI_SGX_AM4430),y)
TI_SGX_KM_PLATFORM_NAME = omap4430
else ifeq ($(BR2_PACKAGE_TI_SGX_5430),y)
TI_SGX_KM_PLATFORM_NAME = omap5430
endif

TI_SGX_KM_SUBDIR = eurasia_km/eurasiacon/build/linux2/$(TI_SGX_KM_PLATFORM_NAME)_linux

define TI_SGX_KM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TI_SGX_KM_MAKE_OPTS) \
		-C $(@D)/$(TI_SGX_KM_SUBDIR)
endef

define TI_SGX_KM_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TI_SGX_KM_MAKE_OPTS) \
		DISCIMAGE=$(TARGET_DIR) \
		kbuild_install -C $(@D)/$(TI_SGX_KM_SUBDIR)
endef

$(eval $(generic-package))
