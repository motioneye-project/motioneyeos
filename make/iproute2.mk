#############################################################
#
# iproute2
#
#############################################################
IPROUTE2_SOURCE_URL=ftp://ftp.inr.ac.ru/ip-routing/iproute2-2.4.7-now-ss020116-try.tar.gz
IPROUTE2_SOURCE=iproute2-2.4.7-now-ss020116-try.tar.gz
IPROUTE2_BUILD_DIR=$(BUILD_DIR)/iproute2

$(DL_DIR)/$(IPROUTE2_SOURCE):
	 $(WGET) -P $(DL_DIR) $(IPROUTE2_SOURCE_URL)

hostap-source: $(DL_DIR)/$(IPROUTE2_SOURCE)

$(IPROUTE2_BUILD_DIR)/.unpacked: $(DL_DIR)/$(IPROUTE2_SOURCE)
	zcat $(DL_DIR)/$(IPROUTE2_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(IPROUTE2_BUILD_DIR)/.unpacked

$(IPROUTE2_BUILD_DIR)/.configured: $(IPROUTE2_BUILD_DIR)/.unpacked
	perl -pi -e "s,-I/usr/include/db3,," $(IPROUTE2_BUILD_DIR)/Makefile
	perl -pi -e "s,^KERNEL_INCLUDE.*,KERNEL_INCLUDE=$(LINUX_DIR)/include," \
		$(IPROUTE2_BUILD_DIR)/Makefile
	perl -pi -e "s,^LIBC_INCLUDE.*,LIBC_INCLUDE=$(STAGING_DIR)/include," \
		$(IPROUTE2_BUILD_DIR)/Makefile
	# For now disable compiling of the misc directory because it seems to fail
	rm -rf $(IPROUTE2_BUILD_DIR)/misc 
	perl -pi -e "s, misc,," $(IPROUTE2_BUILD_DIR)/Makefile
	touch  $(IPROUTE2_BUILD_DIR)/.configured

$(IPROUTE2_BUILD_DIR)/tc/tc: $(IPROUTE2_BUILD_DIR)/.configured
	$(MAKE) -C $(IPROUTE2_BUILD_DIR) KERNEL_INCLUDE=$(LINUX_SOURCE_DIR)/include CC=$(TARGET_CC)

$(TARGET_DIR)/usr/sbin/tc: $(IPROUTE2_BUILD_DIR)/tc/tc
	# Copy The tc binary
	cp -af $(IPROUTE2_BUILD_DIR)/tc/tc $(TARGET_DIR)/usr/sbin/

iproute2: $(TARGET_DIR)/usr/sbin/tc 

iproute2-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(IPROUTE2_BUILD_DIR) uninstall
	-$(MAKE) -C $(IPROUTE2_BUILD_DIR) clean

iproute2-dirclean:
	rm -rf $(IPROUTE2_BUILD_DIR)

