################################################################################
#
# checksec
#
################################################################################

CHECKSEC_VERSION = cdefe53eb72e6e8f23308417d2fc6b68cba9dbac
CHECKSEC_SITE = $(call github,slimm609,checksec.sh,$(CHECKSEC_VERSION))
CHECKSEC_LICENSE = BSD-3-Clause
CHECKSEC_LICENSE_FILES = LICENSE.txt

define HOST_CHECKSEC_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/checksec $(HOST_DIR)/bin/checksec
endef

$(eval $(host-generic-package))
