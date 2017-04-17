################################################################################
#
# sam-ba
#
################################################################################

SAM_BA_SITE = http://www.atmel.com/dyn/resources/prod_documents
SAM_BA_VERSION = 2.16
SAM_BA_SOURCE = sam-ba_$(SAM_BA_VERSION)_linux.zip
SAM_BA_LICENSE = SAM-BA license (sam-ba executable), \
		BSD-2-Clause like, BSD-4-Clause (TCL and applets code)
SAM_BA_LICENSE_FILES = doc/license.txt tcl_lib/boards.tcl \
		applets/sam4c/libraries/libchip_sam4c/include/sam4c/sam4c32e-1.h

define HOST_SAM_BA_EXTRACT_CMDS
	$(UNZIP) -d $(BUILD_DIR) $(DL_DIR)/$(SAM_BA_SOURCE)
	mv $(BUILD_DIR)/sam-ba_cdc_linux/* $(@D)
	rmdir $(BUILD_DIR)/sam-ba_cdc_linux/
endef

# Since it's a prebuilt application and it does not conform to the
# usual Unix hierarchy, we install it in $(HOST_DIR)/opt/sam-ba and
# then create a symbolic link from $(HOST_DIR)/usr/bin to the
# application binary, for easier usage.

define HOST_SAM_BA_INSTALL_CMDS
	mkdir -p $(HOST_DIR)/opt/sam-ba/
	cp -a $(@D)/* $(HOST_DIR)/opt/sam-ba/
	ln -sf ../../opt/sam-ba/sam-ba $(HOST_DIR)/usr/bin/sam-ba
endef

$(eval $(host-generic-package))
