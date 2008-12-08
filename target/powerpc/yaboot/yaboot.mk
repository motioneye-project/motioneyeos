ifeq ($(ARCH),powerpc)

#############################################################
#
# yaboot
#
#############################################################

YABOOT_SOURCE:=yaboot-1.3.13.tar.gz
YABOOT_SITE:=http://penguinppc.org/bootloaders/yaboot
YABOOT_DIR:=$(BUILD_DIR)/yaboot-1.3.13

$(DL_DIR)/$(YABOOT_SOURCE):
	 $(WGET) -P $(DL_DIR) $(YABOOT_SITE)/$(YABOOT_SOURCE)

yaboot-source: $(DL_DIR)/$(YABOOT_SOURCE)

$(YABOOT_DIR)/Makefile: $(DL_DIR)/$(YABOOT_SOURCE)
	$(ZCAT) $(DL_DIR)/$(YABOOT_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch -c $(YABOOT_DIR)/Makefile

$(YABOOT_DIR)/second/yaboot: $(YABOOT_DIR)/Makefile
	$(MAKE) -C $(YABOOT_DIR) CROSS=$(TARGET_CROSS)
	touch -c $(YABOOT_DIR)/second/yaboot

yaboot: $(YABOOT_DIR)/second/yaboot

yaboot-clean:
	$(MAKE) -C $(YABOOT_DIR) clean

yaboot-dirclean:
	rm -rf $(YABOOT_DIR)

endif

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_YABOOT),y)
TARGETS+=yaboot
endif

