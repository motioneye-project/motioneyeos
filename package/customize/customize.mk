#############################################################
#
# Any custom stuff you feel like doing....
#
#############################################################
CUST_DIR:=package/customize/source

customize:
	-cp -af $(CUST_DIR)/* $(TARGET_DIR)/
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_CUSTOMIZE)),y)
TARGETS+=customize
endif
