#############################################################
#
# ltp-testsuite
#
#############################################################
LTP_TESTSUITE_VERSION:=20061121
LTP_TESTSUITE_SOURCE:=ltp-full-$(LTP_TESTSUITE_VERSION).tgz
LTP_TESTSUITE_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/ltp
LTP_TESTSUITE_CAT:=$(ZCAT)
LTP_TESTSUITE_ROOT:=$(TARGET_DIR)/root
LTP_TESTSUITE_DIR:=$(LTP_TESTSUITE_ROOT)/ltp-full-$(LTP_TESTSUITE_VERSION)

#
# We enable Open POSIX Testsuite if Native POSIX Threads Library (NPTL)
# is selected. Otherwise, we filter out the patch for it.
#
LTP_PATCHES:=$(subst package/ltp-testsuite/,,				 \
	     $(wildcard package/ltp-testsuite/*.patch))
ifneq ($(BR2_PTHREADS_NATIVE),y)
LTP_PATCHES:=$(filter-out ltp-testsuite-enable-openposix-for-nptl.patch, \
	     $(LTP_PATCHES))
endif


$(DL_DIR)/$(LTP_TESTSUITE_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LTP_TESTSUITE_SITE)/$(LTP_TESTSUITE_SOURCE)

ltp-testsuite-source: $(DL_DIR)/$(LTP_TESTSUITE_SOURCE)

$(LTP_TESTSUITE_DIR)/Makefile: $(DL_DIR)/$(LTP_TESTSUITE_SOURCE)
	$(LTP_TESTSUITE_CAT) $(DL_DIR)/$(LTP_TESTSUITE_SOURCE) | tar -C $(LTP_TESTSUITE_ROOT) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LTP_TESTSUITE_DIR) package/ltp-testsuite/ $(LTP_PATCHES)
	touch -c $(LTP_TESTSUITE_DIR)/Makefile

$(LTP_TESTSUITE_DIR)/.compiled: $(LTP_TESTSUITE_DIR)/Makefile
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) CROSS_COMPILER=$(TARGET_CROSS) \
		-C $(LTP_TESTSUITE_DIR) all
	touch $(LTP_TESTSUITE_DIR)/.compiled

$(LTP_TESTSUITE_DIR)/.installed: $(LTP_TESTSUITE_DIR)/.compiled
	# Use fakeroot to pretend to do 'make install' as root
	echo "$(MAKE1) $(TARGET_CONFIGURE_OPTS) CROSS_COMPILER=$(TARGET_CROSS) " \
			"-C $(LTP_TESTSUITE_DIR) install" \
			> $(STAGING_DIR)/.fakeroot.ltp
	touch $(LTP_TESTSUITE_DIR)/.installed

ltp-testsuite: uclibc host-fakeroot $(LTP_TESTSUITE_DIR)/.installed

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
