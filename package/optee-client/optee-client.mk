################################################################################
#
# optee-client
#
################################################################################

OPTEE_CLIENT_VERSION = 3.7.0
OPTEE_CLIENT_SITE = $(call github,OP-TEE,optee_client,$(OPTEE_CLIENT_VERSION))
OPTEE_CLIENT_LICENSE = BSD-2-Clause
OPTEE_CLIENT_LICENSE_FILES = LICENSE
OPTEE_CLIENT_INSTALL_STAGING = YES

define OPTEE_CLIENT_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D $(OPTEE_CLIENT_PKGDIR)/S30optee \
		$(TARGET_DIR)/etc/init.d/S30optee
endef

$(eval $(cmake-package))
