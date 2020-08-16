################################################################################
#
# ibm-sw-tpm2
#
################################################################################

IBM_SW_TPM2_VERSION = 1563
IBM_SW_TPM2_SOURCE = ibmtpm$(IBM_SW_TPM2_VERSION).tar.gz
IBM_SW_TPM2_SITE = https://sourceforge.net/projects/ibmswtpm2/files
IBM_SW_TPM2_LICENSE = BSD-3-Clause
IBM_SW_TPM2_LICENSE_FILES = LICENSE
IBM_SW_TPM2_DEPENDENCIES = openssl

define IBM_SW_TPM2_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src $(TARGET_CONFIGURE_OPTS)
endef

define IBM_SW_TPM2_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src $(TARGET_CONFIGURE_OPTS) install \
		DESTDIR=$(TARGET_DIR)
endef

$(eval $(generic-package))
