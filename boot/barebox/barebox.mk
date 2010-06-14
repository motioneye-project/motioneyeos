#############################################################
#
# Barebox
#
#############################################################

BAREBOX_VERSION:=2010.05.0
BAREBOX_SOURCE:=barebox-$(BAREBOX_VERSION).tar.bz2
BAREBOX_SITE:=http://www.barebox.org/download/
BAREBOX_DIR:=$(BUILD_DIR)/barebox-$(BAREBOX_VERSION)
BAREBOX_CAT:=$(BZCAT)
BAREBOX_BOARD_DEFCONFIG:=$(call qstrip,$(BR2_TARGET_BAREBOX_BOARD_DEFCONFIG))

ifeq ($(KERNEL_ARCH),i386)
BAREBOX_ARCH=x86
else ifeq ($(KERNEL_ARCH),powerpc)
BAREBOX_ARCH=ppc
else
BAREBOX_ARCH=$(KERNEL_ARCH)
endif

BAREBOX_MAKE_FLAGS = ARCH=$(BAREBOX_ARCH) CROSS_COMPILE=$(TARGET_CROSS)

$(DL_DIR)/$(BAREBOX_SOURCE):
	 $(call DOWNLOAD,$(BAREBOX_SITE),$(BAREBOX_SOURCE))

$(BAREBOX_DIR)/.unpacked: $(DL_DIR)/$(BAREBOX_SOURCE)
	mkdir -p $(@D)
	$(INFLATE$(suffix $(BAREBOX_SOURCE))) $(DL_DIR)/$(BAREBOX_SOURCE) \
		| tar $(TAR_STRIP_COMPONENTS)=1 -C $(@D) $(TAR_OPTIONS) -
	touch $@

$(BAREBOX_DIR)/.patched: $(BAREBOX_DIR)/.unpacked
	toolchain/patch-kernel.sh $(BAREBOX_DIR) boot/barebox \
		barebox-$(BAREBOX_VERSION)-\*.patch \
		barebox-$(BAREBOX_VERSION)-\*.patch.$(ARCH)
	touch $@

$(BAREBOX_DIR)/.configured: $(BAREBOX_DIR)/.patched
	$(MAKE) $(BAREBOX_MAKE_FLAGS) -C $(BAREBOX_DIR) $(BAREBOX_BOARD_DEFCONFIG)_defconfig
	touch $@

$(BAREBOX_DIR)/.built: $(BAREBOX_DIR)/.configured
	$(MAKE) $(BAREBOX_MAKE_FLAGS) -C $(BAREBOX_DIR)
	touch $@

$(BAREBOX_DIR)/.installed: $(BAREBOX_DIR)/.built
	cp $(BAREBOX_DIR)/barebox.bin $(BINARIES_DIR)
	touch $@

barebox: $(BAREBOX_DIR)/.installed

ifeq ($(BR2_TARGET_BAREBOX),y)
TARGETS+=barebox

# we NEED a board defconfig file
ifeq ($(BAREBOX_BOARD_DEFCONFIG),)
$(error No Barebox defconfig file. Check your BR2_TARGET_BAREBOX_BOARD_DEFCONFIG setting)
endif

endif
