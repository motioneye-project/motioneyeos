#############################################################
#
# ltp-testsuite
#
#############################################################
LTP_TESTSUITE_SOURCE:=ltp-full-20050707.tgz
LTP_TESTSUITE_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/ltp
LTP_TESTSUITE_CAT:=zcat
LTP_TESTSUITE_ROOT:=$(TARGET_DIR)/root
LTP_TESTSUITE_DIR:=$(LTP_TESTSUITE_ROOT)/ltp-full-20050707


$(DL_DIR)/$(LTP_TESTSUITE_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LTP_TESTSUITE_SITE)/$(LTP_TESTSUITE_SOURCE)

ltp-testsuite-source: $(DL_DIR)/$(LTP_TESTSUITE_SOURCE)

$(LTP_TESTSUITE_DIR)/.unpacked: $(DL_DIR)/$(LTP_TESTSUITE_SOURCE)
	$(LTP_TESTSUITE_CAT) $(DL_DIR)/$(LTP_TESTSUITE_SOURCE) | tar -C $(LTP_TESTSUITE_ROOT) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LTP_TESTSUITE_DIR) package/ltp-testsuite/ ltp-testsuite\*.patch
	touch $(LTP_TESTSUITE_DIR)/.unpacked

$(LTP_TESTSUITE_DIR)/testcases/kernel/syscalls/write/write01: $(LTP_TESTSUITE_DIR)/.unpacked
	$(MAKE) $(TARGET_CONFIGURE_OPTS) CROSS_COMPILER=$(TARGET_CROSS) \
		-C $(LTP_TESTSUITE_DIR) all
	touch -c $(LTP_TESTSUITE_DIR)/testcases/kernel/syscalls/write/write01

$(LTP_TESTSUITE_DIR)/testcases/bin/1K_file: $(LTP_TESTSUITE_DIR)/testcases/kernel/syscalls/write/write01
	# Use fakeroot to pretend to do 'make install' as root
	$(STAGING_DIR)/usr/bin/fakeroot \
	$(MAKE) $(TARGET_CONFIGURE_OPTS) CROSS_COMPILER=$(TARGET_CROSS) \
		-C $(LTP_TESTSUITE_DIR) install
	touch -c $(LTP_TESTSUITE_DIR)/testcases/bin/1K_file

ltp-testsuite: uclibc host-fakeroot $(LTP_TESTSUITE_DIR)/testcases/bin/1K_file

ltp-testsuite-clean:
	$(MAKE) -C $(LTP_TESTSUITE_DIR) clean

ltp-testsuite-dirclean:
	rm -rf $(LTP_TESTSUITE_DIR)


#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LTP-TESTSUITE)),y)
TARGETS+=ltp-testsuite
endif
