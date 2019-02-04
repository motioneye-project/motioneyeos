################################################################################
#
# utp_com
#
################################################################################

UTP_COM_VERSION = dee512ced1e9367d223d22f10797fbf9aeacfab6
UTP_COM_SITE = $(call github,freescale,utp_com,$(UTP_COM_VERSION))
UTP_COM_LICENSE = GPL-2.0+
UTP_COM_LICENSE_FILES = LICENSE
HOST_UTP_COM_DEPENDENCIES = host-sg3_utils

define HOST_UTP_COM_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define HOST_UTP_COM_INSTALL_CMDS
	$(INSTALL) -D -m 755 $(@D)/utp_com $(HOST_DIR)/bin/utp_com
endef

$(eval $(host-generic-package))
