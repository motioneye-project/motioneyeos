#############################################################
#
# Any custom stuff you feel like doing....
#
#############################################################
CUST_DIR:=$(BASE_DIR)/Erik-Router
ROOT_DIR:=$(BUILD_DIR)/root

customize:
	cp $(CUST_DIR)/ext2root.mk $(BASE_DIR)/make/
	cp $(CUST_DIR)/interfaces $(ROOT_DIR)/etc/network/
	cp $(CUST_DIR)/eth* $(ROOT_DIR)/etc/network/
	chmod a+x $(ROOT_DIR)/etc/network/eth*
	cp $(CUST_DIR)/inittab $(ROOT_DIR)/etc/
	cp $(CUST_DIR)/vtun* $(ROOT_DIR)/etc/
	cp $(CUST_DIR)/udhcp* $(ROOT_DIR)/etc/
	cp $(CUST_DIR)/shadow $(ROOT_DIR)/etc/
	cp $(CUST_DIR)/wireless $(ROOT_DIR)/etc/pcmcia/
	cp $(CUST_DIR)/resolv.conf $(ROOT_DIR)/etc/
	cp $(CUST_DIR)/ssh_host* $(ROOT_DIR)/etc/
	chmod go-r $(ROOT_DIR)/etc/ssh_host*
