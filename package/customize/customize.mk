#############################################################
#
# Any custom stuff you feel like doing....
#
#############################################################
CUST_DIR:=package/customize/source

customize:
	-cp -af $(CUST_DIR)/* $(TARGET_DIR)/
