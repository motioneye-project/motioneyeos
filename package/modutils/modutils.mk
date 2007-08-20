#############################################################
#
# modutils
#
#############################################################
MODUTILS_VERSION:=2.4.27
MODUTILS_SOURCE=modutils-$(MODUTILS_VERSION).tar.bz2
MODUTILS_CAT:=$(BZCAT)
MODUTILS_SITE=http://ftp.kernel.org/pub/linux/utils/kernel/modutils/v2.4/
MODUTILS_DIR1=$(BUILD_DIR)/modutils-$(MODUTILS_VERSION)
MODUTILS_DIR2=$(TOOL_BUILD_DIR)/modutils-$(MODUTILS_VERSION)
MODUTILS_BINARY=depmod
MODUTILS_TARGET_BINARY=sbin/$(MODUTILS_BINARY)

STRIPPROG=$(STRIP)

$(DL_DIR)/$(MODUTILS_SOURCE):
	$(WGET) -P $(DL_DIR) $(MODUTILS_SITE)/$(MODUTILS_SOURCE)

#############################################################
#
# build modutils for use on the target system
#
#############################################################
$(MODUTILS_DIR1)/.source: $(DL_DIR)/$(MODUTILS_SOURCE)
	$(MODUTILS_CAT) $(DL_DIR)/$(MODUTILS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(MODUTILS_DIR1) \
		package/modutils \*.patch
	touch $(MODUTILS_DIR1)/.source

$(MODUTILS_DIR1)/.configured: $(MODUTILS_DIR1)/.source
	(cd $(MODUTILS_DIR1); \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		INSTALL=$(MODUTILS_DIR1)/install-sh \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
		--sysconfdir=/etc \
	);
	touch $(MODUTILS_DIR1)/.configured

$(MODUTILS_DIR1)/.build: $(MODUTILS_DIR1)/.configured
	$(MAKE1) CC=$(TARGET_CC) -C $(MODUTILS_DIR1)
	touch $@

$(STAGING_DIR)/$(MODUTILS_TARGET_BINARY): $(MODUTILS_DIR1)/.build
	STRIPPROG='$(STRIPPROG)' \
	$(MAKE) prefix=$(STAGING_DIR) -C $(MODUTILS_DIR1) install-bin
	touch -c $@

$(TARGET_DIR)/sbin/rmmod: $(STAGING_DIR)/$(MODUTILS_TARGET_BINARY)
	cp -dpf $(STAGING_DIR)/sbin/depmod	$(TARGET_DIR)/sbin/depmod
	cp -dpf $(STAGING_DIR)/sbin/insmod	$(TARGET_DIR)/sbin/insmod
	cp -dpf $(STAGING_DIR)/sbin/modinfo	$(TARGET_DIR)/sbin/modinfo
	ln -s	insmod $(TARGET_DIR)/sbin/kallsyms
	ln -s	insmod $(TARGET_DIR)/sbin/ksyms
	ln -s	insmod $(TARGET_DIR)/sbin/lsmod
	ln -s	insmod $(TARGET_DIR)/sbin/modprobe
	ln -s	insmod $(TARGET_DIR)/sbin/rmmod



modutils: uclibc $(TARGET_DIR)/sbin/rmmod

modutils-source: $(DL_DIR)/$(MODUTILS_SOURCE)

modutils-clean:
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(MODUTILS_DIR1) uninstall
	-$(MAKE) -C $(MODUTILS_DIR1) clean

modutils-dirclean:
	rm -rf $(MODUTILS_DIR1)

modutils-target-clean:
	rm -f $(TARGET_DIR)/sbin/depmod
	rm -f $(TARGET_DIR)/sbin/insmod
	rm -f $(TARGET_DIR)/sbin/modinfo
	rm -f $(TARGET_DIR)/sbin/kallsyms
	rm -f $(TARGET_DIR)/sbin/ksyms
	rm -f $(TARGET_DIR)/sbin/lsmod
	rm -f $(TARGET_DIR)/sbin/modprobe
	rm -f $(TARGET_DIR)/sbin/rmmod

#############################################################
#
# build modutils for use on the host system
#
#############################################################
ifeq ($(strip $(BR2_mips)),y)
DEPMOD_EXTRA_STUFF=CFLAGS=-D__MIPSEB__
endif
ifeq ($(strip $(BR2_mipsel)),y)
DEPMOD_EXTRA_STUFF=CFLAGS=-D__MIPSEL__
endif

$(MODUTILS_DIR2)/.source: $(DL_DIR)/$(MODUTILS_SOURCE)
	$(MODUTILS_CAT) $(DL_DIR)/$(MODUTILS_SOURCE) | tar -C $(TOOL_BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(MODUTILS_DIR2) \
		package/modutils \*.patch
	touch $(MODUTILS_DIR2)/.source

$(MODUTILS_DIR2)/.configured: $(MODUTILS_DIR2)/.source
	(cd $(MODUTILS_DIR2); \
		./configure $(DEPMOD_EXTRA_STUFF) \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_HOST_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
		--sysconfdir=/etc \
	);
	touch $(MODUTILS_DIR2)/.configured;

$(MODUTILS_DIR2)/$(MODUTILS_BINARY): $(MODUTILS_DIR2)/.configured
	$(MAKE1) -C $(MODUTILS_DIR2)
	touch -c $(MODUTILS_DIR2)/$(MODUTILS_BINARY)

$(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-depmod: $(MODUTILS_DIR2)/$(MODUTILS_BINARY)
	mkdir -p $(STAGING_DIR)/bin
	cp $(MODUTILS_DIR2)/$(MODUTILS_BINARY) $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-depmod
	touch -c $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-depmod

cross-depmod: uclibc $(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-depmod

cross-depmod-source: $(DL_DIR)/$(MODUTILS_SOURCE)

cross-depmod-clean:
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(MODUTILS_DIR2) uninstall
	-$(MAKE) -C $(MODUTILS_DIR2) clean

cross-depmod-dirclean:
	rm -rf $(MODUTILS_DIR2)



#############################################################
#
## Toplevel Makefile options
#
##############################################################
ifeq ($(strip $(BR2_PACKAGE_MODUTILS)),y)
TARGETS+=modutils
endif
