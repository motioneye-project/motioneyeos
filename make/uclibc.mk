#############################################################
#
# uClibc (the C library)
#
#############################################################

ifeq ($(USE_UCLIBC_SNAPSHOT),true)
# Be aware that this changes daily....
UCLIBC_DIR=$(BUILD_DIR)/uClibc
UCLIBC_SOURCE=uClibc-snapshot.tar.bz2
else
UCLIBC_DIR:=$(BUILD_DIR)/uClibc-0.9.11
UCLIBC_SOURCE:=uClibc-0.9.11.tar.bz2
endif
#UCLIBC_URI:=http://www.uclibc.org/downloads
UCLIBC_URI:=http://de.busybox.net/downloads/uClibc
ifeq ($(strip $(BUILD_WITH_LARGEFILE)),true)
LARGEFILE=true
else
LARGEFILE=false
endif
ifneq ($(CROSS),)
CROSSARG:=--cross="$(CROSS)"
endif

$(DL_DIR)/$(UCLIBC_SOURCE):
	wget -P $(DL_DIR) --passive-ftp $(UCLIBC_URI)/$(UCLIBC_SOURCE)

uclibc-source: $(DL_DIR)/$(UCLIBC_SOURCE)

$(UCLIBC_DIR)/.unpacked: $(DL_DIR)/$(UCLIBC_SOURCE)
	rm -rf $(UCLIBC_DIR)
	bzcat $(DL_DIR)/$(UCLIBC_SOURCE) | tar -C $(BUILD_DIR) -xvf - 
	touch $(UCLIBC_DIR)/.unpacked

$(UCLIBC_DIR)/.configured: $(UCLIBC_DIR)/.unpacked
	$(UCLIBC_DIR)/extra/Configs/uClibc_config_fix.pl \
		--arch=$(ARCH) \
		$(CROSSARG) --c99_math=true \
		--devel_prefix=$(STAGING_DIR) \
		--float=true \
		--kernel_dir=$(LINUX_DIR) \
		--large_file=$(LARGEFILE) \
		--ldso_path="/lib" \
		--long_long=true \
		--rpc_support=true \
		--shadow=true \
		--shared_support=true \
		--threads=true \
		--debug=false \
		--file=$(UCLIBC_DIR)/extra/Configs/Config.$(ARCH) \
		> $(UCLIBC_DIR)/Config; 
	perl -i -p -e 's,SYSTEM_DEVEL_PREFIX.*,SYSTEM_DEVEL_PREFIX=$(STAGING_DIR)/usr,g' $(UCLIBC_DIR)/Config

	touch $(UCLIBC_DIR)/.configured

$(UCLIBC_DIR)/lib/libc.a: $(UCLIBC_DIR)/.configured
	$(MAKE) -C $(UCLIBC_DIR)

$(STAGING_DIR)/lib/libc.a: $(UCLIBC_DIR)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) install

$(TARGET_DIR)/lib/libc.so.0: $(STAGING_DIR)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) PREFIX=$(TARGET_DIR) \
		DEVEL_PREFIX=/ install_runtime install_target_utils

uclibc: $(LINUX_KERNEL) $(TARGET_DIR)/lib/libc.so.0

uclibc-clean:
	rm -f $(TARGET_DIR)/lib/libc.so.0
	-make -C $(UCLIBC_DIR) clean
	rm -f $(UCLIBC_DIR)/Config

uclibc-dirclean:
	rm -rf $(UCLIBC_DIR)
