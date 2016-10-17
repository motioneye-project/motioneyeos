################################################################################
#
# ti-sgx-um
#
################################################################################

# This correpsonds to SDK 02.00.00.00
TI_SGX_UM_VERSION = e15f1543bab4de9e8927a2c4934addf3fd16ffcb
TI_SGX_UM_SITE = git://git.ti.com/graphics/omap5-sgx-ddk-um-linux.git
TI_SGX_UM_LICENSE = TI TSPA License
TI_SGX_UM_LICENSE_FILES = OMAP5-Linux-Graphics-DDK-UM-Manifest.doc
TI_SGX_UM_INSTALL_STAGING = YES

# ti-sgx-um is a egl/gles provider only if libdrm is installed
TI_SGX_UM_DEPENDENCIES = libdrm

define TI_SGX_UM_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DISCIMAGE=$(STAGING_DIR) install
endef

define TI_SGX_UM_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DISCIMAGE=$(TARGET_DIR) install
endef

# libs use the following file for configuration
define TI_SGX_UM_INSTALL_CONF
	$(INSTALL) -D -m 0644 package/ti-sgx-um/powervr.ini \
		$(TARGET_DIR)/etc/powervr.ini
endef

TI_SGX_UM_POST_INSTALL_TARGET_HOOKS += TI_SGX_UM_INSTALL_CONF

define TI_SGX_UM_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/ti-sgx-um/S80ti-sgx \
		$(TARGET_DIR)/etc/init.d/S80ti-sgx
endef

$(eval $(generic-package))
