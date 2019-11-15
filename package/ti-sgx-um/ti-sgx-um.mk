################################################################################
#
# ti-sgx-um
#
################################################################################

# This correpsonds to SDK 06.00.00.07 plus one pull request
TI_SGX_UM_VERSION = 2a2e5bb090ced870d73ed4edbc54793e952cc6d8
TI_SGX_UM_SITE = http://git.ti.com/git/graphics/omap5-sgx-ddk-um-linux.git
TI_SGX_UM_SITE_METHOD = git
TI_SGX_UM_LICENSE = TI TSPA License
TI_SGX_UM_LICENSE_FILES = TI-Linux-Graphics-DDK-UM-Manifest.doc
TI_SGX_UM_INSTALL_STAGING = YES
TI_SGX_UM_TARGET=ti335x

# ti-sgx-um is a egl/gles provider only if libdrm is installed
TI_SGX_UM_DEPENDENCIES = libdrm wayland

define TI_SGX_UM_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DISCIMAGE=$(STAGING_DIR) \
		TARGET_PRODUCT=$(TI_SGX_UM_TARGET) install
endef

define TI_SGX_UM_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DISCIMAGE=$(TARGET_DIR) \
		TARGET_PRODUCT=$(TI_SGX_UM_TARGET) install
endef

TI_SGX_UM_POST_INSTALL_TARGET_HOOKS += TI_SGX_UM_INSTALL_CONF

define TI_SGX_UM_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/ti-sgx-um/S80ti-sgx \
		$(TARGET_DIR)/etc/init.d/S80ti-sgx
endef

$(eval $(generic-package))
