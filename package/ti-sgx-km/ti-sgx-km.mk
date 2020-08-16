################################################################################
#
# ti-sgx-km
#
################################################################################

# This correpsonds to SDK 06.00.00.07
TI_SGX_KM_VERSION = 4519ed3b83d1d72207ddc2874c7eb5e5a7f20d8d
TI_SGX_KM_SITE = http://git.ti.com/git/graphics/omap5-sgx-ddk-linux.git
TI_SGX_KM_SITE_METHOD = git
TI_SGX_KM_LICENSE = GPL-2.0
TI_SGX_KM_LICENSE_FILES = eurasia_km/GPL-COPYING

TI_SGX_KM_DEPENDENCIES = linux

TI_SGX_KM_MAKE_OPTS = \
	$(LINUX_MAKE_FLAGS) \
	KERNELDIR=$(LINUX_DIR) \
	TARGET_PRODUCT=$(TI_SGX_KM_PLATFORM_NAME)

TI_SGX_KM_PLATFORM_NAME = ti335x

TI_SGX_KM_SUBDIR = eurasia_km/eurasiacon/build/linux2/omap_linux

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
