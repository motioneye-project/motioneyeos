################################################################################
#
# zynq-boot-bin
#
################################################################################

ZYNQ_BOOT_BIN_VERSION = 2015.1
ZYNQ_BOOT_BIN_SOURCE = zynq-boot-bin.py
ZYNQ_BOOT_BIN_SITE = https://raw.githubusercontent.com/Xilinx/u-boot-xlnx/xilinx-v$(ZYNQ_BOOT_BIN_VERSION)/tools
ZYNQ_BOOT_BIN_LICENSE = GPL-3.0+

HOST_ZYNQ_BOOT_BIN_DEPENDENCIES = host-python

define HOST_ZYNQ_BOOT_BIN_EXTRACT_CMDS
	cp $(HOST_ZYNQ_BOOT_BIN_DL_DIR)/$(ZYNQ_BOOT_BIN_SOURCE) $(@D)
endef

define HOST_ZYNQ_BOOT_BIN_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/$(ZYNQ_BOOT_BIN_SOURCE) $(HOST_DIR)/bin/$(ZYNQ_BOOT_BIN_SOURCE)
endef

$(eval $(host-generic-package))
