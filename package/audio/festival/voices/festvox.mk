#############################################################
#
# festival voices
#
#############################################################
VOICE1 = festvox_cmu_us_awb_arctic_hts.tar.gz
VOICE2 = festvox_cmu_us_bdl_arctic_hts.tar.gz
VOICE3 = festvox_cmu_us_jmk_arctic_hts.tar.gz
VOICE4 = festvox_cmu_us_slt_arctic_hts.tar.gz
VOICE5 = festvox_cstr_us_awb_arctic_multisyn-1.0.tar.gz
VOICE6 = festvox_cstr_us_jmk_arctic_multisyn-1.0.tar.gz
VOICE7 = festvox_kallpc16k.tar.gz
VOICE8 = festvox_kedlpc8k.tar.gz
VOICE9 = festvox_kedlpc16k.tar.gz
FRONTEND1 = festvox_us1.tar.gz
FRONTEND2 = festvox_us2.tar.gz
FRONTEND3 = festvox_us3.tar.gz
FESTVOX_STATUS_DIR = $(BUILD_DIR)/festival_voices
FESTVOX_INSTALL_DIR = $(TARGET_DIR)/usr/share

$(FESTVOX_STATUS_DIR)/.downloaded:
	mkdir -p $(FESTVOX_STATUS_DIR)
ifeq ($(BR2_PACKAGE_FESTVOX_AWB),y)
	$(Q)test -e $(DL_DIR)/$(VOICE1) || $(WGET) -P $(DL_DIR) $(FESTIVAL_SITE)/$(VOICE1)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_BDL),y)
	$(Q)test -e $(DL_DIR)/$(VOICE2) || $(WGET) -P $(DL_DIR) $(FESTIVAL_SITE)/$(VOICE2)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_JMK),y)
	$(Q)test -e $(DL_DIR)/$(VOICE3) || $(WGET) -P $(DL_DIR) $(FESTIVAL_SITE)/$(VOICE3)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_SLT),y)
	$(Q)test -e $(DL_DIR)/$(VOICE4) || $(WGET) -P $(DL_DIR) $(FESTIVAL_SITE)/$(VOICE4)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_AWB_MULTISYN),y)
	$(Q)test -e $(DL_DIR)/$(VOICE5) || $(WGET) -P $(DL_DIR) $(FESTIVAL_SITE)/$(VOICE5)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_JMK_MULTISYN),y)
	$(Q)test -e $(DL_DIR)/$(VOICE6) || $(WGET) -P $(DL_DIR) $(FESTIVAL_SITE)/$(VOICE6)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_KAL_SIXTEENK),y)
	$(Q)test -e $(DL_DIR)/$(VOICE7) || $(WGET) -P $(DL_DIR) $(FESTIVAL_SITE)/$(VOICE7)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_KED_EIGHTK),y)
	$(Q)test -e $(DL_DIR)/$(VOICE8) || $(WGET) -P $(DL_DIR) $(FESTIVAL_SITE)/$(VOICE8)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_KED_SIXTEENK),y)
	$(Q)test -e $(DL_DIR)/$(VOICE9) || $(WGET) -P $(DL_DIR) $(FESTIVAL_SITE)/$(VOICE9)
endif
	$(Q)test -e $(DL_DIR)/$(FRONTEND1) || $(WGET) -P $(DL_DIR) $(FESTIVAL_SITE)/$(FRONTEND1)
	$(Q)test -e $(DL_DIR)/$(FRONTEND2) || $(WGET) -P $(DL_DIR) $(FESTIVAL_SITE)/$(FRONTEND2)
	$(Q)test -e $(DL_DIR)/$(FRONTEND3) || $(WGET) -P $(DL_DIR) $(FESTIVAL_SITE)/$(FRONTEND3)

	touch $@

$(FESTVOX_STATUS_DIR)/.installed: $(FESTVOX_STATUS_DIR)/.downloaded
ifeq ($(BR2_PACKAGE_FESTVOX_AWB),y)
	tar -xvf $(DL_DIR)/$(VOICE1) --directory $(FESTVOX_INSTALL_DIR)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_BDL),y)
	tar -xvf $(DL_DIR)/$(VOICE2) --directory $(FESTVOX_INSTALL_DIR)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_JMK),y)
	tar -xvf $(DL_DIR)/$(VOICE3) --directory $(FESTVOX_INSTALL_DIR)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_SLT),y)
	tar -xvf $(DL_DIR)/$(VOICE4) --directory $(FESTVOX_INSTALL_DIR)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_AWB_MULTISYN),y)
	tar -xvf $(DL_DIR)/$(VOICE5) --directory $(FESTVOX_INSTALL_DIR)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_JMK_MULTISYN),y)
	tar -xvf $(DL_DIR)/$(VOICE6) --directory $(FESTVOX_INSTALL_DIR)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_KAL_SIXTEENK),y)
	tar -xvf $(DL_DIR)/$(VOICE7) --directory $(FESTVOX_INSTALL_DIR)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_KED_EIGHTK),y)
	tar -xvf $(DL_DIR)/$(VOICE8) --directory $(FESTVOX_INSTALL_DIR)
endif
ifeq ($(BR2_PACKAGE_FESTVOX_KED_SIXTEENK),y)
	tar -xvf $(DL_DIR)/$(VOICE9) --directory $(FESTVOX_INSTALL_DIR)
endif
	tar -xvf $(DL_DIR)/$(FRONTEND1) --directory $(FESTVOX_INSTALL_DIR)
	tar -xvf $(DL_DIR)/$(FRONTEND2) --directory $(FESTVOX_INSTALL_DIR)
	tar -xvf $(DL_DIR)/$(FRONTEND3) --directory $(FESTVOX_INSTALL_DIR)

	touch $@

festvox: $(FESTVOX_STATUS_DIR)/.installed

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_FESTIVAL)),y)
TARGETS+=festvox
endif
