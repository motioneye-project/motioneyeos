#############################################################
#
# Linux kernel targets
#
# Note:  If you have any patched to apply, create the directory
# sources/kernel-patches and put your patches in there and number
# them in the order you wish to apply them...  i.e.
#
#   sources/kernel-patches/001-my-special-stuff.bz2
#   sources/kernel-patches/003-gcc-Os.bz2
#   sources/kernel-patches/004_no-warnings.bz2
#   sources/kernel-patches/030-lowlatency-mini.bz2
#   sources/kernel-patches/031-lowlatency-fixes-5.bz2
#   sources/kernel-patches/099-shutup.bz2
#
# these patched will all be applied by the patch-kernel.sh
# script (which will also abort the build if it finds rejects)
#  -Erik
#
#############################################################
ifneq ($(filter $(TARGETS),linux),)

LINUX_KERNEL=$(BUILD_DIR)/buildroot-kernel
LINUX_DIR=$(BUILD_DIR)/linux-2.4.20
#LINUX_FORMAT=bzImage
#LINUX_BINLOC=arch/$(ARCH)/boot/$(LINUX_FORMAT)
LINUX_FORMAT=zImage.prep
LINUX_BINLOC=arch/ppc/boot/images/$(LINUX_FORMAT)
LINUX_SOURCE=linux-2.4.20.tar.bz2
LINUX_SITE=http://ftp.us.kernel.org/pub/linux/kernel/v2.4
LINUX_KCONFIG=$(SOURCE_DIR)/linux.config
LINUX_VERSION=$(shell grep -s UTS_RELEASE $(LINUX_DIR)/include/linux/version.h | cut -f 2 -d \" ||  echo \"2.4.20\" )

$(DL_DIR)/$(LINUX_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LINUX_SITE)/$(LINUX_SOURCE)

$(LINUX_DIR)/.dist: $(DL_DIR)/$(LINUX_SOURCE)
	rm -rf $(LINUX_DIR)
	bzcat $(DL_DIR)/$(LINUX_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	mkdir -p $(SOURCE_DIR)/kernel-patches
	$(SOURCE_DIR)/patch-kernel.sh $(LINUX_DIR) $(SOURCE_DIR)/kernel-patches
	touch $(LINUX_DIR)/.dist

$(LINUX_KCONFIG):
	@if [ ! -f "$(LINUX_KCONFIG)" ] ; then \
		echo ""; \
		echo "You should create a .config for your kernel"; \
		echo "and install it as $(LINUX_KCONFIG)"; \
		echo ""; \
		sleep 5; \
	fi;

$(LINUX_DIR)/.configured:  $(LINUX_DIR)/.dist  $(LINUX_KCONFIG)
	#perl -i -p -e "s,^CROSS_COMPILE.*,\
	#	CROSS_COMPILE=$(STAGING_DIR)/bin/$(ARCH)-uclibc-,g;" \
	#	$(LINUX_DIR)/Makefile
	-cp $(LINUX_KCONFIG) $(LINUX_DIR)/.config
	make -C $(LINUX_DIR) oldconfig include/linux/version.h
	touch $(LINUX_DIR)/.configured

$(LINUX_DIR)/.depend_done:  $(LINUX_DIR)/.configured
	make -C $(LINUX_DIR) dep
	touch $(LINUX_DIR)/.depend_done

$(LINUX_DIR)/$(LINUX_BINLOC): $(LINUX_DIR)/.depend_done
	make -C $(LINUX_DIR) $(LINUX_FORMAT)
	make -C $(LINUX_DIR) modules

$(LINUX_KERNEL): $(LINUX_DIR)/$(LINUX_BINLOC)
	cp -fa $(LINUX_DIR)/$(LINUX_BINLOC) $(LINUX_KERNEL)

$(TARGET_DIR)/lib/modules/$(LINUX_VERSION)/modules.dep: $(LINUX_KERNEL)
	rm -rf $(TARGET_DIR)/lib/modules
	rm -f $(TARGET_DIR)/sbin/cardmgr
	make -C $(LINUX_DIR) INSTALL_MOD_PATH=$(TARGET_DIR) modules_install
	(cd $(TARGET_DIR)/lib/modules; ln -s $(LINUX_VERSION)/kernel/drivers .)

$(STAGING_DIR)/include/linux/version.h: $(LINUX_DIR)/.configured
	mkdir -p $(STAGING_DIR)/include
	tar -ch -C $(LINUX_DIR)/include -f - linux | tar -xf - -C $(STAGING_DIR)/include/
	tar -ch -C $(LINUX_DIR)/include -f - asm | tar -xf - -C $(STAGING_DIR)/include/

linux: $(STAGING_DIR)/include/linux/version.h $(TARGET_DIR)/lib/modules/$(LINUX_VERSION)/modules.dep

# Rename this so it is cleaned by default on a make clean
linuxclean: clean
	rm -f $(LINUX_KERNEL)
	-make -C $(LINUX_DIR) clean

linux-dirclean:
	rm -rf $(LINUX_DIR)

#############################################################
#
# Setup the kernel headers, but don't compile anything for the target yet,
# since we still need to build a cross-compiler to do that little task for
# us...  Try to work around this little chicken-and-egg problem..
#
#############################################################
linux_headers: $(LINUX_DIR)/.configured

endif
